`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2024 18:39:19
// Design Name: 
// Module Name: riscv_lsu
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


module riscv_lsu(

     input clk_i,  
    input rst_i, 
    
    // Core protocol
    input [31:0] core_addr_i, 
    input core_we_i,         
    input [2:0] core_size_i, 
    input [31:0] core_wd_i, 
    input core_req_i,         
    output logic core_stall_o,  
    output logic [31:0] core_rd_o, 
    
    // Memory protocol
    input [31:0] mem_rd_i,       
    output logic mem_req_o, 
    input  logic  mem_ready_i,        
    output logic mem_we_o,          
    output logic [3:0] mem_be_o,    
    output logic [31:0] mem_addr_o, 
    output logic [31:0] mem_wd_o 
    
    
    );
    logic stall_reg;
     import riscv_pkg::*;
    
    parameter IDLE = 2'b00;
    parameter WRITE = 2'b01;
    parameter READ = 2'b10;
    
    logic [1:0] state = IDLE;
     assign core_stall_o = ~(stall_reg && mem_ready_i)&&core_req_i;
    
     assign  mem_we_o=core_we_i;
     assign  mem_req_o=core_req_i;
     assign mem_addr_o=core_addr_i;
    always_ff @( posedge clk_i ) begin
        stall_reg<=core_stall_o;
        if ( rst_i )  
            core_stall_o<=0;
            
           end
   
    always_comb
         case ( core_size_i )
                
                                LDST_B: begin
                                
                                    mem_wd_o <= {4{core_wd_i[7:0]}};
                                    
                                    case ( core_addr_i[1:0] )
                                    
                                        2'd0: mem_be_o <= 4'b0001;
                                        2'd1: mem_be_o <= 4'b0010;
                                        2'd2: mem_be_o <= 4'b0100;
                                        2'd3: mem_be_o <= 4'b1000;
                                    
                                    endcase
                                     end
                                  LDST_H: begin
                                
                                    mem_wd_o <= { 2{core_wd_i[15:0]} };
                                    
                                    case ( core_addr_i[1] )
                                    
                                        1'd0: mem_be_o <= 4'b0011;
                                        1'd1: mem_be_o <= 4'b1100;
                                        
                                        default: mem_be_o <= 4'b0011;
                                    
                                    endcase
                                    
                                end
                                
                                LDST_W: begin
                                
                                    mem_wd_o <= core_wd_i;
                                    mem_be_o <= 4'b1111;
                                
                                end
                            
                            endcase
        always_comb               
        case ( core_size_i )
                            
                                LDST_B: case ( core_addr_i[1:0] )
                                 
                                    2'd0: core_rd_o <= { {24{mem_rd_i[7]}}, mem_rd_i[7:0] };
                                    2'd1: core_rd_o <= { {24{mem_rd_i[15]}}, mem_rd_i[15:8] };
                                    2'd2: core_rd_o <= { {24{mem_rd_i[23]}}, mem_rd_i[23:16] };
                                    2'd3: core_rd_o <= { {24{mem_rd_i[31]}}, mem_rd_i[31:24] };
                                    
                                endcase
                                
                                LDST_H: case ( core_addr_i[1] ) 
                                
                                    1'd0: core_rd_o <= { {16{mem_rd_i[15]}}, mem_rd_i[15:0] };
                                    1'd1: core_rd_o <= { {16{mem_rd_i[31]}}, mem_rd_i[31:16] };
                                    
                                endcase
                                
                                LDST_W: core_rd_o <= mem_rd_i;
                                
                                LDST_BU: case ( core_addr_i[1:0] )
                                 
                                    2'd0: core_rd_o <= { 24'd0, mem_rd_i[7:0] };
                                    2'd1: core_rd_o <= { 24'd0, mem_rd_i[15:8] };
                                    2'd2: core_rd_o <= { 24'd0, mem_rd_i[23:16] };
                                    2'd3: core_rd_o <= { 24'd0, mem_rd_i[31:24] };
                                    
                                endcase
                                
                                LDST_HU: case ( core_addr_i[1] ) 
                                
                                    1'd0: core_rd_o <= { 16'd0, mem_rd_i[15:0] };
                                    1'd1: core_rd_o <= { 16'd0, mem_rd_i[31:16] };
                                    
                                endcase
                            
                            endcase
    
    
           
 endmodule

