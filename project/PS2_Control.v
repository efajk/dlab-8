module PS2_Control(
  input CLK,
  input PS2_CLK,
  input PS2_DATA,
  input reset,
  output reg [2:0]oLED,
  output reg [3:0] oNum1,
  output reg [3:0] oNum2,
  output reg [3:0] oNum3,
  output reg oNumRdy
);
