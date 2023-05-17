//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 			                          ////
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
// Module:  openmips
// File:    openmips.v
// Author:  yuzehai
// Description: OpenMIPS top
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module top_module(

	input	wire			clk,
	input wire			rst,
	
 
	input wire[`RegBus]           rom_data_in,
	output wire[`RegBus]           rom_addr_out,
	output wire                    rom_ce_out
	
);
	//if and if_id/
	wire[`InstAddrBus] pc;
	wire[`InstAddrBus] id_pc_in;
	wire[`InstBus] id_inst_in;
	
	//连接译码阶段ID模块的输出与ID/EX模块的输入/
	wire[`AluOpBus] id_aluop_out;
	wire[`AluSelBus] id_alusel_out;
	wire[`RegBus] id_reg1_out;
	wire[`RegBus] id_reg2_out;
	wire id_des_exist_out;
	wire[`RegAddrBus] id_des_addr_out;
	
	//连接ID/EX模块的输出与执行阶段EX模块的输入/
	wire[`AluOpBus] ex_aluop_in;
	wire[`AluSelBus] ex_alusel_in;
	wire[`RegBus] ex_reg1_in;
	wire[`RegBus] ex_reg2_in;
	wire ex_des_exist_in;
	wire[`RegAddrBus] ex_des_addr_in;
	
	//连接执行阶段EX模块的输出与EX/MEM模块的输入/
	wire ex_des_exist_out;
	wire[`RegAddrBus] ex_des_addr_out;
	wire[`RegBus] ex_des_data_out;

	//连接EX/MEM模块的输出与访存阶段MEM模块的输入/
	wire mem_des_exist_in;
	wire[`RegAddrBus] mem_des_addr_in;
	wire[`RegBus] mem_des_data_in;

	//连接访存阶段MEM模块的输出与MEM/WB模块的输入/
	wire mem_des_exist_out;
	wire[`RegAddrBus] mem_des_addr_out;
	wire[`RegBus] mem_des_data_out;
	
	//连接MEM/WB模块的输出与回写阶段的输入/	
	wire wb_des_exist_in;
	wire[`RegAddrBus] wb_des_addr_in;
	wire[`RegBus] wb_des_data_in;
	
	//连接译码阶段ID模块与通用寄存器Regfile模块
  	wire reg1_read;
  	wire reg2_read;
 	wire[`RegBus] reg1_data;
 	wire[`RegBus] reg2_data;
	wire[`RegAddrBus] reg1_addr;
  	wire[`RegAddrBus] reg2_addr;
  
  	//pc_reg module/
	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
		.pc(pc),
		.ce(rom_ce_out)		
			
	);
	
  assign rom_addr_out = pc;

  	//if_id module/
	if_id if_id0(
		.clk(clk),
		.rst(rst),
		.if_pc(pc),
		.if_inst(rom_data_in),
		.id_pc(id_pc_in),
		.id_inst(id_inst_in)      	
	);
	
	//id module
	id id0(
		//         /
		.rst(rst),
		.pc_in(id_pc_in),
		.inst_in(id_inst_in),

		.reg1_data_in(reg1_data),
		.reg2_data_in(reg2_data),

		//from ex to id(raw)/
		.ex_des_exist_in(ex_des_exist_out),
		.ex_des_data_in(ex_des_data_out),
		.ex_des_addr_in(ex_des_addr_out),

		//from mem to id (raw)
		.mem_des_exist_in(mem_des_exist_out),
		.mem_des_data_in(mem_des_data_out),
		.mem_des_addr_in(mem_des_addr_out),

		//pass to regfile
		.reg1_read_out(reg1_read),
		.reg2_read_out(reg2_read), 	  

		.reg1_addr_out(reg1_addr),
		.reg2_addr_out(reg2_addr), 
	  
		//pass to id_ex stage/
		.aluop_out(id_aluop_out),
		.alusel_out(id_alusel_out),
		.reg1_data_out(id_reg1_out),
		.reg2_data_out(id_reg2_out),
		.des_addr_out(id_des_addr_out),
		.des_exist_out(id_des_exist_out)
	);

  	//renfile module
	regfile regfile1(
		.clk (clk),
		.rst (rst),
		.we	(wb_des_exist_in),
		.waddr (wb_des_addr_in),
		.wdata (wb_des_data_in),
		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),
		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data)
	);

	//id_ex module
	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		
		//from id
		.id_aluop(id_aluop_out),
		.id_alusel(id_alusel_out),
		.id_reg1(id_reg1_out),
		.id_reg2(id_reg2_out),
		.id_des_addr(id_des_addr_out),
		.id_des_exist(id_des_exist_out),
	
		//pass to ex
		.ex_aluop(ex_aluop_in),
		.ex_alusel(ex_alusel_in),
		.ex_reg1(ex_reg1_in),
		.ex_reg2(ex_reg2_in),
		.ex_des_addr(ex_des_addr_in),
		.ex_des_exist(ex_des_exist_in)
	);		
	
	//EX module
	ex ex0(
		.rst(rst),
	
		//from id to ex/
		.aluop_in(ex_aluop_in),
		.alusel_in(ex_alusel_in),
		.reg1_data_in(ex_reg1_in),
		.reg2_data_in(ex_reg2_in),
		.des_addr_in(ex_des_addr_in),
		.des_exist_in(ex_des_exist_in),
	  
	  	//ex result/
		.des_addr_out(ex_des_addr_out),
		.des_exist_out(ex_des_exist_out),
		.des_data_out(ex_des_data_out)
		
	);

  	//ex_mem module
  	ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
	  
		//from ex
		.ex_des_addr(ex_des_addr_out),
		.ex_des_exist(ex_des_exist_out),
		.ex_des_data(ex_des_data_out),
	
		//pass to mem
		.mem_des_addr(mem_des_addr_in),
		.mem_des_exist(mem_des_exist_in),
		.mem_des_data(mem_des_data_in)					       	
	);
	
  	//mem module
	mem mem0(
		.rst(rst),
	
		//来自EX/MEM模块的信息	
		.des_addr_in(mem_des_addr_in),
		.des_exist_in(mem_des_exist_in),
		.des_data_in(mem_des_data_in),
	  
		//送到MEM/WB模块的信息
		.des_addr_out(mem_des_addr_out),
		.des_exist_out(mem_des_exist_out),
		.des_data_out(mem_des_data_out)
	);

  	//MEM/WB module
	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),

		//来自访存阶段MEM模块的信息	
		.mem_des_addr(mem_des_addr_out),
		.mem_des_exist(mem_des_exist_out),
		.mem_des_data(mem_des_data_out),
	
		//送到回写阶段的信息
		.wb_des_addr(wb_des_addr_in),
		.wb_des_exist(wb_des_exist_in),
		.wb_des_data(wb_des_data_in)
									       	
	);

endmodule
