`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2024 22:42:55
// Design Name: 
// Module Name: ext_mem
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


module ext_mem (
  input  logic        clk_i,
  input  logic        mem_req_i,
  input  logic        write_enable_i,
  input  logic [ 3:0] byte_enable_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o,
  output logic        ready_o
);  
    logic [ 31: 0 ] RAM [ 0 : 4095 ];
    
   
     
    always_ff @( posedge clk_i ) 
      begin
      ready_o<=1'b1; 
        if  (mem_req_i )
          
              read_data_o = (mem_req_i) ?( RAM[ addr_i[ 13 : 2 ] ] ) : read_data_o  ;
                   
                      
                 
                   
                   
                   case ( byte_enable_i  ) 
                        4'b0001 : RAM [ addr_i[13:2]  ] [ 7 : 0 ]  <= ( write_enable_i ) ? ( write_data_i [ 7 : 0 ] ) : ( RAM[ addr_i[ 13 : 2 ] ] [ 7 : 0 ]);
                        
                        4'b0010 : RAM [ addr_i[13:2]  ] [ 15 : 8 ] <= ( write_enable_i ) ? ( write_data_i [13:2] ) : ( RAM[ addr_i[ 13 : 2 ] ][13:2]);
                        
                        4'b0011 : RAM [ addr_i[13:2]  ] [ 15 : 0 ] <= ( write_enable_i ) ? ( write_data_i [ 15 : 0 ] ) : ( RAM[ addr_i[ 13 : 2 ] ][ 15 : 0 ]);
                        
                        4'b0100 : RAM [ addr_i[13:2]  ] [ 23 : 16 ] <= ( write_enable_i ) ? ( write_data_i [ 23 : 16 ]) : ( RAM[ addr_i[ 13 : 2 ] ][ 23 : 16 ]);
                        
                        4'b0101 : begin RAM [ addr_i[13:2]  ] [7:0] <= ( write_enable_i ) ? ( write_data_i [7:0] ) : ( RAM[ addr_i[ 13 : 2 ] ][7:0]);
                         
                                  RAM [ addr_i[13:2]  ] [23:16] <= ( write_enable_i ) ? ( write_data_i [23:16] ) : ( RAM[ addr_i[ 13 : 2 ] ][23:16]); end
                                   
                        4'b0110 :  RAM [ addr_i[13:2]  ] [ 23 : 8 ] <= ( write_enable_i ) ? ( write_data_i [23:8]) : ( RAM[ addr_i[ 13 : 2 ] ][23:8]);
                        
                        4'b0111 :   RAM [ addr_i[13:2]  ]  [ 23 : 0 ] <= ( write_enable_i ) ? ( write_data_i [23:0] ) : ( RAM[ addr_i[ 13 : 2 ] ][23:0]);
                        
                        4'b1000 : RAM [ addr_i[31:2]  ][ 31 : 24 ] <= ( write_enable_i ) ? ( write_data_i[ 31 : 23 ] ) : ( RAM[ addr_i[ 13 : 2 ] ][ 31 : 23 ]);
                        
                        4'b1001 : begin  RAM [ addr_i[13:2]  ] [ 31 : 24 ] <= ( write_enable_i ) ? ( write_data_i [31:24] ) : ( RAM[ addr_i[ 13 : 2 ] ][ 31 : 24 ]); 
                        
                                  RAM [ addr_i[13:2]  ] [ 7 : 0 ]  <= ( write_enable_i ) ? ( write_data_i [ 7 : 0 ] ) : ( RAM[ addr_i[ 13 : 2 ] ][ 7 : 0 ]);end
                                  
                        4'b1010 :  begin RAM [ addr_i[13:2] ] [31 : 24] <= ( write_enable_i ) ? ( write_data_i [31:24] ) : ( RAM[ addr_i[ 13 : 2 ] ][31 : 24]);
                        
                                   RAM [ addr_i[13:2] ] [15 : 8] <= ( write_enable_i ) ? ( write_data_i [15:8] ) : ( RAM[ addr_i[ 13 : 2 ] ][15 : 8]);end
                        
                        4'b1011 :  begin RAM [ addr_i[13:2]  ][ 31: 24 ] <= ( write_enable_i ) ? ( write_data_i [31:24] ) : ( RAM[ addr_i[ 13 : 2 ]  ] [31:24]); 
                        
                                         RAM [ addr_i[13:2]  ][ 15:0 ] <= ( write_enable_i ) ? ( write_data_i [15:0] ) : ( RAM[ addr_i[ 13 : 2 ] ] [ 15:0 ]); end 
                        
                        4'b1100 : begin RAM [ addr_i[13:2]  ] [ 31 : 16 ] <= ( write_enable_i ) ? ( write_data_i [ 31 : 16 ] ) : ( RAM[ addr_i[ 13 : 2 ] ][ 31 : 16 ]); end
                        
                        4'b1101 : begin RAM [ addr_i[13:2]  ] [ 31 : 16] <= ( write_enable_i ) ? ( write_data_i [ 31 : 16] ) : ( RAM[ addr_i[ 13 : 2 ] ][ 31 : 16]); 
                        
                        RAM [ addr_i[13:2]  ] [ 7 : 0] <= ( write_enable_i ) ? ( write_data_i [7:0] ) : ( RAM[ addr_i[ 13 : 2 ] ][ 7 : 0]); end   
                        
                        4'b1111 : RAM [ addr_i[13:2]  ]  <= ( write_enable_i ) ? ( write_data_i ) : ( RAM[ addr_i[ 13 : 2 ] ]);
                        
               endcase
     end          
endmodule
