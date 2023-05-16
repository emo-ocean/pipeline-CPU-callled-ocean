//////////////////////////////////////////////////////////////////////
////                                                              ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  mem_wb
// File:    mem_wb.v
// Author:  yuzehai
// Description: mem_wb
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module mem_wb(

	input	wire			clk,
	input wire			rst,
	

	//from mem	
	input wire[`RegAddrBus]       mem_des_addr,
	input wire                    mem_des_exist,
	input wire[`RegBus]		mem_des_data,

	//pass to wb
	output reg[`RegAddrBus]      wb_des_addr,
	output reg                   wb_des_exist,
	output reg[`RegBus]		wb_des_data	       
	
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_des_addr <= `NOPRegAddr;
			wb_des_exist <= `WriteDisable;
		 	wb_des_data <= `ZeroWord;	
		end else begin
			wb_des_addr <= mem_des_addr;
			wb_des_exist <= mem_des_exist;
			wb_des_data <= mem_des_data;
		end    //if
	end      //always
			

endmodule
