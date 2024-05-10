`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2023 11:35:34
// Design Name: 
// Module Name: cyber_cobra
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


module cyber_cobra
(
  input             clk_i,
                    rst_i,
  
         [ 15 : 0 ] sw_i,
         
  output [ 31 : 0 ] out_o
);
    
  ////////////////////////////////////
  
  logic [ 31 : 0 ]  PC = 8'd0;
  logic [ 31 : 0 ] Instr;
  
  instr_mem IM 
  ( 
    .addr_i ( PC    ), 
    .read_data_o( Instr ) 
  );
  
  ////////////////////////////////////
  
  logic [ 31 : 0 ] RD1, 
                   RD2,
                   WD;
  
  rf_riscv RF 
  ( 
      .clk_i( clk_i                       ),
       
      .write_enable_i( ~(Instr[ 31 ] | Instr[ 30 ]) ),
       
      .read_addr1_i ( Instr[ 22 : 18 ]          ), 
      .read_addr2_i ( Instr[ 17 : 13 ]          ), 
      .write_addr_i ( Instr[ 4  : 0  ]          ), 
      
      .write_data_i( WD                        ),
       
      .read_data1_o( RD1                       ), 
      .read_data2_o( RD2                       )
   );
  
  ////////////////////////////////////
  
  logic [ 31 :0 ] ALU_result;
  logic Flag;
  
  alu_riscv ALU 
  (
    .a_i     ( RD1              ), 
    .b_i     ( RD2              ),
     
    .alu_op_i ( Instr[ 27 : 23 ] ), 
    
    .result_o( ALU_result       ), 
    
    .flag_o  ( Flag             )
      
  );
  
  /////////////////////////////////// 
  logic [1:0] WS ;
  assign WS=Instr[ 29 : 28 ];
  always_comb
    case ( WS )
    
      2'b00: WD <=  { { 9{ Instr[ 27 ] } }, Instr[ 27 : 5 ] };
      2'b01: WD <= ALU_result;
      2'b10: WD <= {{16{sw_i[15]}},sw_i};
      
      default: WD <= 32'd0;   
        
    endcase
  
  always_ff @( posedge clk_i )
      if ( rst_i ) 
        PC <= 32'd0;
      else
        if ( Instr[ 31 ] | ( Instr[ 30 ] & Flag ) )
            PC <= PC + 32'd4*Instr[ 12 : 5 ];
        else
            PC <= PC + 32'd4;

  assign out_o = RD1;
          
endmodule
