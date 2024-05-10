`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.12.2023 15:36:16
// Design Name: 
// Module Name: decoder_riscv
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


module decoder_riscv
(
  input          [ 31 : 0 ]   fetched_instr_i,    // 32-х битная инструкция

  output  logic  [ 1 : 0  ]   a_sel_o,      //  Выбор 1-го операнда АЛУ
  output  logic  [ 2 : 0  ]  b_sel_o,      //  Выбор 2-го операнда АЛУ
 
  output  logic  [ 4 : 0  ]   alu_op_o,  //  Выбор операции АЛУ
  output logic   [ 2 : 0  ]   csr_op_o,
  output logic                csr_we_o,
  output  logic               mem_req_o,          //  Запрос к памяти данных
  output  logic               mem_we_o,           //  Запись в память данных
  output  logic  [ 2 : 0  ]   mem_size_o,         //  З/Ч байта, полуслова, слова
  
  output  logic               gpr_we_o,         //  Запись в регистровый файл
  output  logic  [ 1 : 0  ]   wb_sel_o,       //  Выбор источника записи в регистровый файл

  output  logic               illegal_instr_o,    //  Сигнал ошибки

  output  logic               branch_o,           //  Условный переход
  output  logic               jal_o,              //  Сигнал об инструкции безусловного перехода
  output  logic               jalr_o,              //  Переход по регистру с сохранением адреса возрата
  output logic                mret_o
  );
  
  import riscv_pkg::*;
  
  always_comb 
    begin
  
      case ( fetched_instr_i[ 6 : 0 ] ) // Opcode
      
        7'b0110011: // R-type
          begin 
        
            a_sel_o <= 2'd0;
           b_sel_o <= 3'd0;
            
           wb_sel_o <= 2'b00;
            gpr_we_o <= 1;
            
            mem_we_o <= 0;
            mem_req_o <= 0;         
            mem_size_o <= LDST_B;            
            
            branch_o <= 0;
            jal_o <= 0; 
            jalr_o <= 0;
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
        
            case ( { fetched_instr_i [ 31 : 25 ], fetched_instr_i[ 14 : 12 ] } )
            
              10'b0:          alu_op_o <= ALU_ADD;
              10'b0100000000: alu_op_o <= ALU_SUB;
              10'b0000000100: alu_op_o <= ALU_XOR;
              10'b0000000110: alu_op_o <= ALU_OR;
              10'b0000000111: alu_op_o <= ALU_AND;
              10'b0000000001: alu_op_o <= ALU_SLL;
              10'b0000000101: alu_op_o <= ALU_SRL;
              10'b0100000101: alu_op_o <= ALU_SRA;
              10'b0000000010: alu_op_o <= ALU_SLTS;
              10'b0000000011: alu_op_o <= ALU_SLTU;
              
              default:
                begin 

                  
                  illegal_instr_o <= 1'b1;
                  mem_req_o <= 1'b0;
                  gpr_we_o <= 1'b0;
                  alu_op_o <= ALU_ADD;
                 
                
                end 
            
            endcase
        
          end
        
        7'b0010011: // I-type
          begin 
        
           a_sel_o <= 2'd0;
            b_sel_o <= 3'd1;
            
             wb_sel_o <=2'b00;
            gpr_we_o <= 1;
            
            mem_we_o <= 0;
            mem_req_o <= 0;         
            mem_size_o <= LDST_B;            
            
            branch_o <= 0;
            jal_o <= 0; 
            jalr_o <= 0;
            
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
            
        
            case ( fetched_instr_i[ 14 : 12 ] )
            
              3'b000: alu_op_o <= ALU_ADD;
              3'b100: alu_op_o <= ALU_XOR;
              3'b110: alu_op_o <= ALU_OR;
              3'b111: alu_op_o <= ALU_AND;
              3'b010: alu_op_o <= ALU_SLTS;
              3'b011: alu_op_o <= ALU_SLTU;
              
              3'b001: 
                if ( fetched_instr_i[ 31 : 25 ] == 7'd0 ) 

                  alu_op_o <= ALU_SLL;

                else 
                  begin 
                  
                    illegal_instr_o <= 1;
                    mem_req_o <= 0;
                    gpr_we_o <= 0;
                  
                  end 
                      
              3'b101: 
                if ( fetched_instr_i[ 31 : 25 ] == 7'd0 ) 
                  alu_op_o <= ALU_SRL;
                else 
                  if ( fetched_instr_i[ 31 : 25 ] == 7'b0100000) 
                    alu_op_o <= ALU_SRA;
                  else 
                    begin 
                      
                      illegal_instr_o <= 1; 
                      mem_req_o <= 0;  
                      gpr_we_o <= 0;
                       
                    end 
              
              default: 
                begin 
                  
                  illegal_instr_o <= 1; 
                  mem_req_o <= 0;  
                  gpr_we_o <= 0; 
                   mret_o <=0;
            
                   csr_op_o <= 3'b000;
                   csr_we_o <= 1'b0;
                  
                end
            
            endcase     
              
          end
        
        7'b0000011: // I-type (load)
          begin 
        
           a_sel_o <= 2'd0;
            b_sel_o <= 3'd1;
            
            alu_op_o <= ALU_ADD;
            
            mem_req_o <= 1;
        
             wb_sel_o <= 1;
            gpr_we_o <= 1;
            
            
            mem_we_o <= 0;
            
            branch_o <= 0;
            jal_o <= 0; 
            jalr_o <= 0;
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
            
            case ( fetched_instr_i[ 14 : 12 ] )
            
              4'h0: mem_size_o <= LDST_B;
              4'h1: mem_size_o <= LDST_H;
              4'h2: mem_size_o <= LDST_W;
              4'h4: mem_size_o <= LDST_BU;
              4'h5: mem_size_o <= LDST_HU;
              
              default: 
                begin 
                  
                  illegal_instr_o <= 1; 
                  mem_req_o <= 0;
                  gpr_we_o <= 0;
                   mret_o <=0;
            
                   csr_op_o <= 3'b000;
                   csr_we_o <= 1'b0;
                  
                end
                                
            endcase
        
          end
        
        7'b0100011: // S-type
          begin 
        
            a_sel_o <= 2'd0;
            b_sel_o <= 3'd3;
            
            alu_op_o <= ALU_ADD;
            
             wb_sel_o <= 2'b00;
            gpr_we_o <= 0;
            
            mem_req_o <= 1;
            mem_we_o <= 1;
            
            branch_o <= 0;
            jal_o <= 0; 
            jalr_o <= 0;
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
           
        
            case ( fetched_instr_i[ 14 : 12 ] )
            
              4'h0: mem_size_o <= LDST_B;
              4'h1: mem_size_o <= LDST_H;
              4'h2: mem_size_o <= LDST_W;
              
              default: 
                begin 
                  
                  illegal_instr_o <= 1; 
                  mem_req_o <= 0;  
                  gpr_we_o <= 0; 
                  mem_we_o <= 1'b0;
                
                end
                                
            endcase
        
          end
      
        7'b1100011: // B-type
          begin 
        
           a_sel_o <= 2'd0;
            b_sel_o <= 3'd0;
           
             wb_sel_o <= 2'd0;
            gpr_we_o <= 0;
            
            mem_req_o <= 0;
            mem_size_o <= LDST_B;
            mem_we_o <= 0;
            
            branch_o <= 1;
            jalr_o <= 0;
            jal_o <= 0;
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
            
              
            case ( fetched_instr_i[ 14 : 12 ] )
            
              3'b000: alu_op_o <= ALU_EQ;
              3'b001: alu_op_o <= ALU_NE;
              3'b100: alu_op_o <= ALU_LTS;
              3'b101: alu_op_o <= ALU_GES;
              3'b110: alu_op_o <= ALU_LTU;
              3'b111: alu_op_o <= ALU_GEU;
              
              default: 
                begin
              
                  illegal_instr_o <= 1; 
                  mem_req_o <= 0;  
                  gpr_we_o <= 0; 
                  branch_o <= 0;
                  
                end
                                                    
            endcase
        
          end
        
        7'b1101111: // J-type
          begin 
        
            a_sel_o <= 2'd1;
            b_sel_o <= 3'd4;
            
            alu_op_o <= ALU_ADD;
            
             wb_sel_o <= 2'd0;
            gpr_we_o <= 1;
            
            mem_size_o <= LDST_B;
            mem_req_o <= 0;
            mem_we_o <= 0;
            
            branch_o <= 0;
            jalr_o <= 0;
            jal_o <= 1;
            
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
        
          end
        
        7'b1100111: // I-type (jarl) 
          begin 
        
            mem_size_o <= LDST_B;
            mem_req_o <= 0;
            mem_we_o <= 0;
            
            a_sel_o <= 2'd1;
           b_sel_o <= 3'd4;
            
            alu_op_o <= ALU_ADD;
            
           wb_sel_o <=2'd0;
            
            jal_o <= 0;
            branch_o <= 0;
            
                
           mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
            
            if ( fetched_instr_i[ 14 : 12 ] == 3'd0 ) 
              begin  
                
                gpr_we_o <= 1;
                jalr_o <= 1;
                illegal_instr_o <= 0;
                
              end 
            else
              begin
            
                illegal_instr_o <= 1;
                gpr_we_o <= 0;
                jalr_o <= 0;
                
              end
            
          end
        
        7'b0110111: // U-type
          begin 
        
            a_sel_o <= 2'd2;
            b_sel_o <= 3'd2;
                
            alu_op_o <= ALU_ADD;
                
             wb_sel_o <= 2'd0;
            gpr_we_o <= 1;
            
            mem_size_o <= LDST_B;
            mem_req_o <= 0;
            mem_we_o <= 0;
            
            branch_o <= 0;
            jalr_o <= 0;
            jal_o <= 0;
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
           
        
          end
        
        7'b0010111: // U-type (auipc)
          begin 
        
            a_sel_o <= 2'd1;
            b_sel_o <= 3'd2;
                
            alu_op_o <= ALU_ADD;
                
             wb_sel_o <= 2'b0;
            gpr_we_o <= 1;
            
            mem_size_o <= LDST_B;
            mem_req_o <= 0;
            mem_we_o <= 0;
            
            branch_o <= 0;
            jalr_o <= 0;
            jal_o <= 0;
            mret_o <=0;
            
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
                
            illegal_instr_o <= 0;
           
        
          end
          
          7'b1110011: begin // INT_oerrupt
            
               a_sel_o <= 2'd0;
                b_sel_o <= 3'd4;
                    
                alu_op_o <= ALU_ADD;
                    
                wb_sel_o <= 2'b10;
                gpr_we_o <= 1'b0;
                
                mem_size_o <= LDST_B;
                mem_req_o <= 1'b0;
                mem_we_o <= 1'b0;
                
                branch_o <= 1'b0;
                jal_o <= 1'b0; 
                jalr_o <= 2'b00;
                
                csr_op_o<= fetched_instr_i[14:12];
                csr_we_o <= 1'b1;
                gpr_we_o <= 1'b1;
                
                
                
                illegal_instr_o <= 1'b0;
                
                if ( fetched_instr_i[14:12] == 3'b000) begin
                
                         if (fetched_instr_i[31:20] == 12'b001100000010) begin
                            illegal_instr_o <= 1'b0;
                            csr_we_o <= 1'b0;
                            gpr_we_o <= 1'b0;
                
                             mret_o <=1'b1;
                             
                         end 
                            
                            else begin
                        
                        jalr_o <= 2'b10;
                        csr_we_o <= 1'b0;
                        gpr_we_o <= 1'b0;
                        illegal_instr_o <= 1'b1;
                           end
                           
                     end else if ( fetched_instr_i[14:12] == 3'b100 ) begin
                    illegal_instr_o <= 1'b1;
                    csr_we_o <= 1'b0;
                   gpr_we_o <= 1'b0;
                    
                end
                
                end
        
       
          
           7'b0001111: begin // nop
           
           if ( fetched_instr_i[14:12] == 3'b000) begin
            
               a_sel_o <= 2'd2;
            b_sel_o <= 3'd4;
                
            alu_op_o <= ALU_ADD;
                
             wb_sel_o <= 2'b10;
            gpr_we_o <= 0;
            csr_op_o <= 3'b000;
            csr_we_o <= 1'b0;
            
            mem_size_o <= LDST_B;
            mem_req_o <= 0;
            mem_we_o <= 0;
            
            branch_o <= 0;
            jalr_o <= 0;
            jal_o <= 0;
            
            illegal_instr_o <= 0;
        
           end
           else begin 
           
            illegal_instr_o <= 1;
            
            end
       end
           
           
        
        default: 
          begin
        
            a_sel_o <= 2'd2;
            b_sel_o <= 3'd4;
                
            alu_op_o <= ALU_ADD;
                
             wb_sel_o <= 0;
             gpr_we_o <= 0;
            
            mem_size_o <= LDST_B;
            mem_req_o <= 0;
            mem_we_o <= 0;
            
             csr_op_o <= 3'b000;
             csr_we_o <= 1'b0;
             
            branch_o <= 0;
            jalr_o <= 0;
            jal_o <= 0;
            mret_o <=0;
            illegal_instr_o <= 1;
        
          end
      
      endcase
  
  end
    
endmodule

