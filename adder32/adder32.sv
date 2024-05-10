`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2023 20:23:55
// Design Name: 
// Module Name: adder32
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


module adder32(
	input [31:0]a,
   input [31:0] b,
        
   output [31:0] sum  
	
);
adder8 adder80 (.a(a[7:0]), .b(b[7:0]), .carry_in(1'b0), .sum(sum[7:0]), .carry_out(n0));
adder8 adder81 (.a(a[15:8]), .b(b[15:8]), .carry_in(n0), .sum(sum[15:8]), .carry_out(n1));
adder8 adder82 (.a(a[23:16]), .b(b[23:16]), .carry_in(n1), .sum(sum[23:16]), .carry_out(n2));
adder8 adder83 (.a(a[31:24]), .b(b[31:24]), .carry_in(n2), .sum(sum[31:24]));

endmodule
