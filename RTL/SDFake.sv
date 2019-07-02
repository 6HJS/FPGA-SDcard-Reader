module SDFake(
    input  logic rst_n,
    // 1bit SD clk
    input  logic sdclk,
    // 1bit SD CMD
    output logic sdcmdoe, sdcmdout, 
    input  logic sdcmdin,
    // 4bit SD DAT
    output logic sddatoe,
    output logic [3:0] sddatout,
    input  logic [3:0] sddatin,
    // data read interface
    output logic rdclk,
    output logic [63:0] rdaddr,
    input  logic [ 7:0] rddata,
    // debug LED
    output logic [7:0] debugled
);

initial begin sdcmdoe  = '0;   sdcmdout = '1; sddatoe  = '0;   sddatout = '1; end

initial begin rdclk=1'b0; rdaddr=0; end

function automatic void CalcCrc7(ref [6:0] crc, input inbit);
    crc = {crc[5:0],crc[6]^inbit} ^ {3'b0,crc[6]^inbit,3'b0};
endfunction

function automatic void CalcCrc16(ref [15:0] crc, input inbit);
    crc = {crc[14:0],crc[15]^inbit} ^ {3'b0,crc[15]^inbit,6'b0,crc[15]^inbit,5'b0};
endfunction

localparam BLOCK_SIZE = 512;  // 512B per block
localparam logic[ 15:0] RCAINIT = 16'h0013;
localparam logic[119:0] CID_REG = 120'h02544d53_41303847_14394a67_c700e4;
localparam logic[119:0] CSD_REG = 120'h400e0032_5b590000_39b77f80_0a4020; // PERM_WRITE_PROTECT=1
localparam logic[ 31:0] OCR_REG = {1'b1,1'b1,6'b0,9'h1ff,7'b0,1'b0,7'b0}; // not busy, CCS=1(SDHC card), all voltage, not dual-voltage card
localparam logic[ 64:0] SCR_REG = 64'h0231_0000_00000000;

logic last_is_acmd=1'b0;
enum {WAITINGCMD, LOADRESP, RESPING} respstate = WAITINGCMD;

struct packed{
    logic [ 3:0] pre_st;
    logic [ 5:0] cmd;
    struct packed{
        logic [15:0] rca;
        logic [ 3:0] fill;
        logic [ 3:0] vhs;
        logic [ 7:0] checkmode;
    } arg;
    logic [ 6:0] crc;
    logic        stop;
} request = '0;

typedef enum logic [3:0] {IDLE, READY, IDENT, STBY, TRAN, DATA, RCV, PRG, DIS} current_state_t;

struct packed{
    logic out_of_range;
    logic address_error;
    logic block_len_error;
    logic erase_seq_error;
    logic erase_param;
    logic wp_violation;
    logic card_is_locked;
    logic lock_unlock_failed;
    logic com_crc_error;
    logic illegal_command;
    logic card_ecc_failed;
    logic cc_error;
    logic error;
    logic [1:0] rsvd1;   // rsvd means reserved
    logic csd_overwrite;
    logic wp_erase_skip;
    logic card_ecc_disabled;
    logic erase_reset;
    current_state_t current_state;
    logic ready_for_data;
    logic [1:0] rsvd2;
    logic app_cmd;
    logic rsvd3;
    logic ake_seq_error;
    logic [2:0] rsvd4;
} cardstatus = '0;
wire [15:0] cardstatus_short = {cardstatus[23:22], cardstatus[19], cardstatus[12:0]};  // for R6 (CMD3)

localparam HIGHZLEN = 1;
localparam WAITLEN  = HIGHZLEN + 3;
logic [  5:0] cmd='0;
logic [119:0] arg='0;
logic [  6:0] crc='0;

logic response_end = 1'b0;
logic valid='0, dummycrc='0;
int   idx=0, arglen=0;

task automatic response_init(logic _valid, logic _dummycrc, logic [5:0] _cmd, int _arglen, logic [119:0] _arg);
    cmd          = _cmd;
    arg          = _arg;
    crc          = '0;
    valid        = _valid;
    dummycrc     = _dummycrc;
    idx          = 0;
    arglen       = _arglen;
    response_end = 1'b0;
endtask

task automatic response_yield();
    response_end = 1'b0;
    if         (      ~valid) begin
        sdcmdoe  = 0;
        sdcmdout = 1;
        response_end = 1'b1;
    end else if(idx<HIGHZLEN) begin
        sdcmdoe  = 0;
        sdcmdout = 1;
    end else if(idx<WAITLEN) begin
        sdcmdoe  = 1;
        sdcmdout = 1;
    end else if(idx<WAITLEN+2) begin
        sdcmdoe  = 1;
        sdcmdout = 0;
        CalcCrc7(crc, sdcmdout);
    end else if(idx<WAITLEN+2+6) begin
        sdcmdoe  = 1;
        sdcmdout = cmd[ (WAITLEN+2+6)-1-idx ];
        CalcCrc7(crc, sdcmdout);
    end else if(idx<WAITLEN+2+6+arglen) begin
        sdcmdoe  = 1;
        sdcmdout = arg[ (WAITLEN+2+6+arglen)-1-idx ];
        CalcCrc7(crc, sdcmdout);
    end else if(idx<WAITLEN+2+6+arglen+7) begin
        sdcmdoe  = 1;
        sdcmdout = dummycrc ? 1'b1 : crc[ (WAITLEN+2+6+arglen+7)-1-idx ];
    end else if(idx<WAITLEN+2+6+arglen+8) begin
        sdcmdoe  = 1;
        sdcmdout = 1;
    end else begin
        sdcmdoe  = 0;
        sdcmdout = 1;
        response_end = 1'b1;
    end
    if(~response_end) idx++;
endtask

localparam DATAWAITLEN  = HIGHZLEN    + 9;
localparam DATASTARTLEN = DATAWAITLEN + 1;
logic read_task=0, read_continue=0, read_scr=0;
logic [31:0] read_idx = 0;
wire  [31:0] read_byte_idx = (read_idx-DATASTARTLEN);
wire  [ 2:0] readbyteidx = 3'd7 - read_byte_idx[2:0];
wire         readquadidx = ~ read_byte_idx[0];
logic [15:0] read_crc = 0;
logic widebus = 1'b0;  // 0:1bit Mode  1:4bit Mode

logic [5:0] lastcmd = 0;

assign debugled = { response_end, widebus, cardstatus.ready_for_data, cardstatus.app_cmd, cardstatus.current_state };

task automatic data_response_init(logic [31:0] _read_sector_no=0, logic _read_continue=1'b0);
    read_task      = 1;
    read_continue  = _read_continue;
    read_scr       = 0;
    rdaddr         = {23'h0,_read_sector_no,9'h0};
    read_idx       = 0;
    read_crc       = 0;
endtask

task automatic data_response_scr_init();
    read_task      = 1;
    read_continue  = 0;
    read_scr       = 1;
    rdaddr         = 0;
    read_idx       = 0;
    read_crc       = 0;
endtask

task automatic data_response_stop();
    read_task      = 0;
    read_continue  = 0;
    read_scr       = 0;
    rdaddr         = 0;
    read_idx       = 0;
    read_crc       = 0;
endtask

task automatic data_response_yield();
    rdclk='0;
    sddatoe  = 1'b1;
    if(~read_task) begin
        sddatoe  = 1'b0;
        sddatout = 4'hf;
    end else if(read_idx<    HIGHZLEN) begin
        sddatoe  = 1'b0;
        sddatout = 4'hf;
    end else if(read_idx< DATAWAITLEN) begin
        sddatout = 4'hf;
    end else if(read_idx<DATASTARTLEN) begin
        sddatout = 4'h0;
        if(~read_scr) rdclk=1'b1;
    end else if(~read_scr) begin                // the read task is reading data sector(s)
        if(widebus) begin
            if         (read_idx<DATASTARTLEN+(BLOCK_SIZE*2)) begin     // TODO: 4bit mode not support outside reader
                if( readquadidx ) begin
                    rdclk=1'b0;  rdaddr++;
                end else begin
                    if(read_idx<DATASTARTLEN+(BLOCK_SIZE*2)-1) rdclk=1'b1;
                end
                sddatout = rddata[readbyteidx*4+:4];
                for(int i=0;i<4;i++) CalcCrc16(read_crc,sddatout[3-i]);
            end else if(read_idx<DATASTARTLEN+(BLOCK_SIZE*2)+4) begin
                sddatout = read_crc[ ((DATASTARTLEN+(BLOCK_SIZE*2)+4)-1-read_idx)*4 +: 4 ];
            end else begin
                sddatout = 4'hf;
                if(read_continue)
                    read_idx  = HIGHZLEN;
                else
                    read_task = 0;
            end
        end else begin
            if         (read_idx<DATASTARTLEN+(BLOCK_SIZE*8)) begin
                if( readbyteidx==3'h7 ) begin
                    rdclk=1'b0;  rdaddr++;
                end else if( readbyteidx==3'h0 ) begin
                    if(read_idx<DATASTARTLEN+(BLOCK_SIZE*8)-1) rdclk=1'b1;
                end
                sddatout = {3'b111, rddata[readbyteidx]};
                CalcCrc16(read_crc,sddatout[0]);
            end else if(read_idx<DATASTARTLEN+(BLOCK_SIZE*8)+16) begin
                sddatout = {3'b111, read_crc[ (DATASTARTLEN+(BLOCK_SIZE*8)+16)-1-read_idx ]};
            end else begin
                sddatout = 4'hf;
                if(read_continue)
                    read_idx  = HIGHZLEN;
                else
                    read_task = 0;
            end
        end
    end else begin   // the read task is reading a SCR register
        if(widebus) begin
            if         (read_idx<DATASTARTLEN+16) begin
                sddatout =  SCR_REG[ ((DATASTARTLEN+16)-1-read_idx)*4 +: 4 ];
                for(int i=0;i<4;i++) CalcCrc16(read_crc,sddatout[3-i]);
            end else if(read_idx<DATASTARTLEN+16+4) begin
                sddatout = read_crc[ ((DATASTARTLEN+16+4)-1-read_idx)*4 +: 4 ];
            end else begin
                sddatout = 4'hf;
                read_task = 0;
            end
        end else begin
            if         (read_idx<DATASTARTLEN+64) begin
                sddatout = {3'b111, SCR_REG[ (DATASTARTLEN+64)-1-read_idx ] };
                CalcCrc16(read_crc,sddatout[0]);
            end else if(read_idx<DATASTARTLEN+64+16) begin
                sddatout = {3'b111, read_crc[ (DATASTARTLEN+64+16)-1-read_idx ]};
            end else begin
                sddatout = 4'hf;
                read_task = 0;
            end
        end
    end
    if(read_task) begin
        read_idx++;
        cardstatus.current_state = DATA;
    end else if(cardstatus.current_state==DATA) 
        cardstatus.current_state = TRAN;
endtask


always @ (posedge sdclk or negedge rst_n)
    if(~rst_n) begin
        respstate = WAITINGCMD;
        request   = '1;
    end else begin
        case(respstate)
        WAITINGCMD:  if(request.pre_st==4'b1101 && request.stop) begin
                         respstate = LOADRESP;
                     end else
                         request   = {request,sdcmdin};
        LOADRESP  :  respstate = RESPING;
        RESPING   :  if(response_end) begin
                         respstate = WAITINGCMD;
                         request   = '1;
                     end
        endcase
    end


always @ (negedge sdclk or negedge rst_n)
    if(~rst_n) begin
        last_is_acmd <= 1'b0;
        cardstatus = '0;
        lastcmd = '0;
        widebus = 0;
        response_init( 0, 0, 0, 0, 0 );
        data_response_stop();
        response_yield();
        data_response_yield();
    end else begin
        if(respstate==LOADRESP) begin
            last_is_acmd      <= 1'b0;
            cardstatus.app_cmd = 1'b0;
            cardstatus.block_len_error = 1'b0;
            lastcmd = request.cmd;
            case(request.cmd)
            0       : begin
                          response_init( 0, 0 ,           0 ,   0 ,   0                            );  // NO RESPONSE for CMD0
                          cardstatus.current_state = IDLE;
                          cardstatus.ready_for_data = 1'b1;
                          widebus = 0;
                      end
            2       : begin
                          response_init( 1, 0 ,   6'b000000 , 120 ,  CID_REG                       );  // R2 TODO: why cmd=111111 is invalid but 000000 ok ???
                          cardstatus.current_state = IDENT;
                      end
            3       : begin
                          response_init( 1, 0 , request.cmd ,  32 ,  {RCAINIT,cardstatus_short}    );  // R6
                          cardstatus.current_state = STBY;
                      end
            6       : if(last_is_acmd && cardstatus.current_state==TRAN) begin
                          cardstatus.app_cmd = 1'b1;
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                          widebus = request.arg[1];
                      end
            7       : begin
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                          cardstatus.current_state = (request.arg.rca==RCAINIT) ? TRAN : STBY;
                      end
            8       :     response_init( 1, 0 , request.cmd ,  32 ,  {24'd1,request.arg.checkmode} );
            9       : if(request.arg.rca==RCAINIT) begin 
                          response_init( 1, 0 ,   6'b000000 , 120 ,  CSD_REG                       );
                      end
            10      : if(request.arg.rca==RCAINIT) begin 
                          response_init( 1, 0 ,   6'b000000 , 120 ,  CID_REG                       );
                      end
            12      : if(cardstatus.current_state==TRAN || cardstatus.current_state==DATA) begin
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                          data_response_stop();
                      end
            13      : if(request.arg.rca==RCAINIT) begin 
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                      end
            15      : if(request.arg.rca==RCAINIT) begin 
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                          cardstatus.current_state = IDLE;
                      end
            16      : if(cardstatus.current_state==TRAN) begin
                          if(request.arg>512) cardstatus.block_len_error = 1'b1;
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                      end
            17      : if(cardstatus.current_state==TRAN) begin
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                          data_response_init(request.arg);
                      end
            18      : if(cardstatus.current_state==TRAN) begin
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                          data_response_init(request.arg, 1);
                      end
            41      : if(last_is_acmd) begin
                          cardstatus.app_cmd = 1'b1;
                          response_init( 1, 1 ,   6'b111111 ,  32 ,  OCR_REG                       );
                      end
            51      : if(last_is_acmd && cardstatus.current_state==TRAN) begin
                          cardstatus.app_cmd = 1'b1;
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                          data_response_scr_init();
                      end
            55      : begin
                          last_is_acmd <= 1'b1;
                          cardstatus.app_cmd = 1'b1;
                          response_init( 1, 0 , request.cmd ,  32 ,  cardstatus                    );
                      end
            default :     response_init( 0, 0 ,           0 ,   0 ,   0                            );
            endcase
        end
        response_yield();
        data_response_yield();
    end

endmodule
