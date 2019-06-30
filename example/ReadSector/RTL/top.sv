module top(
    // clk = 50MHz, rst_n active low, You can read the SD card again with the reset button.
    input  logic clk, rst_n,
    // signals connect to SD spi
    output logic sdclk,
    inout  sdcmd,
    inout  [3:0] sddat,
    // 8 bit LED to show the status and type of SDcard
    output logic [7:0] led,
    // UART tx signal, connect it to host's RXD
    output logic uart_tx
);

logic [1:0] card_type;
logic [3:0] card_stat;

assign led = {card_type, 2'b0, card_stat};

logic sdcmdoe, sdcmdout;
logic sdcmdin;
logic sddatoe;
logic [3:0] sddatout;
logic [3:0] sddatin;

assign sdcmd   = sdcmdoe ? sdcmdout : 1'bz;
assign sdcmdin = sdcmdoe ? 1'b1 : sdcmd;
assign sddat   = sddatoe ? sddatout : 4'hz;
assign sddatin = sddatoe ? 4'hf : sddat;

logic rstart=1'b1, rbusy, rdone;
logic [31:0] rsector_no = 0;

logic outreq;
logic [ 8:0] outaddr;
logic [ 7:0] outbyte;

SDReader SDReader_inst( .* );

always @ (posedge clk or negedge rst_n)
    if(~rst_n)
        rstart = 1'b1;
    else begin
        if(rdone)
            rstart = 1'b0;
    end

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
