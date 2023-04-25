`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/18 16:15:37
// Design Name: 
// Module Name: inst_rom
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


module inst_rom(
	input wire rom_en_in,
	input wire[`inst_addr_bus] addr,
	output reg[`inst_bus] inst
);

reg[`inst_bus] inst_mem[`inst_mem_num-1:0];

initial $readmemh("C:/Users/lx/Desktop/inst_rom.data", inst_mem);

always@(*)begin
	if(rom_en_in==`chip_disable)begin
		inst<=`zero_word;
	end else if(rom_en_in==`chip_enable) begin
		inst<=inst_mem[addr[`inst_mem_num_log2+1:2]];
	end
end
endmodule