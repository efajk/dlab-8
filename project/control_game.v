module control_game(
  input clk,
  input reset,
  input [9:0] pix_x,
  input [9:0] pix_y,  
  input [3:0] iNum1,
  input [3:0] iNum2,
  input [3:0] iNum3,
  input iNumRdy,
  input rgb_on,
  output reg [2:0] out_rgb
);
