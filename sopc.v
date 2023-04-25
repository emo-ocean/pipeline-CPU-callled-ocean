`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/18 16:24:51
// Design Name: 
// Module Name: sopc
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


module sopc(
	input wire clk,
	input wire rst
);

wire[`inst_addr_bus] inst_addr;
wire[`inst_bus] inst;
wire rom_en_sopc;

//top_module_instance
top_module top_module_instance(
	.clk(clk), .rst(rst),
	.rom_addr_out(inst_addr), .rom_data_in(inst),
	.rom_en_out(rom_en_sopc)
);
//rom instance
inst_rom inst_rom_instance(
	.rom_en_in(rom_en_sopc),
	.addr(inst_addr), .inst(inst)
);

endmodule