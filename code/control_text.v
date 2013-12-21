//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:   control_text
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
// control the text showing game name
// 
//
//////////////////////////////////////////////////////////////////////////////////
module control_text(
 input wire clk, 
 input wire [9:0] pix_x, pix_y,
 output wire  text_on,
 output reg [2:0] text_rgb
);

   // signal declaration
   wire [10:0] rom_addr;
   reg [6:0] char_addr, char_addr_s;
   reg [3:0] row_addr;
   wire [3:0] row_addr_s;
   reg [2:0] bit_addr;
   wire [2:0] bit_addr_s;
   wire [7:0] font_word;
   wire font_bit;

   // instantiate font ROM
   font_rom font_unit
      (.clk(clk), .addr(rom_addr), .data(font_word));
   assign text_on = (pix_y[9:6]==0)&&  (pix_y[5]==1) && (pix_x[8]==0)&&(pix_x[9]==0); // x :0~255, y:32~64
   assign row_addr_s = pix_y[4:1];
   assign bit_addr_s = pix_x[3:1];
   always @*
      case (pix_x[7:4])  
         4'h0: char_addr_s = 7'h42; // B
         4'h1: char_addr_s = 7'h75; // u
         4'h2: char_addr_s = 7'h6c; // l
         4'h3: char_addr_s = 7'h6c; // l
         4'h4: char_addr_s = 7'h73; // s
         4'h5: char_addr_s = 7'h00; // 
         4'h6: char_addr_s = 7'h61; // a
         4'h7: char_addr_s = 7'h6e; // n
         4'h8: char_addr_s = 7'h64; // d
         4'h9: char_addr_s = 7'h00; // 
         4'ha: char_addr_s = 7'h63; // c
         4'hb: char_addr_s = 7'h6f; // o
         4'hc: char_addr_s = 7'h77; // w
         4'hd: char_addr_s = 7'h73; // s
         4'he: char_addr_s = 7'h00; // 
         4'hf: char_addr_s = 7'h00; //
      endcase
 
   //-------------------------------------------
   // mux for font ROM addresses and rgb
   //-------------------------------------------
   always @*
   begin
      text_rgb = 3'b111;  // background
      if (text_on)
         begin
            char_addr = char_addr_s;
            row_addr = row_addr_s;
            bit_addr = bit_addr_s;
            if (font_bit)
               text_rgb = 3'b000;
         end
      else 
         begin
            char_addr = 0;
            row_addr = 0;
            bit_addr =0;
            if (font_bit)
               text_rgb = 3'b000;
         end
   end
   
   //-------------------------------------------
   // font rom interface
   //-------------------------------------------
   assign rom_addr = {char_addr, row_addr}; // 
   assign font_bit = font_word[~bit_addr];

endmodule
