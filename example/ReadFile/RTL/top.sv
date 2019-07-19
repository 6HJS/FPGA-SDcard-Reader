module top(
    // clk = 50MHz, rst_n active low, You can read the SD card again with the reset button.
    input  logic clk, rst_n,
    // signals connect to SD bus
    output logic sdclk,
    inout  sdcmd,
    inout  [3:0] sddat,
    // 8 bit LED to show the status and type of SDcard
    output logic [7:0] led,
    // UART tx signal, connect it to host's RXD
    output logic uart_tx
);

wire outreq;        // when outreq=1, a byte of file content is read out from outbyte
wire [7:0] outbyte; // a byte of file content

// type and status
//logic [3:0] sdcardstate;
logic [1:0] sdcardtype;     // 0=Unknown, 1=SDv1.1 , 2=SDv2 , 3=SDHCv3
logic [1:0] filesystemtype; // 0=Unknown, 1=FAT16, 2=FAT32
logic [2:0] fatstate;       // 3'd6 = DONE
logic file_found;           // 0=file not found, 1=file found

logic sdcmdoe, sdcmdout;
logic sdcmdin;
logic sddatoe;
logic [3:0] sddatout;
logic [3:0] sddatin;

assign sdcmd   = sdcmdoe ? sdcmdout : 1'bz;
assign sdcmdin = sdcmdoe ? 1'b1 : sdcmd;
assign sddat   = sddatoe ? sddatout : 4'hz;
assign sddatin = sddatoe ? 4'hf : sddat;

// display status on 8bit LED
assign led = {sdcardtype,filesystemtype,file_found,fatstate};

// For input and output definitions of this module, see sd_file_reader.sv
SDFileReader #(
    .FILE_NAME      ( "target.txt"   )  // file to read, ignore Upper and Lower Case
                                        // For example, if you want to read a file named HeLLo123.txt in the SD card,
                                        // the parameter here can be hello123.TXT, HELLO123.txt or HEllo123.Txt
) sd_file_reader_inst(
    .clk            ( clk            ), // clk = 50MHz.
    .rst_n          ( rst_n          ), //  rst_n active low, you can read the SD card repeatly with the reset button.
    
    .sdclk          ( sdclk          ),
    .sdcmdoe        ( sdcmdoe        ),
    .sdcmdout       ( sdcmdout       ),
    .sdcmdin        ( sdcmdin        ),
    .sddatoe        ( sddatoe        ),
    .sddatout       ( sddatout       ),
    .sddatin        ( sddatin        ),
    
    .sdcardtype     ( sdcardtype     ),
    .filesystemtype ( filesystemtype ),
    //.sdcardstate    ( sdcardstate    ),
    .fatstate       ( fatstate       ),
    .file_found     ( file_found     ),
    
    .outreq         ( outreq         ),
    .outbyte        ( outbyte        )
);


// send file content to UART
uart_tx #(
    .UART_CLK_DIV    ( 434          ),  // UART baud rate = clk freq/(2*UART_TX_CLK_DIV)
                                        // modify UART_TX_CLK_DIV to change the UART baud
                                        // for example, when clk=50MHz, UART_TX_CLK_DIV=434, then baud=50MHz/(2*434)=115200
                                        // 115200 is a typical SPI baud rate for UART
                                        
    .FIFO_ASIZE      ( 14           ),  // UART TX buffer size=2^FIFO_ASIZE bytes, Set it smaller if your FPGA doesn't have enough BRAM
    
    .BYTE_WIDTH      ( 1            ),
    
    .MODE            ( 1            )
) uart_tx_inst (
    .clk             ( clk          ),
    .rst_n           ( rst_n        ),
    
    .wreq            ( outreq       ),
    .wgnt            (              ),
    .wdata           ( outbyte      ),
    
    .o_uart_tx       ( uart_tx      )
);

endmodule
