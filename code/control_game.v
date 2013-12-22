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
output             hint_on;//display hint
output             play_on;//display start
output reg [3-1:0] hint_rgb;
output reg [3-1:0] play_rgb;
output             rgb_on;//display num
output reg [3-1:0] out_rgb;

//--------------------------------------------------------------------------------
// Internal signal
reg flag;
reg  [3:0] Ans_Num1, Ans_Num2, Ans_Num3;
reg  [3:0] num1, num2, num3;
reg  [1:0] a,b;
wire [10:0]rom_addr;
reg  [6:0] char_addr, char_addr_s, char_addr_ab, char_addr_n;
reg  [3:0] row_addr;
wire [3:0] row_addr_s, row_addr_ab, row_addr_n;
reg  [2:0] bit_addr;
wire [2:0] bit_addr_s, bit_addr_ab, bit_addr_n;
wire [7:0] font_word;
wire       font_bit;

//--------------------------------------------------------------------------------
// Parameter declearation

//--------------------------------------------------------------------------------
// Function Design
font_rom font_unit(
  .clk(clk),
  .addr(rom_addr),
  .data(font_word)
);

always@(posedge clk) begin
  Ans_Num1 <= Ans_Num1;
  Ans_Num2 <= Ans_Num2;
  Ans_Num3 <= Ans_Num3;
  flag <= flag;
  if (reset) begin
    Ans_Num1 <= 0;
    Ans_Num2 <= 0;
    Ans_Num3 <= 0;
    flag <=0;
  end else if (iNumRdy) begin
    if(!flag)begin
      flag <= 1;
      Ans_Num1 <= iNum1;
      Ans_Num2 <= iNum2;
      Ans_Num3 <= iNum3;
    end
  end
end

always@(posedge clk) begin
  num1 <= num1;
  num2 <= iNum2;
  num3 <= iNum3;
  if (reset) begin
    num1 <= 0;
    num2 <= 0;
    num3 <= 0;
  end else if (iNumRdy) begin
    if (flag) begin
      num1 <= iNum1;
      num2 <= iNum2;
      num3 <= iNum3;
    end
  end
end

always @(*) begin
  if (flag && iNumRdy) begin
  a = (iNum1 == Ans_Num1) + (iNum2 == Ans_Num2) + (iNum3 == Ans_Num3);
  b = (iNum1 == Ans_Num3) + (iNum1 == Ans_Num2) + (iNum2 == Ans_Num3) + (iNum2 == Ans_Num1) + (iNum3 == Ans_Num1) + (iNum3 == Ans_Num2);
  end else begin
    a = 0;
    b = 0;
  end
end

assign play_on = (pix_y[9:6]==1) && (pix_x[9] == 0)&& flag;
assign row_addr_s = pix_y[5:2];
assign bit_addr_s = pix_x[4:2];
always @*
  case (pix_x[8:5])
    4'h0: char_addr_s = 7'h47; // G
    4'h1: char_addr_s = 7'h41; // A
    4'h2: char_addr_s = 7'h4d; // M
    4'h3: char_addr_s = 7'h45; // E
    4'h4: char_addr_s = 7'h00; //
    4'h5: char_addr_s = 7'h00; //
    4'h6: char_addr_s = 7'h53; // S
    4'h7: char_addr_s = 7'h54; // T
    4'h8: char_addr_s = 7'h41; // A
    4'h9: char_addr_s = 7'h52; // R
    4'ha: char_addr_s = 7'h54; // T
    4'hb: char_addr_s = 7'h00; //
    4'hc: char_addr_s = 7'h21; // !
    4'hd: char_addr_s = 7'h21; // !
    4'he: char_addr_s = 7'h00; //
    4'hf: char_addr_s = 7'h00; //
  endcase

assign hint_on = (pix_y[9:6]==3) && (pix_x[9:8]==1);
assign row_addr_ab = pix_y[5:2];
assign bit_addr_ab = pix_x[4:2];
always @*
  case (pix_x[7:5])
    4'h0: char_addr_ab = 7'h00; //
    4'h1: char_addr_ab = (flag) ? 7'h30 + a : 7'h00; // a
    4'h2: char_addr_ab = 7'h00; //
    4'h3: char_addr_ab = 7'h41; // A
    4'h4: char_addr_ab = 7'h00; //
    4'h5: char_addr_ab = (flag) ? 7'h30 + b : 7'h00; // b
    4'h6: char_addr_ab = 7'h00; //
    4'h7: char_addr_ab = 7'h42; // B
  endcase

assign rgb_on = (pix_y[9:6]==2) && (pix_x[9:8]==1);
assign row_addr_n = pix_y[5:2];//changed
assign bit_addr_n = pix_x[4:2];
always @*
  case (pix_x[7:5])
    4'h0: char_addr_n = (a == 2'd3)?7'h02:7'h00; //
    4'h1: char_addr_n = 7'h00; //
    4'h2: char_addr_n = 7'h00; // a
    4'h3: char_addr_n = (flag)?(7'h30  + num1): 7'h00; // A
    4'h4: char_addr_n = 7'h00; //
    4'h5: char_addr_n = (flag)?(7'h30  + num2): 7'h00; // b
    4'h6: char_addr_n = 7'h00; //
    4'h7: char_addr_n = (flag)?(7'h30  + num3): 7'h00; // B
  endcase

//-------------------------------------------
// mux for font ROM addresses and rgb
//-------------------------------------------
always @*
begin
  hint_rgb = 3'b111;  // background
  out_rgb  = 3'b111;  // background
  play_rgb = 3'b111;  // background
  if (hint_on)
     begin
        char_addr = char_addr_ab;
        row_addr = row_addr_ab;
        bit_addr = bit_addr_ab;
        if (font_bit)
           hint_rgb = 3'b000;
     end
  /*else
     begin
        char_addr = 0;
        row_addr = 0;
        bit_addr =0;
        if (font_bit)
           hint_rgb = 3'b000;
     end*/
  else if (play_on)
     begin
        char_addr = char_addr_s;
        row_addr = row_addr_s;
        bit_addr = bit_addr_s;
        if (font_bit)
           play_rgb = 3'b000;
     end
  /*else
     begin
        char_addr = 0;
        row_addr = 0;
        bit_addr =0;
        if (font_bit)
           play_rgb = 3'b000;
     end*/
   else if (rgb_on)
     begin
        char_addr = char_addr_n;
        row_addr = row_addr_n;
        bit_addr = bit_addr_n;
        if (font_bit)
           out_rgb = 3'b000;
     end
  else
     begin
        char_addr = 0;
        row_addr = 0;
        bit_addr =0;
        /*if (font_bit)
           out_rgb = 3'b000;*/
     end
end

//-------------------------------------------
// font rom interface
//-------------------------------------------
assign rom_addr = {char_addr, row_addr}; //
assign font_bit = font_word[~bit_addr];

endmodule
