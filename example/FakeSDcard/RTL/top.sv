module top(
    input  logic clk, rst_n,
    input  logic fakesdclk,
    inout  fakesdcmd,
    inout  [3:0] fakesddat,
    // 8 bit LED to show the status and type of SDcard
    output logic [7:0] led,
    // UART tx signal, connect it to host's RXD
    output logic uart_tx
);

logic  sdcmdoe ;
logic  sdcmdout;
logic  sddatoe ;
logic  [3:0] sddatout ;
assign fakesdcmd = sdcmdoe ? sdcmdout : 1'bz;
assign fakesddat = sddatoe ? sddatout : 4'bz;

logic rdclk;
logic [63:0] rdaddr;
logic [ 7:0] rddata;

SDFake sd_fake_inst(
    .rst_n,
    
    .sdclk     ( fakesdclk  ),
    .sdcmdoe   ( sdcmdoe    ),
    .sdcmdin   ( fakesdcmd  ),
    .sdcmdout  ( sdcmdout   ),
    .sddatoe   ( sddatoe    ),
    .sddatin   ( fakesddat  ),
    .sddatout  ( sddatout   ),
    
    .rdclk  ,
    .rdaddr ,
    .rddata ,
    
    .debugled  ( led        )
);

always @ (posedge rdclk)
    rddata <= {rdaddr[11:8],rdaddr[3:0]};

endmodule
