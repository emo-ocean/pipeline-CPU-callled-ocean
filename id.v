//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C)                                                ////
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
// Module:  id
// File:    id.v
// Author:  yuzehai
// E-mail:  
// Description: id stage
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module id(

	input wire			rst,
	input wire[`InstAddrBus]	pc_in,
	input wire[`InstBus]          inst_in,

	//from ex to id(raw problem)
	input wire			ex_des_exist_in,//wreg
	input wire[`RegBus]		ex_des_data_in,//wdata
	input wire[`RegAddrBus]       ex_des_addr_in,//wd
	
	//from mem to id(raw problem)
	input wire			mem_des_exist_in,
	input wire[`RegBus]		mem_des_data_in,
	input wire[`RegAddrBus]       mem_des_addr_in,
	
	//from regfile to id
	input wire[`RegBus]           reg1_data_in,
	input wire[`RegBus]           reg2_data_in,

	//pass to regfile
	output reg                    reg1_read_out,
	output reg                    reg2_read_out,     
	output reg[`RegAddrBus]       reg1_addr_out,
	output reg[`RegAddrBus]       reg2_addr_out, 	      
	
	//pass to ex
	output reg[`AluOpBus]         aluop_out,
	output reg[`AluSelBus]        alusel_out,
	output reg[`RegBus]           reg1_data_out,
	output reg[`RegBus]           reg2_data_out,
	output reg[`RegAddrBus]       des_addr_out,
	output reg                    des_exist_out
);

	wire[5:0] op = inst_in[31:26];
	wire[4:0] op2 = inst_in[10:6];
	wire[5:0] op3 = inst_in[5:0];
	wire[4:0] op4 = inst_in[20:16];
  reg[`RegBus]	imm;
  reg instvalid;
  
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_out <= `EXE_NOP_OP;
			alusel_out <= `EXE_RES_NOP;
			des_addr_out <= `NOPRegAddr;
			des_exist_out <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_out <= 1'b0;
			reg2_read_out <= 1'b0;
			reg1_addr_out <= `NOPRegAddr;
			reg2_addr_out <= `NOPRegAddr;
			imm <= 32'h0;			
	  end else begin
			aluop_out <= `EXE_NOP_OP;
			alusel_out <= `EXE_RES_NOP;
			des_addr_out <= inst_in[15:11];
			des_exist_out <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_out <= 1'b0;
			reg2_read_out <= 1'b0;
			reg1_addr_out <= inst_in[25:21];
			reg2_addr_out <= inst_in[20:16];		
			imm <= `ZeroWord;
		  case (op)
		    `EXE_SPECIAL_INST:		begin
		    	case (op2)
		    		5'b00000:			begin
		    			case (op3)
		    				`EXE_OR:	begin
		    					des_exist_out <= `WriteEnable;		aluop_out <= `EXE_OR_OP;
		  						alusel_out <= `EXE_RES_LOGIC; 	reg1_read_out <= 1'b1;	reg2_read_out <= 1'b1;
		  						instvalid <= `InstValid;	
								end  
		    				`EXE_AND:	begin
		    					des_exist_out <= `WriteEnable;		aluop_out <= `EXE_AND_OP;
		  						alusel_out <= `EXE_RES_LOGIC;	  reg1_read_out <= 1'b1;	reg2_read_out <= 1'b1;	
		  						instvalid <= `InstValid;	
								end  	
		    				`EXE_XOR:	begin
		    					des_exist_out <= `WriteEnable;		aluop_out <= `EXE_XOR_OP;
		  						alusel_out <= `EXE_RES_LOGIC;		reg1_read_out <= 1'b1;	reg2_read_out <= 1'b1;	
		  						instvalid <= `InstValid;	
								end  				
		    				`EXE_NOR:	begin
		    					des_exist_out <= `WriteEnable;		aluop_out <= `EXE_NOR_OP;
		  						alusel_out <= `EXE_RES_LOGIC;		reg1_read_out <= 1'b1;	reg2_read_out <= 1'b1;	
		  						instvalid <= `InstValid;	
								end 
						`EXE_SLLV: begin
									des_exist_out <= `WriteEnable;		aluop_out <= `EXE_SLL_OP;
		  						alusel_out <= `EXE_RES_SHIFT;		reg1_read_out <= 1'b1;	reg2_read_out <= 1'b1;
		  						instvalid <= `InstValid;	
								end 
						`EXE_SRLV: begin
									des_exist_out <= `WriteEnable;		aluop_out <= `EXE_SRL_OP;
		  						alusel_out <= `EXE_RES_SHIFT;		reg1_read_out <= 1'b1;	reg2_read_out <= 1'b1;
		  						instvalid <= `InstValid;	
								end 					
						`EXE_SRAV: begin
									des_exist_out <= `WriteEnable;		aluop_out <= `EXE_SRA_OP;
		  						alusel_out <= `EXE_RES_SHIFT;		reg1_read_out <= 1'b1;	reg2_read_out <= 1'b1;
		  						instvalid <= `InstValid;			
		  						end			
						`EXE_SYNC: begin
									des_exist_out <= `WriteDisable;		aluop_out <= `EXE_NOP_OP;
		  						alusel_out <= `EXE_RES_NOP;		reg1_read_out <= 1'b0;	reg2_read_out <= 1'b1;
		  						instvalid <= `InstValid;	
								end								  									
						    default:	begin
						    end
						  endcase
						 end
						default: begin
						end
					endcase	
					end									  
		  	`EXE_ORI:			begin                        //ORI指令
		  		des_exist_out <= `WriteEnable;		aluop_out <= `EXE_OR_OP;
		  		alusel_out <= `EXE_RES_LOGIC; reg1_read_out <= 1'b1;	reg2_read_out <= 1'b0;	  	
				imm <= {16'h0, inst_in[15:0]};		des_addr_out <= inst_in[20:16];
					instvalid <= `InstValid;	
		  	end
		  	`EXE_ANDI:			begin
		  		des_exist_out <= `WriteEnable;		aluop_out <= `EXE_AND_OP;
		  		alusel_out <= `EXE_RES_LOGIC;	reg1_read_out <= 1'b1;	reg2_read_out <= 1'b0;	  	
				imm <= {16'h0, inst_in[15:0]};		des_addr_out <= inst_in[20:16];		  	
					instvalid <= `InstValid;	
				end	 	
		  	`EXE_XORI:			begin
		  		des_exist_out <= `WriteEnable;		aluop_out <= `EXE_XOR_OP;
		  		alusel_out <= `EXE_RES_LOGIC;	reg1_read_out <= 1'b1;	reg2_read_out <= 1'b0;	  	
				imm <= {16'h0, inst_in[15:0]};		des_addr_out <= inst_in[20:16];		  	
					instvalid <= `InstValid;	
				end	 		
		  	`EXE_LUI:			begin
		  		des_exist_out <= `WriteEnable;		aluop_out <= `EXE_OR_OP;
		  		alusel_out <= `EXE_RES_LOGIC; reg1_read_out <= 1'b1;	reg2_read_out <= 1'b0;	  	
				imm <= {inst_in[15:0], 16'h0};		des_addr_out <= inst_in[20:16];		  	
					instvalid <= `InstValid;	
				end		
			`EXE_PREF:			begin
		  		des_exist_out <= `WriteDisable;		aluop_out <= `EXE_NOP_OP;
		  		alusel_out <= `EXE_RES_NOP; reg1_read_out <= 1'b0;	reg2_read_out <= 1'b0;	  	  	
					instvalid <= `InstValid;	
				end										  	
		    default:			begin
		    end
		  endcase		  //case op
		  
		  if (inst_in[31:21] == 11'b00000000000) begin
		  	if (op3 == `EXE_SLL) begin
		  		des_exist_out <= `WriteEnable;		aluop_out <= `EXE_SLL_OP;
		  		alusel_out <= `EXE_RES_SHIFT; reg1_read_out <= 1'b0;	reg2_read_out <= 1'b1;	  	
				imm[4:0] <= inst_in[10:6];		des_addr_out <= inst_in[15:11];
					instvalid <= `InstValid;	
			end else if ( op3 == `EXE_SRL ) begin
		  		des_exist_out <= `WriteEnable;		aluop_out <= `EXE_SRL_OP;
		  		alusel_out <= `EXE_RES_SHIFT; reg1_read_out <= 1'b0;	reg2_read_out <= 1'b1;	  	
				imm[4:0] <= inst_in[10:6];		des_addr_out <= inst_in[15:11];
					instvalid <= `InstValid;	
			end else if ( op3 == `EXE_SRA ) begin
		  		des_exist_out <= `WriteEnable;		aluop_out <= `EXE_SRA_OP;
		  		alusel_out <= `EXE_RES_SHIFT; reg1_read_out <= 1'b0;	reg2_read_out <= 1'b1;	  	
				imm[4:0] <= inst_in[10:6];		des_addr_out <= inst_in[15:11];
					instvalid <= `InstValid;	
				end
			end		  
		  
		end       //if
	end         //always
	

	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_data_out <= `ZeroWord;		
		end else if((reg1_read_out == 1'b1) && (ex_des_exist_in == 1'b1) && (ex_des_addr_in == reg1_addr_out)) begin
			reg1_data_out <= ex_des_data_in; 
		end else if((reg1_read_out == 1'b1) && (mem_des_exist_in == 1'b1) && (mem_des_addr_in == reg1_addr_out)) begin
			reg1_data_out <= mem_des_data_in; 			
		end else if(reg1_read_out == 1'b1) begin
	  		reg1_data_out <= reg1_data_in;
		end else if(reg1_read_out == 1'b0) begin
	  		reg1_data_out <= imm;
	  	end else begin
	    		reg1_data_out <= `ZeroWord;
	  end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_data_out <= `ZeroWord;		
		end else if((reg2_read_out == 1'b1) && (ex_des_exist_in == 1'b1) && (ex_des_addr_in == reg2_addr_out)) begin
			reg2_data_out <= ex_des_data_in; 
		end else if((reg2_read_out == 1'b1) && (mem_des_exist_in == 1'b1) && (mem_des_addr_in == reg2_addr_out)) begin
			reg2_data_out <= mem_des_data_in; 			
		end else if(reg2_read_out == 1'b1) begin
	  		reg2_data_out <= reg1_data_in;
		end else if(reg2_read_out == 1'b0) begin
	  		reg2_data_out <= imm;
	  	end else begin
	    		reg2_data_out <= `ZeroWord;
	  end
	end

endmodule
