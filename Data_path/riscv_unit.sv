`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2023 15:13:19
// Design Name: 
// Module Name: riscv_unit
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


module riscv_unit(
 input  logic        clk_i,
  input  logic        rst_i

    );
    
    
    logic [ 31 : 0 ] PC;

  ////////////Instruction memory////////////////////////
  logic [ 31 : 0 ] instr;
  instr_mem IM
  (
    
    .addr_i ( PC     ),
    .read_data_o ( instr  )

  );
    
        
     logic           req;       //  Запрос к памяти данных
     logic            WE;        //  Запись в память данных
     logic [ 31 : 0 ] WD;
     logic [ 31 : 0 ] Ad;
     logic [ 31 : 0 ] RD;
     
     data_mem DM 
  (

    .clk_i( clk_i      ),
    .addr_i  ( Ad ),
    .write_data_i ( WD       ),
    .write_enable_i ( WE     ),
    .read_data_o( RD         ),
    .mem_req_i (req) 
  );
   logic stall;
  
    riscv_core core 
    ( 
      .mem_req_o(req),
      .instr_addr_o (PC),
      .instr_i ( instr ),
      . clk_i ( clk_i ),
      . rst_i( rst_i ),
      . mem_rd_i ( RD ),
      .mem_we_o ( WE ),
      .stall_i ( stall ),
      .mem_addr_o ( Ad ),
      .mem_wd_o ( WD ) 
     );
     
    
   
   
   
   
   
    always_ff @(posedge clk_i)
      if (rst_i) 
      
      stall<=1 ;
      
      else  if (stall)
       stall<=0;
       
       else
      
        if ( (~stall)&(req)) 
        
         stall <=1;
         
         
         
endmodule
