`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 10:27:05
// Design Name: 
// Module Name: id
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


module id(
	input wire rst,
	input wire[`inst_addr_bus] pc_de,
	input wire[`inst_bus] inst_de,

	//from regfile to id
	input wire[`reg_bus] reg_id_data1,
	input wire[`reg_bus] reg_id_data2,

	//raw data problem ex
	input wire ex_des_exist_in,
	input wire[`reg_bus] ex_des_data_in,
	input wire[`reg_addr_bus] ex_des_addr_in,

	//raw data problem mem
	input wire mem_des_exist_in,
	input wire[`reg_bus] mem_des_data_in,
	input wire[`reg_addr_bus] mem_des_addr_in,

	//from id to regfile
	output reg id_reg_re1,
	output reg id_reg_re2,
	output reg[`reg_addr_bus] id_reg_ra1,
	output reg[`reg_addr_bus] id_reg_ra2,

	//information pass to exe satge
	output reg[`alu_op_bus] alu_op,
	output reg[`alu_sel_bus] alu_sel,
	output reg[`reg_bus] id_src1,
	output reg[`reg_bus] id_src2,
	output reg[`reg_addr_bus] id_des_addr,
	output reg id_des_exist
);

wire[5:0] op1 = inst_de[31:26];
wire[4:0] sha2 = inst_de[10:6];
wire[5:0] fun3 = inst_de[5:0];
wire[4:0] rt4 = inst_de[20:16];

reg[`reg_bus] imm;

reg inst_valid;

//1. decode instruction
always@(*)begin
if (rst == `rst_enable)begin
	alu_op <= `exe_nop_op;
	alu_sel <= `exe_res_nop;
	id_des_addr <= `nop_reg_addr;
	id_des_exist <= `write_disable;
	inst_valid <= `inst_valid;
	id_reg_re1 <= 1'b0;
	id_reg_re2 <= 1'b0;
	id_reg_ra1 <= `nop_reg_addr;
	id_reg_ra2 <= `nop_reg_addr;
	imm <= 32'h0;
	end else begin
	alu_op <= `exe_nop_op;
	alu_sel <= `exe_res_nop;
	id_des_addr <= inst_de[15:11];
id_des_exist <= `write_disable;
inst_valid <= `inst_valid;
id_reg_re1 <= 1'b0;
id_reg_re2 <= 1'b0;
id_reg_ra1 <= inst_de[25:21];
id_reg_ra2 <= inst_de[20:16];
imm <= `zero_word;

case(op1)
`exe_special_inst:begin
    case(sha2)
    5'b00000: begin
        case(fun3)
        
        `exe_or:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_or_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        `exe_and:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_and_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        `exe_xor:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_xor_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        `exe_nor:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_nor_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        `exe_sllv:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_sll_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        `exe_srlv:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_srl_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        `exe_srav:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_sra_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        `exe_sync: begin
        id_des_exist <= `write_disable;
        alu_op <= `exe_nop_op;
        alu_sel <= `exe_res_nop;
        id_reg_re1 <= 1'b0;
        id_reg_re2 <= 1'b1;
        inst_valid <= `inst_valid;
        end
        
        default:begin
        end 
        
        endcase
       end   
        
       default:begin
       end
       
       endcase 
      end
                
        `exe_ori: begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_or_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b0;
        imm <= {16'h0,inst_de[15:0]};
        id_des_addr <= inst_de[20:16];
        inst_valid <= `inst_valid;
        end
    
        `exe_andi:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_and_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b0;
        imm <= {16'h0,inst_de[15:0]};
        id_des_addr <= inst_de[20:16];
        inst_valid <= `inst_valid;
        end
        
        `exe_xori:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_xor_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b0;
        imm <= {16'h0,inst_de[15:0]};
        id_des_addr <= inst_de[20:16];
        inst_valid <= `inst_valid;
        end
        
        `exe_lui:begin
        id_des_exist <= `write_enable;
        alu_op <= `exe_or_op;
        alu_sel <= `exe_res_logic;//logic algorithm
        id_reg_re1 <= 1'b1;
        id_reg_re2 <= 1'b0;
        imm <= {inst_de[15:0],16'h0};
        id_des_addr <= inst_de[20:16];
        inst_valid <= `inst_valid;
        end
    
        `exe_pref:begin
        id_des_exist <= `write_disable;
        alu_op <= `exe_nop_op;
        alu_sel <= `exe_res_nop;//logic algorithm
        id_reg_re1 <= 1'b0;
        id_reg_re2 <= 1'b0;
        inst_valid <= `inst_valid;
        end



        default:begin
	    end
	endcase //case op1
	
	
	if(inst_de[31:21] ==  11'b00000000000)begin
	 if(fun3 == `exe_sll)begin//sll
	    id_des_exist <= `write_enable;
        alu_op <= `exe_sll_op;
        alu_sel <= `exe_res_shift;
        id_reg_re1 <= 1'b0;
        id_reg_re2 <= 1'b1;
        imm[4:0] <= inst_de[10:6];
        id_des_addr <= inst_de[15:11];
        inst_valid <= `inst_valid;
      end else if(fun3 == `exe_srl)begin//srl
        id_des_exist <= `write_enable;
        alu_op <= `exe_srl_op;
        alu_sel <= `exe_res_shift;
        id_reg_re1 <= 1'b0;
        id_reg_re2 <= 1'b1;
        imm[4:0] <= inst_de[10:6];
        id_des_addr <= inst_de[15:11];
        inst_valid <= `inst_valid;
      end else if(fun3 == `exe_sra)begin//sra
        id_des_exist <= `write_enable;
        alu_op <= `exe_sra_op;
        alu_sel <= `exe_res_shift;
        id_reg_re1 <= 1'b0;
        id_reg_re2 <= 1'b1;
        imm[4:0] <= inst_de[10:6];
        id_des_addr <= inst_de[15:11];
        inst_valid <= `inst_valid;
        end
	end
	
	end //if
	end //always

//2.rsc1
always@(*)begin
if (rst == `rst_enable)begin
	id_src1 <= `zero_word;
	end else if((id_reg_re1==1'b1)&&(ex_des_exist_in==1'b1)&&(ex_des_addr_in==id_reg_ra1))begin
	id_src1<=ex_des_data_in;
	end else if ((id_reg_re1 == 1'b1)&&(mem_des_exist_in==1'b1) && (mem_des_addr_in == id_reg_ra1))begin
	id_src1 <= mem_des_data_in;
	end else if (id_reg_re1 == 1'b1)begin
		id_src1 <= reg_id_data1;
		end else if (id_reg_re1 <= 1'b0)begin
			id_src1 <= imm;
			end else begin
			id_src1 <= `zero_word;
			end
			end

			//src2
			always@(*)begin
			if (rst == `rst_enable)begin
				id_src2 <= `zero_word;
				end else if ((id_reg_re2 == 1'b1)&&(ex_des_exist_in==1'b1) && (ex_des_addr_in == id_reg_ra2))begin
				id_src2 <= ex_des_data_in;
				end else if ((id_reg_re2 == 1'b1)&&(mem_des_exist_in==1'b1) && (mem_des_addr_in == id_reg_ra2))begin
				id_src2 <= mem_des_data_in;
				end else if (id_reg_re2 == 1'b1)begin
					id_src2 <= reg_id_data1;
					end else if (id_reg_re2 <= 1'b0)begin
						id_src2 <= imm;
						end else begin
						id_src2 <= `zero_word;
						end
						end
						endmodule