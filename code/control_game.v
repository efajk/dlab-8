//Subject:
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Szuyi Huang
//----------------------------------------------
//Date:        2013-12-21 17:34
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module control_game(
  clk,
  reset,
  pix_x,
  pix_y,
  iNum1,
  iNum2,
  iNum3,
  iNumRdy,
  hint_on,
  play_on,
  rgb_on,
  hint_rgb,
  play_rgb,
  out_rgb
					);

//--------------------------------------------------------------------------------
// I/O ports declearation
input       clk;
input       reset;
input [9:0] pix_x;
input [9:0] pix_y;
input [3:0] iNum1;
input [3:0] iNum2;
input [3:0] iNum3;
input       iNumRdy;
output             hint_on;
output             play_on;
output reg [3-1:0] hint_rgb;
output reg [3-1:0] play_rgb;
output             rgb_on;
output reg [3-1:0] out_rgb;

//--------------------------------------------------------------------------------
// Internal signal

//--------------------------------------------------------------------------------
// Parameter declearation

//--------------------------------------------------------------------------------
// Function Design

endmodule
