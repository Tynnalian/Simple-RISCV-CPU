`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2023 18:19:21
// Design Name: 
// Module Name: risc_v_core
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


module riscv_core
(
  ///////Control pins///////////

  input clk_i,
  input rst_i,
  
  input stall_i,

  input  logic [31:0] instr_i,
  input  logic [31:0] mem_rd_i,

  output logic [31:0] instr_addr_o,
  output logic [31:0] mem_addr_o,
  output logic [ 2:0] mem_size_o,
  output logic        mem_req_o,
  output logic        mem_we_o,
  output logic [31:0] mem_wd_o
);
    
  ////////////////Main decoder//////////////////////////////////
  

      
  logic  [ 4 : 0 ] alu_op;        //  Выбор операции АЛУ
      
  
 
  
   //  Выбор источника записи в регистровый файл
      
  logic            illegal_instr; //  Сигнал ошибки
      
  logic            branch;        //  Условный переход
  logic            jal;           //  Сигнал об инструкции безусловного перехода
  logic            jalr;   

  
  logic            gpr_we_a;      //  Запись в регистровый файл
  logic     [1:0]   wb_src_sel;    //  Выбор источника записи в регистровый файл
      

      
  
  //////////////////////////////////////////////////////////////////////////////
    
  
 logic  [ 1 : 0 ] ex_op_a_sel;      
  logic  [ 2 : 0 ] ex_op_b_sel;   


  decoder_riscv MD 
  
  (
  
    .fetched_instr_i( instr_i         ),
  
    .a_sel_o  ( ex_op_a_sel   ),      
    .b_sel_o  ( ex_op_b_sel   ),      
  
    .alu_op_o       ( alu_op        ),
  
    .mem_req_o      ( mem_req_o       ),
    .mem_we_o       ( mem_we_o        ),           
    .mem_size_o     ( mem_size_o      ),       
  
    .gpr_we_o     ( gpr_we_a      ),         
    .wb_sel_o   ( wb_src_sel    ),       
    
    .illegal_instr_o( illegal_instr ),
  
    .branch_o       ( branch        ),      
    .jal_o          ( jal           ),             
    .jalr_o         ( jalr          )
  
  );
  
  /////////////////////////////////////////////////////////////
  
  logic [ 31 : 0 ] PC;

 
  ////////////Register file/////////////////////////////
  logic we_a;
  logic [ 31 : 0 ] RD1,
                   RD2;
  assign mem_wd_o=RD2;
  logic [ 31 : 0 ] wb_data;
 assign we_a=~stall_i& gpr_we_a ;
  rf_riscv RF 
  (

    .clk_i( clk_i           ),
    .write_enable_i ( gpr_we_a      ),
    
    .read_addr1_i( instr_i[ 19 : 15 ] ),
    .read_addr2_i( instr_i[ 24 : 20 ] ),
    .write_addr_i( instr_i[ 11 : 7  ] ),
    
    .write_data_i( wb_data),
    
    .read_data1_o( RD1             ), 
    .read_data2_o( RD2            )
  
  );
  
  ///////////////////////////////////////////
  
  logic [ 31 : 0 ] A_selected, B_selected;
  
  logic [ 31 : 0 ] ALU_result;
  
  logic Comparison;
  
  ///////////////////////////////////////////
  
  alu_riscv ALU 
  (
  
    .a_i     ( A_selected ),
    .b_i     ( B_selected ),

    .alu_op_i ( alu_op     ),

    .result_o( ALU_result ),
    .flag_o  ( Comparison )
  
  );
  
  assign mem_addr_o = ALU_result;
  
  /////////////////Immediate////////////////////////////////////////////////////////
  
  logic [ 31 : 0 ] imm_I, imm_S, imm_J, imm_B;
  
  assign imm_I = { { 20{ instr_i[ 31 ] } }, instr_i[ 31 : 20 ] };
  assign imm_S = { { 20{ instr_i[ 31 ] } }, instr_i[ 31 : 25 ], instr_i[ 11 : 7 ] };
  assign imm_J = { { 11{ instr_i[ 31 ] } }, instr_i[ 31 ], instr_i[ 19 : 12 ], instr_i[ 20 ], instr_i[ 30 : 21 ], 1'b0};
  assign imm_B = { { 19{ instr_i[ 31 ] } }, instr_i[ 31 ], instr_i[ 7 ], instr_i[ 30 : 25 ], instr_i[ 11 : 8 ], 1'b0 };
  
  //////////Select box/////////////////////////////////////////////////////////////////
  
  always_comb
    begin
  
      case ( ex_op_a_sel )
      
          2'd0: A_selected <= RD1;
          2'd1: A_selected <= PC;
          2'd2: A_selected <= 32'd0;
          
          default: A_selected <= 32'd0;
      
      endcase
      
      case ( ex_op_b_sel )
      
          3'd0: B_selected <= RD2;
          3'd1: B_selected <= imm_I;
          3'd2: B_selected <= { instr_i[ 31 : 12 ], 12'd0 };
          3'd3: B_selected <= imm_S;
          3'd4: B_selected <= 32'd4;
          
          default: B_selected <= 32'd0;
      
      endcase

 wb_data<= ( wb_src_sel ) ? ( mem_rd_i ) : ( ALU_result );
  
    end
  
  /////////Control PC/////////////////////////////////////
  assign instr_addr_o =PC; 
  always_ff @( posedge clk_i )
 /* 
    PC <= ( rst_i ) ? ( 32'd0 ) :
        ( ( jalr ) ? ( RD1 + imm_I ) : 
        ( ( jal || Comparison && branch ) ? ( ( branch ) ? ( PC + imm_B ) : ( PC + imm_J ) ) : ( PC + 32'd4 ) ) );
  *///////
   
 
    if ( rst_i ) begin
      PC <= 32'd0; 
      
        end
    else 
      if (stall_i) begin
      PC <= PC; 
       end
      else  
        if ( jalr ) begin
        PC <= RD1 + imm_I;
         end
        else 
            if ( jal || Comparison && branch )
            if ( branch ) begin  PC <= PC + imm_B;   end
            else    begin       PC <= PC + imm_J;   end

            else begin PC <= PC + 32'd4;    end
           
      
  
    
endmodule
