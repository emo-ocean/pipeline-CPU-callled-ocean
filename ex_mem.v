//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2023 		                          ////
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
// Module:  ex_mem
// File:    ex_mem.v
// Author:  yuzehai
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex_mem(

	input	wire			clk,
	input wire			rst,
		
	//from ex	
	input wire[`RegAddrBus]       ex_des_addr,
	input wire                    ex_des_exist,
	input wire[`RegBus]		ex_des_data, 	
	
	//pass to mem
	output reg[`RegAddrBus]      mem_des_addr,
	output reg                   mem_des_exist,
	output reg[`RegBus]		 mem_des_data
		
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_des_addr <= `NOPRegAddr;
			mem_des_exist <= `WriteDisable;
		  	mem_des_data <= `ZeroWord;	
		end else begin
			mem_des_addr <= ex_des_addr;
			mem_des_exist <= ex_des_exist;
			mem_des_data <= ex_des_data;			
		end    //if
	end      //always
			

endmodule
