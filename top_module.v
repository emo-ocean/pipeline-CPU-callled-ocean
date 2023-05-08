`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 20:44:29
// Design Name: 
// Module Name: top_module
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


module top_module(
	input wire clk,
	input wire rst,

	input wire[`reg_bus] rom_data_in,
	output wire[`reg_bus] rom_addr_out,
	output wire rom_en_out
);
//link if_id and id
wire[`inst_addr_bus] pc;
wire[`inst_addr_bus] id_pc_in;
wire[`inst_bus] id_inst_in;

//link id and id/exe
wire[`alu_op_bus] id_alu_op_out;
wire[`alu_sel_bus] id_alu_sel_out;
wire[`reg_bus] id_src1_out;
wire[`reg_bus] id_src2_out;
wire id_des_exist_out;
wire[`reg_addr_bus] id_des_addr_out;

//link id/ex and ex
wire[`alu_op_bus] ex_alu_op_in;
wire[`alu_sel_bus] ex_alu_sel_in;
wire[`reg_bus] ex_src1_in;
wire[`reg_bus] ex_src2_in;
wire ex_des_exist_in;
wire[`reg_addr_bus] ex_des_addr_in;

//link ex and ex/mem
wire ex_des_exist_out;
wire[`reg_addr_bus] ex_des_addr_out;
wire[`reg_bus] ex_des_data_out;

//link ex/mem and mem
wire mem_des_exist_in;
wire[`reg_addr_bus] mem_des_addr_in;
wire[`reg_bus] mem_des_data_in;

//link mem and mem/wb
wire mem_des_exist_out;
wire[`reg_addr_bus] mem_des_addr_out;
wire[`reg_bus] mem_des_data_out;

//link mem/wb and wb
wire wb_des_exist_in;
wire[`reg_addr_bus] wb_des_addr_in;
wire[`reg_bus] wb_des_data_in;

//link id and regfile   ***
wire src1_read_en;
wire src2_read_en;
wire[`reg_addr_bus] src1_addr;
wire[`reg_addr_bus] src2_addr;
wire[`reg_bus] src1_data;
wire[`reg_bus] src2_data;



//pc_reg instance
pc_reg pc_reg_instance(
	.clk(clk),	.rst(rst),	.pc(pc),
	.inst_mem_en(rom_en_out)
);

assign rom_addr_out = pc;

//if_id instance
if_id if_id_instance(
	.clk(clk), .rst(rst), .if_pc(pc),
	.if_inst(rom_data_in), .id_pc(id_pc_in),
	.id_inst(id_inst_in)
);

//id stage instance
id id_instance(
    .rst(rst),
	 .pc_de(id_pc_in), .inst_de(id_inst_in),
	//input from regfile
	.reg_id_data1(src1_data), .reg_id_data2(src2_data),
	
	//raw problem input
	.ex_des_exist_in(ex_des_exist_out),
	.ex_des_addr_in(ex_des_addr_out),.ex_des_data_in(ex_des_data_out),
	.mem_des_exist_in(mem_des_exist_out),
	.mem_des_addr_in(mem_des_addr_out),.mem_des_data_in(mem_des_data_out),
	
	//infor pass to regdile
	.id_reg_re1(src1_read_en), .id_reg_re2(src2_read_en),
	.id_reg_ra1(src1_addr), .id_reg_ra2(src2_addr),
	//info pass to id/ex
	.alu_op(id_alu_op_out), .alu_sel(id_alu_sel_out),
	.id_src1(id_src1_out), .id_src2(id_src2_out),
	.id_des_addr(id_des_addr_out),
	.id_des_exist(id_des_exist_out)
);

//regfile instance
regfile regfile_instance(
	.clk(clk), .rst(rst),
	.write_en(wb_des_exist_in), .write_reg_addr(wb_des_addr_in),
	.write_data(wb_des_data_in),
	.read_en_first(src1_read_en),
	.read_reg_addr_first(src1_addr), .read_out_data_first(src1_data),
	.read_en_second(src2_read_en),
	.read_reg_addr_second(src2_addr), .read_out_data_second(src2_data)
	);


//id/ex instance
id_ex id_ex_instance(
	.clk(clk), .rst(rst),
	//pass from id
	.ie_alu_op(id_alu_op_out), .ie_alu_sel(id_alu_sel_out),
	.ie_src1(id_src1_out), .ie_src2(id_src2_out),
	.ie_des_addr(id_des_addr_out), .ie_des_exist(id_des_exist_out),
	//pass to ex
	.ex_alu_op(ex_alu_op_in), .ex_alu_sel(ex_alu_sel_in),
	.ex_src1(ex_src1_in), .ex_src2(ex_src2_in),
	.ex_des_addr(ex_des_addr_in), .ex_des_exist(ex_des_exist_in)
);

//ex instance
ex ex_instance(
	.rst(rst),
	//pass from id/ex
	.ex_alu_op_in(ex_alu_op_in), .ex_alu_sel_in(ex_alu_sel_in),
	.ex_src1_in(ex_src1_in), .ex_src2_in(ex_src2_in),
	.ex_des_addr_in(ex_des_addr_in), .ex_des_exist_in(ex_des_exist_in),
	//pass to ex/mem
	.ex_des_addr_out(ex_des_addr_out), .ex_des_exist_out(ex_des_exist_out),
	.ex_des_data_out(ex_des_data_out)
);

//  ex/mem instance 
ex_mem ex_mem_instance(
	.clk(clk), .rst(rst),
	//from ex
	.em_des_addr(ex_des_addr_out), .em_des_exist(ex_des_exist_out),
	.em_des_data(ex_des_data_out),
	//to mem
	.mem_des_addr(mem_des_addr_in), .mem_des_exist(mem_des_exist_in),
	.mem_des_data(mem_des_data_in)
);

//mem instance
mem mem_instance(
	.rst(rst),
	//from ex/mem
	.mem_des_addr_in(mem_des_addr_in), .mem_des_exist_in(mem_des_exist_in),
	.mem_des_data_in(mem_des_data_in),
	//to mem/wb
	.mem_des_addr_out(mem_des_addr_out), .mem_des_exist_out(mem_des_exist_out),
	.mem_des_data_out(mem_des_data_out)
);

//mem/wb instance
mem_wb mem_wb_instance(
	.clk(clk), .rst(rst),
	//from mem
	.mw_des_addr(mem_des_addr_out), .mw_des_exist(mem_des_exist_out),
	.mw_des_data(mem_des_data_out),
	//to wb
	.wb_des_addr(wb_des_addr_in), .wb_des_exist(wb_des_exist_in),
	.wb_des_data(wb_des_data_in)
);

endmodule
