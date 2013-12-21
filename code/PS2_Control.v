//Subject:
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Szuyi Huang
//----------------------------------------------
//Date:        2013-12-21 17:31
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module PS2_Control(
  CLK,
  PS2_CLK,
  PS2_DATA,
  reset,
  oLED,
  oNum1,
  oNum2,
  oNum3,
  oNumRdy
);

//--------------------------------------------------------------------------------
// I/O ports declearation
input CLK;
input PS2_CLK
input PS2_DATA
input reset;

output reg [2:0] oLED;
output reg [3:0] oNum1;
output reg [3:0] oNum2;
output reg [3:0] oNum3;
output reg       oNumRdy;

//--------------------------------------------------------------------------------
// Internal signal
reg        KCLK_P;
reg        KCLK_C;
reg [21:0] ARRAY;
wire       enable;

//--------------------------------------------------------------------------------
// Parameter declearation

//--------------------------------------------------------------------------------
// Function Design
assign enable = KCLK_P - KCLK_C;

always @ (posedge CLK) begin
	if(reset) begin
		KCLK_P <= 0;
		KCLK_C <= 0;
    ARRAY  <= 22'b11_0000_0000_0_11_0000_0000_0;
  end else begin
		KCLK_P <= KCLK_C;
		KCLK_C <= PS2_CLK;
    ARRAY  <= ARRAY;
    if(KCLK_P > KCLK_C) begin
			//		read data
      ARRAY <= {PS2_DATA, ARRAY[21:1]};
    end
  end
end

always @(*) begin
  //default
  if (ARRAY[8:1] == 8'hF0 && {ARRAY[21], ARRAY[11:10], ARRAY[0]} == 4'b1010 && enable) begin
  end
end

endmodule
