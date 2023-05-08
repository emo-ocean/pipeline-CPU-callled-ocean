`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 15:21:34
// Design Name: 
// Module Name: mem
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


module mem(
	input wire rst,
	//from ex stage
	input wire[`reg_addr_bus] mem_des_addr_in,
	input wire mem_des_exist_in,
	input wire[`reg_bus] mem_des_data_in,
	//result of mem stage
	output reg[`reg_addr_bus] mem_des_addr_out,
	output reg mem_des_exist_out,
	output reg[`reg_bus] mem_des_data_out
);
always@(*)begin
	if(rst==`rst_enable)begin
		mem_des_addr_out<=`nop_reg_addr;
		mem_des_exist_out<=`write_disable;
		mem_des_data_out<=`zero_word;
	end else begin
		mem_des_addr_out<=mem_des_addr_in;
		mem_des_exist_out<=mem_des_exist_in;
		mem_des_data_out<=mem_des_data_in;
	end
end
endmodule
