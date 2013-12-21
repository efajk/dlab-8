//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name:   BullandCow
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module BullandCow(
  input wire iCLK_50, reset,
	input PS2_CLK,
	input PS2_DATA,
	output wire oHS, oVS,
  output wire  oVGA_R,
  output wire  oVGA_G,
  output wire  oVGA_B,
	output wire [7:0] oLED
);

wire video_on;
wire pixel_tick;
wire [10-1:0] pixel_x;
wire [10-1:0] pixel_y;
wire  [2-1:0] text_rgb;
wire text_on;

vga_sync vsync_unit(
  .clk(iCLK_50),
  .reset(reset),
  .oHS(oHS),
  .oVS(oVS),
  .visible(video_on),
  .p_tick(pixel_tick),
  .pixel_x(pixel_x),
  .pixel_y(pixel_y)
);

control_text game_title(
  .clk(iCLK_50),
  .pix_x(pixel_x),
  .pix_y(pixel_y),
  .text_on(text_on),
  .text_rgb(text_rgb)
);

wire [4-1:0] oNum1;
wire [4-1:0] oNum2;
wire [4-1:0] oNum3;
wire oNumRdy;
PS2_Control keyboard_ctrl(
  .CLK(iCLK_50),
  .PS2_CLK(PS2_CLK),
  .PS2_DATA(PS2_DATA),
  .reset(reset),
  .oLED(oLED),
  .oNum1(oNum1),
  .oNum2(oNum2),
  .oNum3(oNum3),
  .oNumRdy(oNumRdy)
);

wire num_on;
wire hint_on;
wire play_on;
wire [3-1:0] num_rgb;
wire [3-1:0] hint_rgb;
wire [3-1:0] play_rgb;
control_game(
  .clk(iCLK_50),
  .reset(reset),
  .pix_x(pixel_x),
  .pix_y(pixel_y),
  .iNum1(oNum1),
  .iNum2(oNum2),
  .iNum3(oNum3),
  .iNumRdy(oNumRdy),
  .rgb_on(num_on),
  .out_rgb(num_rgb)
);

reg [2:0] rgb_reg;
reg [2:0] rgb_next;

always @(posedge iCLK_50) begin
  if(pixel_tick)
    rgb_reg <= rgb_next;
  else
    rgb_reg <= rgb_reg;
end

always @(*) begin
  if (~video_on)
    rgb_next = 3'b000;
  else if (text_on)
    rgb_next = text_rgb;
  else if (num_on)
    rgb_next = num_rgb;
  else if (hint_on)
    rgb_next = hint_rgb;
  else if (play_on)
    rgb_next = play_rgb;
  else
    rgb_next = 3'b111;
end

assign {oVGA_R, oVGA_G, oVGA_B} = rgb_reg;
endmodule
