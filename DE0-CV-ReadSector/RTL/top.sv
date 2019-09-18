// this example runs on Terasic DE0-CV board (Altera Cyclone V)
// see https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=163&No=921
//

module top(
    // clock = 50MHz
    input  logic         CLOCK_50,
    // rst_n active-low, You can re-scan and re-read SDcard by pushing the reset button.
    input  logic         RESET_N,
    // signals connect to SD bus
    output logic         SD_CLK,
    inout                SD_CMD,
    input  logic [ 3:0]  SD_DATA,
    // 6 7-segment to show the status of SDcard
    output logic [ 6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);


logic        rstart=1'b1, rdone;

wire         outreq;
wire  [ 8:0] outaddr;
wire  [ 7:0] outbyte;

wire  [ 1:0] sdcardtype;
wire  [ 3:0] sdcardstate;

logic [15:0] lastdata = 16'h0;


always @ (posedge CLOCK_50 or negedge RESET_N)
    if(~RESET_N)
        rstart = 1'b1;
    else begin
        if(rdone)
            rstart = 1'b0;
    end


// For more detail, see SDReader.sv
SDReader #(
    .CLK_DIV         ( 1            )   // because clk=50MHz, CLK_DIV is set to 1
                                        // see SDReader.sv for detail
) SDReader_inst(
    .clk             ( CLOCK_50     ),
    .rst_n           ( RESET_N      ),  // rst_n active low, re-scan and re-read SDcard by reset
    
    // signals connect to SD bus
    .sdclk           ( SD_CLK       ),
    .sdcmd           ( SD_CMD       ),
    .sddat           ( SD_DATA      ),
    
    // show card status on LED
    .card_type       ( sdcardtype   ),  // 0=Unknown, 1=SDv1.1 , 2=SDv2 , 3=SDHCv2
    .card_stat       ( sdcardstate  ),
    
    // user read sector command interface
    .rstart          ( rstart       ),
    .rsector_no      ( 0            ),  // read No. 0 sector (the first sector) in SDcard
    .rbusy           (              ),
    .rdone           ( rdone        ),
    
    // sector data output interface
    .outreq          ( outreq       ),
    .outaddr         ( outaddr      ),
    .outbyte         ( outbyte      )
);





// display SDcard status and types on 2 7-segment
SEG7_LUT  seg7_lut_i0( RESET_N,         sdcardstate   , HEX0 );
SEG7_LUT  seg7_lut_i1( RESET_N,  {2'b00, sdcardtype}  , HEX1 );  // 0=Unknown, 1=SDv1.1 , 2=SDv2 , 3=SDHCv2





// capture last 2 bytes in sector
always @ (posedge CLOCK_50 or negedge RESET_N)
    if(~RESET_N) begin
        lastdata <= 16'h0;
    end else begin
        if(outreq) begin
            if     (outaddr==9'd510)   // countdown second byte
                lastdata[15:8] <= outbyte;
            else if(outaddr==9'd511)   // countdown first byte
                lastdata[ 7:0] <= outbyte;
        end
    end




// display last 2 bytes on 4 7-segment
SEG7_LUT  seg7_lut_i2( RESET_N, lastdata[ 3: 0]  , HEX2 );
SEG7_LUT  seg7_lut_i3( RESET_N, lastdata[ 7: 4]  , HEX3 );
SEG7_LUT  seg7_lut_i4( RESET_N, lastdata[11: 8]  , HEX4 );
SEG7_LUT  seg7_lut_i5( RESET_N, lastdata[15:12]  , HEX5 );

endmodule
