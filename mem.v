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
// Module:  mem
// File:    mem.v
// Author:  yuzehai
// Description: mem stage
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module mem(

	input wire			rst,
	
	//from ex	
	input wire[`RegAddrBus]       des_addr_in,
	input wire                    des_exist_in,
	input wire[`RegBus]		des_data_in,
	
	//pass to wb
	output reg[`RegAddrBus]      des_addr_out,
	output reg                   des_exist_out,
	output reg[`RegBus]		 des_data_out
	
);

	
	always @ (*) begin
		if(rst == `RstEnable) begin
			des_addr_out <= `NOPRegAddr;
			des_exist_out <= `WriteDisable;
		  	des_data_out <= `ZeroWord;
		end else begin
		  	des_addr_out <= des_addr_in;
			des_exist_out <= des_exist_in;
			des_data_out <= des_data_in;
		end    //if
	end      //always
			

endmodule
