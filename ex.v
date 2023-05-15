//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2023 2983643426@qq.com                        ////
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
// Module:  ex
// File:    ex.v
// Author:  yuzehai
// Description: ex stage
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex(

	input wire			rst,
	
	//from id to ex 
	input wire[`AluOpBus]         aluop_in,
	input wire[`AluSelBus]        alusel_in,
	input wire[`RegBus]           reg1_data_in,
	input wire[`RegBus]           reg2_data_in,
	input wire[`RegAddrBus]       des_addr_in,
	input wire                    des_exist_in,

	//ex result
	output reg[`RegAddrBus]       des_addr_out,
	output reg                    des_exist_out,
	output reg[`RegBus]		des_data_out
	
);

	reg[`RegBus] logicout;
	reg[`RegBus] shiftres;
		
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_in)
				`EXE_OR_OP:		begin
					logicout <= reg1_data_in | reg2_data_in;
				end
				`EXE_AND_OP:		begin
					logicout <= reg1_data_in & reg2_data_in;
				end
				`EXE_NOR_OP:		begin
					logicout <= ~(reg1_data_in | reg2_data_in);
				end
				`EXE_XOR_OP:		begin
					logicout <= reg1_data_in ^ reg2_data_in;
				end
				default:		begin
					logicout <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	always @ (*) begin
		if(rst == `RstEnable) begin
			shiftres <= `ZeroWord;
		end else begin
			case (aluop_in)
				`EXE_SLL_OP:		begin
					shiftres <= reg2_data_in << reg1_data_in[4:0] ;
				end
				`EXE_SRL_OP:		begin
					shiftres <= reg2_data_in >> reg1_data_in[4:0];
				end
				`EXE_SRA_OP:		begin
					shiftres <= ({32{reg2_data_in[31]}} << (6'd32-{1'b0, reg1_data_in[4:0]})) | reg2_data_in >> reg1_data_in[4:0];
				end
				default:				begin
					shiftres <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always


 always @ (*) begin
	 des_addr_out <= des_addr_in;	 	 	
	 des_exist_out <= des_exist_in;
	 case ( alusel_in ) 
	 	`EXE_RES_LOGIC:		begin
	 		des_data_out <= logicout;
	 	end
	 	`EXE_RES_SHIFT:		begin
	 		des_data_out <= shiftres;
	 	end	 	
	 	default:		begin
	 		des_data_out <= `ZeroWord;
	 	end
	 endcase
 end	

endmodule
