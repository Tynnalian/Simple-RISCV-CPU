`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2023 13:05:37
// Design Name: 
// Module Name: instr_mem
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


module instr_mem #( parameter DEPTH = 1024, WIDTH = 32 )
(
  input [ 31 : 0 ] addr_i,
  
  output [ 31 : 0 ] read_data_o
  
);
    
  logic [ WIDTH - 1 : 0 ] RAM [ 0 : DEPTH - 1 ];

  initial $readmemh( "datapath.txt", RAM );
  
  assign read_data_o = RAM[ addr_i[11:2]];
    
endmodule
