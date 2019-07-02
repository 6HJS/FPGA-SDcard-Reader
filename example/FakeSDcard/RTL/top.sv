
module top(
    input  CLK50M, CLK27M, BUTTON,
    
    output [ 8: 0]  LED,
    
    input  logic fakesdclk,
    inout  fakesdcmd,
    inout  [3:0] fakesddat
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

assign LED[8] = BUTTON;

SDFake sd_fake_inst(
    .rst_n     ( BUTTON     ),
    
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
    
    .debugled  ( LED[7:0]   )
);

always @ (posedge rdclk)
    rddata <= {rdaddr[11:8],rdaddr[3:0]};


endmodule
