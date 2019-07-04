module SDBusMonitor(
    input  logic clk, rst_n,
    input  logic sdclk, sdcmd,
    
    output logic outframeen,
    output logic [47:0] outframe
);

function automatic void CalcCrc7(ref [6:0] crc, input inbit);
    crc = {crc[5:0],crc[6]^inbit} ^ {3'b0,crc[6]^inbit,3'b0};
endfunction

wire fifo_wfull, fifo_rempty;

logic frameen;
logic [47:0] frame;

always @ (posedge clk or negedge rst_n)
    if(~rst_n)
        outframeen = 1'b0;
    else
        outframeen = ~fifo_rempty;

struct packed{
    logic [ 1:0] pre;
    struct packed{
        logic sbit;
        logic tbit;
        logic [ 5:0] cmd;
        logic [31:0] arg;
        logic [ 6:0] crc;
        logic stop;
    } content;
} sdcmdframe='0;

logic [6:0] crcval = '0;
always @ (posedge sdclk or negedge rst_n)
    if(~rst_n) begin
        frameen    = 1'b0;
        frame      = '0;
        sdcmdframe = '1;
    end else begin
        frameen    = 1'b0;
        if(sdcmdframe.pre==2'b11 && ~sdcmdframe.content.sbit && sdcmdframe.content.stop) begin
            crcval = '0;
            for(int i=47; i>0; i--) CalcCrc7(crcval,sdcmdframe.content[i]);
            if(crcval==7'h0) begin
                frameen    = 1'b1;
                frame      = sdcmdframe.content;
            end
            sdcmdframe = '1;
        end else
            sdcmdframe = {sdcmdframe, sdcmd};
    end
    
async_fifo #(   // TX async fifo, the goal is to change the clock domain
    .DSIZE        ( 6*8                     ),
    .ASIZE        ( 7                       )
) fifo_tx_inst (
    .wrst_n       ( rst_n                   ),
    .wclk         ( sdclk                   ),
    .winc         ( frameen & ~fifo_wfull   ),
    .wdata        ( frame                   ),
    .wfull        ( fifo_wfull              ),

    .rrst_n       ( rst_n                   ),
    .rclk         ( clk                     ),
    .rinc         ( ~fifo_rempty            ),
    .rdata        ( outframe                ),
    .rempty       ( fifo_rempty             )
);

endmodule
