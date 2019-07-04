
module top(
    // clk=50MHz, rst_n active-low, to reset the fake SD-card
    input  logic clk, rst_n,
    // display SD card status on LED
    output logic [7:0]  led,
    // these are Fake SD-card signals, connect them to a SD-host, such as a SDcard Reader
    input  sdclk,
    inout  sdcmd,
    inout  [3:0] sddat,
    // Debug UART, baud=115200, show SD bus requests and response
    output logic uart_tx
);

logic  sdcmdoe ;
logic  sdcmdout;
logic  sddatoe ;
logic  [3:0] sddatout ;
assign sdcmd = sdcmdoe ? sdcmdout : 1'bz;
assign sddat = sddatoe ? sddatout : 4'bz;

logic rdclk;
logic [63:0] rdaddr;
logic [ 7:0] rddata;


// ---------------------------------------------------------------------------------------------
//    Fake SDcard
// ---------------------------------------------------------------------------------------------
SDFake sd_fake_inst(
    .rst_n,
    .sdclk     ( sdclk      ),
    .sdcmdoe   ( sdcmdoe    ),
    .sdcmdin   ( sdcmd      ),
    .sdcmdout  ( sdcmdout   ),
    .sddatoe   ( sddatoe    ),
    .sddatin   ( sddat      ),
    .sddatout  ( sddatout   ),
    .rdclk  ,
    .rdaddr ,
    .rddata ,
    .debugled  ( led        )  // show Fake SDcard status on LED
);


// ---------------------------------------------------------------------------------------------
//    A ROM which store the Fake SDcard content
//    make the SD card be recognized as a formatted FAT32 disk
// ---------------------------------------------------------------------------------------------
SDcardContent SDcardContent_inst(
    .rdclk,
    .rdaddr,
    .rddata
);


// ---------------------------------------------------------------------------------------------
//    A SD bus Monitor
//    Send SD request and response frame (such as CMD8, ACMD41...) to UART
//    UART baud = 115200
//    this is only for debug
// ---------------------------------------------------------------------------------------------
logic outframeen;
logic [47:0] outframe;
SDBusMonitor sd_bus_monitor_inst(
    .clk,
    .rst_n,
    .sdclk,
    .sdcmd,
    .outframeen,
    .outframe
);
uart_tx #(
    .UART_CLK_DIV    ( 434          ),
    .FIFO_ASIZE      ( 10           ),
    .BYTE_WIDTH      ( 6            ),
    .MODE            ( 3            ),
    .BIG_ENDIAN      ( 0            )
) uart_tx_inst (
    .clk             ( clk          ),
    .rst_n           ( rst_n        ),
    
    .wreq            ( outframeen && |outframe   ),
    .wgnt            (              ),
    .wdata           ( outframe     ),
    
    .o_uart_tx       ( uart_tx      )
);


endmodule
