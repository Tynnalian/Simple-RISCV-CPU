`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2023 16:20:23
// Design Name: 
// Module Name: data_memory
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

module data_mem (
  input  logic        clk_i,
  input  logic        mem_req_i,
  input  logic        write_enable_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o
);  
    logic [ 31: 0 ] RAM [ 0 : 4095 ];
    
   
     
    always_ff @( posedge clk_i ) 
      begin
    
        if  (mem_req_i )
          
                   read_data_o = (mem_req_i) ?( RAM[ addr_i[ 13 : 2 ] ] ) : read_data_o  ; 
             RAM [ addr_i[13:2]  ] <= ( write_enable_i ) ? ( write_data_i ) : ( RAM[ addr_i[ 13 : 2 ] ]);
            
      end
    
endmodule