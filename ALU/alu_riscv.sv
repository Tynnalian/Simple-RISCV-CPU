`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2023 12:41:39
// Design Name: 
// Module Name: alu_riscv
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


module alu_riscv #( parameter N = 32 )
(
  input [ N - 1 : 0 ]        a_i,
                             b_i,
        
        [ 4 : 0 ]            alu_op_i,
  
  output logic [ N - 1 : 0 ] result_o,
         logic               flag_o
                            
  
    );
    
    logic [N-1:0] add_res;
  import alu_opcodes_pkg::*;
  adder32 adder32 (.a(a_i),.b(b_i), .sum(add_res)) ;
  
  always_comb
  
    case ( alu_op_i )

      ALU_ADD : begin result_o <= add_res;                   end
      ALU_SUB : begin result_o <= a_i - b_i;                 end
  
      ALU_SLL : begin result_o <= a_i <<  b_i [4:0];                 end
      ALU_SLTS : begin result_o <= $signed( a_i) < $signed(b_i );      end
      ALU_SLTU: begin result_o <= a_i < b_i ;                 end
  
      ALU_XOR : begin result_o <= a_i ^ b_i;                 end
  
      ALU_SRL : begin result_o <= a_i >> b_i [4:0] ;                end
      ALU_SRA : begin result_o <= $signed( a_i ) >>> b_i [4:0];    end
  
      ALU_OR  : begin result_o <= a_i | b_i;                end
      ALU_AND : begin result_o <= a_i & b_i;                 end
     
      default : begin result_o <= 32'd0;                       end

  endcase
     
 always_comb
  
    case ( alu_op_i )
      
      ALU_EQ : begin flag_o   <= a_i == b_i;               end
      ALU_NE : begin flag_o   <= a_i != b_i;               end

      ALU_LTS : begin flag_o   <= $signed( a_i) < $signed( b_i );      end
      ALU_GES : begin flag_o   <= $signed( a_i) >= $signed(b_i );     end

      ALU_LTU: begin flag_o   <= ( a_i < b_i );             end
      ALU_GEU: begin flag_o   <= ( a_i >= b_i );            end

      default : begin  flag_o   <= 32'd0; end

  endcase
    
endmodule

