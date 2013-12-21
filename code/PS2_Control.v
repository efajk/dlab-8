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
reg         KCLK_P;
reg         KCLK_C;
reg  [21:0] ARRAY;
wire        enable;
reg         in_flag;
reg         in_flag_w;
reg   [3:0] oNum1_w;
reg   [3:0] oNum2_w;
reg   [3:0] oNum3_w;
reg         oNumRdy_w;
reg [3-1:0] state;
reg [3-1:0] next;

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

always @(posedge CLK) begin
  if (reset) begin
    oNum1 <= 0;
    oNum2 <= 0;
    oNum3 <= 0;
    oNumRdy <= 0;
    in_flag <= 0;
    state <= 3'd0;
  end else begin
    oNum1 <= oNum1_w;
    oNum2 <= oNum2_w;
    oNum3 <= oNum3_w;
    oNumRdy <= oNumRdy_w;
    in_flag <= in_flag_w;
    state <= next;
  end
end

always @(*) begin
  //default
  oNum1_w = oNum1;
  oNum2_w = oNum2;
  oNum3_w = oNum3;
  oNumRdy_w = oNumRdy;
  in_flag_w = in_flag;
  //if (state == 3'd4)
    //next = 3'd0;
  //else
  next = state;
  if (ARRAY[8:1] == 8'hF0 && {ARRAY[21], ARRAY[11:10], ARRAY[0]} == 4'b1010 && enable) begin
    case (ARRAY[19:12])
      8'h16: begin
        case(state)
          3'd0: oNum1_w = 4'd1;
          3'd1: oNum2_w = 4'd1;
          3'd2: oNum3_w = 4'd1;
        endcase
        in_flag_w = 1;
      end
      8'h1E: begin
        case(state)
          3'd0: oNum1_w = 4'd2;
          3'd1: oNum2_w = 4'd2;
          3'd2: oNum3_w = 4'd2;
        endcase
        in_flag_w = 1;
      end
      8'h26: begin
        case(state)
          3'd0: oNum1_w = 4'd3;
          3'd1: oNum2_w = 4'd3;
          3'd2: oNum3_w = 4'd3;
        endcase
        in_flag_w = 1;
      end
      8'h25: begin
        case(state)
          3'd0: oNum1_w = 4'd4;
          3'd1: oNum2_w = 4'd4;
          3'd2: oNum3_w = 4'd4;
        endcase
        in_flag_w = 1;
      end
      8'h2E: begin
        case(state)
          3'd0: oNum1_w = 4'd5;
          3'd1: oNum2_w = 4'd5;
          3'd2: oNum3_w = 4'd5;
        endcase
        in_flag_w = 1;
      end
      8'h36: begin
        case(state)
          3'd0: oNum1_w = 4'd6;
          3'd1: oNum2_w = 4'd6;
          3'd2: oNum3_w = 4'd6;
        endcase
        in_flag_w = 1;
      end
      8'h3D: begin
        case(state)
          3'd0: oNum1_w = 4'd7;
          3'd1: oNum2_w = 4'd7;
          3'd2: oNum3_w = 4'd7;
        endcase
        in_flag_w = 1;
      end
      8'h3E: begin
        case(state)
          3'd0: oNum1_w = 4'd8;
          3'd1: oNum2_w = 4'd8;
          3'd2: oNum3_w = 4'd8;
        endcase
        in_flag_w = 1;
      end
      8'h46: begin
        case(state)
          3'd0: oNum1_w = 4'd9;
          3'd1: oNum2_w = 4'd9;
          3'd2: oNum3_w = 4'd9;
        endcase
        in_flag_w = 1;
      end
      8'h45: begin
        case(state)
          3'd0: oNum1_w = 4'd0;
          3'd1: oNum2_w = 4'd0;
          3'd2: oNum3_w = 4'd0;
        endcase
        in_flag_w = 1;
      end
      8'h5A: begin
        case(state)
          3'd0: begin
            if (in_flag) next = 3'd1;
          end
          3'd1: begin
            if (in_flag) next = 3'd2;
          end
          3'd2: begin
            if (in_flag) next = 3'd3;
          end
          3'd3: begin
            next = 3'd4;
            oNumRdy_w = 1;
          end
          3'd4: begin
            oNumRdy_w = 0;
            next = 3'd0;
          end
        endcase
        in_flag_w = 0;
      end
    endcase
  end
end

endmodule
