`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2023 20:21:21
// Design Name: 
// Module Name: adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module adder(
 input a, 
 input b,
 input carry_in,
 output sum,
 output carry_out
);
assign sum = (a^b) ^ carry_in;
assign carry_out=(a&b)|((a^b)&(carry_in));
endmodule
