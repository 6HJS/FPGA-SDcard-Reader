
module top(
    // active-low, to reset the fake SD-card
    input  logic rst_n,
    // display SD card status on LED
    output logic [7:0]  led,
    // these are Fake SD-card signals, connect them to a SD-host, such as a SDcard Reader
    input  sdclk,
    inout  sdcmd,
    inout  [3:0] sddat
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
//    Fake SDcard Controller
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
    .rdclk     ( rdclk      ),
    .rdaddr    ( rdaddr     ),
    .rddata    ( rddata     ),
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

endmodule
