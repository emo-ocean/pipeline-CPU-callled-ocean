`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 11:08:46
// Design Name: 
// Module Name: id_ex
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

module id_ex(
	input wire rst,
	input wire clk,
	//from id stage
	input wire[`alu_op_bus] ie_alu_op,
	input wire[`alu_sel_bus] ie_alu_sel,
	input wire[`reg_bus] ie_src1,
	input wire[`reg_bus] ie_src2,
	input wire[`reg_addr_bus] ie_des_addr,
	input wire ie_des_exist,
	//to ex stage
	output reg[`alu_op_bus] ex_alu_op,
	output reg[`alu_sel_bus] ex_alu_sel,
	output reg[`reg_bus] ex_src1,
	output reg[`reg_bus] ex_src2,
	output reg[`reg_addr_bus] ex_des_addr,
	output reg ex_des_exist
);

always@(posedge clk)begin
if (rst == `rst_enable)begin
	ex_alu_op <= `exe_nop_op;
	ex_alu_sel <= `exe_res_nop;
	ex_src1 <= `zero_word;
	ex_src2 <= `zero_word;
	ex_des_addr <= `nop_reg_addr;
	ex_des_exist <= `write_disable;
end else begin
	ex_alu_op <= ie_alu_op;
	ex_alu_sel <= ie_alu_sel;
	ex_src1 <= ie_src1;
	ex_src2 <= ie_src2;
	ex_des_addr <= ie_des_addr;
	ex_des_exist <= ie_des_exist;
	end
end

endmodule
