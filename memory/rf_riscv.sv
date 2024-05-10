`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2023 14:26:52
// Design Name: 
// Module Name: rf_riscv
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

module rf_riscv #( parameter DEPTH = 32, WIDTH = 32 )
(
  input          logic                    clk_i, 
                                     write_enable_i,
  
           logic  [4:0]         write_addr_i,                 
                                read_addr1_i,      
                                read_addr2_i,
  
      logic   [ WIDTH - 1 : 0 ]      write_data_i,
  
  output [ WIDTH - 1 : 0 ]      read_data1_o, 
                                read_data2_o

  );
  
  logic [ WIDTH - 1 : 0 ] rf_mem [ 0 : DEPTH - 1 ];
  
  assign read_data1_o = ( read_addr1_i ) ? ( rf_mem[ read_addr1_i ] ) : 0;
  assign read_data2_o = ( read_addr2_i ) ? ( rf_mem[ read_addr2_i ] ) : 0;
  
  always_ff @( posedge clk_i ) 
  
    rf_mem[ write_addr_i ] = ( write_enable_i ) ? ( write_data_i ) : ( rf_mem[ write_addr_i ] );
  
    
endmodule
