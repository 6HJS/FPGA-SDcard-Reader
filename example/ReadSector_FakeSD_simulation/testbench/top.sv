`timescale 1ns/1ns

module top();

logic clk=1'b1, rst_n=1'b0;
always  #2 clk=~clk;
initial #8 rst_n=1'b1;

logic [1:0] card_type;
logic [3:0] card_stat;

logic sdclk;
logic sdcmd;
logic [3:0] sddat;

logic       sdcmdoe_host , sdcmdoe_card ;
logic       sdcmdout_host, sdcmdout_card;
logic       sddatoe_host , sddatoe_card ;
logic [3:0] sddatout_host, sddatout_card;

assign sdcmd   = sdcmdoe_host ? sdcmdout_host : (sdcmdoe_card ? sdcmdout_card : 1'b1);
assign sddat   = sddatoe_host ? sddatout_host : (sddatoe_card ? sddatout_card : 4'hf);

logic rstart=1'b1, rdone;
logic [31:0] rsector_no = 0;

logic outreq;
logic [ 8:0] outaddr;
logic [ 7:0] outbyte;

SDReader  #(
    .SIMULATION ( 1 )
) SDReader_inst(  // a host to read fake SDcard
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

endmodule
