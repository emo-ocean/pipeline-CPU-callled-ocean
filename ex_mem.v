`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 12:01:16
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
	input wire clk,
	input wire rst,
	//from ex stage
	input wire[`reg_addr_bus] em_des_addr,
	input wire em_des_exist,
	input wire[`reg_bus] em_des_data,
	//pass to mem stage
	output reg[`reg_addr_bus] mem_des_addr,
	output reg mem_des_exist,
	output reg[`reg_bus] mem_des_data
);
always@(posedge clk)begin
	if(rst==`rst_enable)begin
		mem_des_addr<=`nop_reg_addr;
		mem_des_exist<=`write_disable;
		mem_des_data<=`zero_word;
	end else begin
		mem_des_addr<=em_des_addr;
		mem_des_exist<=em_des_exist;
		mem_des_data<=em_des_data;
	end
end

endmodule
