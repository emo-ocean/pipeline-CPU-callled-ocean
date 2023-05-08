`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/15 21:45:41
// Design Name: 
// Module Name: regfile
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


module regfile(
	input wire clk,
	input wire rst,

	//write interface
	input wire write_en,
	input wire[`reg_addr_bus] write_reg_addr,
	input wire[`reg_bus] write_data,

	//read interface 1
	input wire read_en_first,
	input wire[`reg_addr_bus] read_reg_addr_first,
	output reg[`reg_bus] read_out_data_first,

	//read interface 2
	input wire read_en_second,
	input wire[`reg_addr_bus] read_reg_addr_second,
	output reg[`reg_bus] read_out_data_second
);

//define 32 32-bits reg
reg[`reg_bus] regs[0:`reg_num-1];
//write exe
always@(posedge clk)begin
if (rst == `rst_disable)begin
	if ((write_en == `write_enable) && (write_reg_addr != `reg_num_log2'h0))begin
		//final reg 00000 can not be written
		regs[write_reg_addr] <= write_data;
end
end
end
//read interface 1
always@(*) begin
if (rst == `rst_enable)begin
	read_out_data_first <= `zero_word;
	end else if (read_reg_addr_first == `reg_num_log2'h0)begin
		read_out_data_first <= `zero_word;
		end else if ((read_reg_addr_first == write_reg_addr) && (write_en == `write_enable)
			&& (read_en_first == `read_enable))begin
			read_out_data_first <= write_data;
	end else if(read_en_first == `read_enable)begin
	read_out_data_first <= regs[read_reg_addr_first];
	end else begin
	read_out_data_first <= `zero_word; end
	end

//read interface 2
always@(*) begin
if (rst == `rst_enable)begin
	read_out_data_second <= `zero_word;
	end else if (read_reg_addr_second == `reg_num_log2'h0)begin
		read_out_data_second <= `zero_word;
		end else if ((read_reg_addr_second == write_reg_addr) && (write_en == `write_enable)
			&& (read_en_second == `read_enable))begin
			read_out_data_second <= write_data;
	end else if (read_en_second == `read_enable)begin
		read_out_data_second <= regs[read_reg_addr_second];
		end else begin
		read_out_data_second <= `zero_word; end
		end

endmodule

