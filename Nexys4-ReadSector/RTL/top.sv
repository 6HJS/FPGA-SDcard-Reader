// this example runs on Digilent Nexys4-DDR board (Xilinx Artix-7)
// see http://www.digilent.com.cn/products/product-nexys-4-ddr-artix-7-fpga-trainer-board.html
//

module top(
    // clock = 100MHz
    input  logic         CLK100MHZ,
    // rst_n active-low, You can re-scan and re-read SDcard by pushing the reset button.
    input  logic         RESETN,
    // when SD_RESET = 0, SDcard power on
    output logic         SD_RESET,
    // signals connect to SD bus
    output logic         SD_SCK,
    inout                SD_CMD,
    input  logic [ 3:0]  SD_DAT,
    // 8 bit LED to show the status of SDcard
    output logic [15:0]  LED,
    // UART tx signal, connect it to host-PC's UART-RXD, baud=115200
    output logic         UART_TX,
    input logic  [8:0]   SW,
    input logic          BTNU
);

logic           rstart=1'b1;
logic           rdone;
logic           outreq;
logic [ 7:0]    outbyte;

//assign SD_RESET = 1'b0;
assign SD_RESET = SW[8];
assign LED[15] = ~SW[8];

assign {LED[14:10], LED[7:4]} = 9'h0;

always @ (posedge CLK100MHZ or negedge BTNU)
    if(~BTNU)
        rstart = 1'b1;
    else begin
        if(rdone)
            rstart = 1'b0;
    end


// For more detail, see SDReader.sv
SDReader #(
    .CLK_DIV         ( 2            )   // because clk=100MHz, CLK_DIV is set to 2
                                        // see SDReader.sv for detail
) SDReader_inst(
    .clk             ( CLK100MHZ    ),
    .rst_n           ( BTNU       ),  // rst_n active low, re-scan and re-read SDcard by reset
    
    // signals connect to SD bus
    .sdclk           ( SD_SCK       ),
    .sdcmd           ( SD_CMD       ),
    .sddat           ( SD_DAT       ),
    
    // show card status on LED
    .card_type       ( LED[9:8]     ),  // 0=Unknown, 1=SDv1.1 , 2=SDv2 , 3=SDHCv2
    .card_stat       ( LED[3:0]     ),
    
    // user read sector command interface
    .rstart          ( rstart       ),
    .rsector_no      ( 8192   ),  // read No. 0 sector (the first sector) in SDcard
    .rbusy           (              ),
    .rdone           ( rdone        ),
    
    // sector data output interface
    .outreq          ( outreq       ),
    .outaddr         (              ),
    .outbyte         ( outbyte      )
);


uart_tx #(
    .UART_CLK_DIV    ( 868          ),  // UART baud rate = clk freq/(2*UART_TX_CLK_DIV)
                                        // modify UART_TX_CLK_DIV to change the UART baud
                                        // for example, when clk=100MHz, UART_TX_CLK_DIV=868, then baud=100MHz/(2*868)=115200
                                        // 115200 is a typical SPI baud rate for UART
                                        
    .FIFO_ASIZE      ( 12           ),  // UART TX buffer size=2^FIFO_ASIZE bytes, Set it smaller if your FPGA doesn't have enough BRAM
    .BYTE_WIDTH      ( 1            ),
    .MODE            ( 2            )
) uart_tx_inst (
    .clk             ( CLK100MHZ    ),
    .rst_n           ( RESETN       ),
    
    .wreq            ( outreq       ),
    .wgnt            (              ),
    .wdata           ( outbyte      ),
    
    .o_uart_tx       ( UART_TX      )
);

endmodule
