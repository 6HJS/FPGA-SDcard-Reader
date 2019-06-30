module top(
    // clk = 50MHz, rst_n active low, You can read the SD card again with the reset button.
    input  logic clk, rst_n,
    // 8 bit LED to show the status and type of SDcard
    output logic [7:0] led,
    // UART tx signal, connect it to host's RXD
    output logic uart_tx
);

logic [1:0] card_type;
logic [3:0] card_stat;
assign led = {card_type, 2'b0, card_stat};

logic sdclk;
logic sdcmd;
logic [3:0] sddat;

logic       sdcmdoe_host , sdcmdoe_card ;
logic       sdcmdout_host, sdcmdout_card;
logic       sddatoe_host , sddatoe_card ;
logic [3:0] sddatout_host, sddatout_card;

assign sdcmd   = sdcmdoe_host ? sdcmdout_host : (sdcmdoe_card ? sdcmdout_card : 1'b1);
assign sddat   = sddatoe_host ? sddatout_host : (sddatoe_card ? sddatout_card : 1'b1);

logic rstart=1'b1, rdone;
logic [31:0] rsector_no = 0;

logic outreq;
logic [ 8:0] outaddr;
logic [ 7:0] outbyte;

SDReader SDReader_inst(  // a host to read fake SDcard
    .clk,
    .rst_n,
    
    .sdclk,
    .sdcmdoe       ( sdcmdoe_host    ),
    .sdcmdout      ( sdcmdout_host   ),
    .sdcmdin       ( sdcmd           ),
    .sddatoe       ( sddatoe_host    ),
    .sddatout      ( sddatout_host   ),
    .sddatin       ( sddat           ),
    
    .card_type,
    .card_stat,
    .rstart,
    .rsector_no,
    .rdone,
    
    .outreq,
    .outaddr,
    .outbyte
);

always @ (posedge clk or negedge rst_n)
    if(~rst_n)
        rstart = 1'b1;
    else begin
        if(rdone)
            rstart = 1'b0;
    end


logic rdclk;
logic [63:0] rdaddr;
logic [ 7:0] rddata;

SDFake sd_fake_inst(   // a synthesisable fake SDcard
    .rst_n,
    
    .sdclk,
    .sdcmdoe   ( sdcmdoe_card    ),
    .sdcmdout  ( sdcmdout_card   ),
    .sdcmdin   ( sdcmd           ),
    
    .sddatoe   ( sddatoe_card    ),
    .sddatout  ( sddatout_card   ),
    .sddatin   ( sddat           ),
    
    .rdclk  ,
    .rdaddr ,
    .rddata ,
    
    .debugled  (                 )
);

always @ (posedge rdclk)  rddata = rdaddr[7:0];  // make a fake sdcard content

uart_tx #(
    .UART_CLK_DIV    ( 434          ),  // UART baud rate = clk freq/(2*UART_TX_CLK_DIV)
                                        // modify UART_TX_CLK_DIV to change the UART baud
                                        // for example, when clk=50MHz, UART_TX_CLK_DIV=434, then baud=50MHz/(2*434)=115200
                                        // 115200 is a typical SPI baud rate for UART
                                        
    .FIFO_ASIZE      ( 12           ),  // UART TX buffer size=2^FIFO_ASIZE bytes, Set it smaller if your FPGA doesn't have enough BRAM
    
    .BYTE_WIDTH      ( 1            ),
    
    .MODE            ( 2            )
) uart_tx_inst (
    .clk             ( clk          ),  // clk = 50MHz.
    .rst_n           ( rst_n        ),  // rst_n active low, You can read the SD card again with the reset button.
    
    .wreq            ( outreq       ),
    .wgnt            (              ),
    .wdata           ( outbyte      ),
    
    .o_uart_tx       ( uart_tx      )
);

endmodule
