`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 15:32:08
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
	input wire rst,
	input wire clk,
	//result of mem stage
	input wire[`reg_addr_bus] mw_des_addr,
	input wire mw_des_exist,
	input wire[`reg_bus] mw_des_data,
	//pass to wb stage
	output reg[`reg_addr_bus] wb_des_addr,
	output reg wb_des_exist,
	output reg[`reg_bus] wb_des_data
);

always@(posedge clk)begin
	if(rst==`rst_enable)begin
		wb_des_addr<=`nop_reg_addr;
		wb_des_exist<=`write_disable;
		wb_des_data<=`zero_word;
	end else begin
		wb_des_addr<=mw_des_addr;
		wb_des_exist<=mw_des_exist;
		wb_des_data<=mw_des_data;
	end
	end

endmodule
