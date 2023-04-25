`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/15 21:23:46
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input wire clk,
    input wire rst,
    output reg [`inst_addr_bus] pc,
    output reg inst_mem_en //指令存储器使能信号
    );
    
    always@(posedge clk) begin
        if(rst==`rst_enable) begin
            inst_mem_en=`chip_disable;
        end else begin
            inst_mem_en=`chip_enable;
        end
    end 
    
    always@(posedge clk) begin
        if(inst_mem_en==`chip_disable)begin
            pc=32'h00000000;
        end else begin
            pc=pc+4'h4;
        end
    end
    
endmodule
