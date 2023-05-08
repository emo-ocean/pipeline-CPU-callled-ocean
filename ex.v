`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 11:40:34
// Design Name: 
// Module Name: ex
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


module ex(
	input wire rst,
	//from id to ex
	input wire[`alu_op_bus] ex_alu_op_in,
	input wire[`alu_sel_bus] ex_alu_sel_in,
	input wire[`reg_bus] ex_src1_in,
	input wire[`reg_bus] ex_src2_in,
	input wire[`reg_addr_bus] ex_des_addr_in,
	input wire ex_des_exist_in,
	//ex stage's result
	output reg[`reg_addr_bus] ex_des_addr_out,
	output reg ex_des_exist_out,
	output reg[`reg_bus] ex_des_data_out
);
//store result of various algorithm
reg[`reg_bus] logic_result;
reg[`reg_bus] shift_result;

//1.according to alu_op_in
always@(*)begin
if (rst == `rst_enable)begin
	logic_result <= `zero_word;
	end else begin

	case(ex_alu_op_in)

	`exe_or_op: begin
	logic_result <= ex_src1_in | ex_src2_in;
	end
	
	`exe_and_op: begin
	logic_result <= ex_src1_in & ex_src2_in;
	end
	
	`exe_nor_op: begin
	logic_result <= ~(ex_src1_in | ex_src2_in);
	end
	
	`exe_xor_op: begin
	logic_result <= ex_src1_in ^ ex_src2_in;
	end

	default: begin
	logic_result <= `zero_word;
	end

	endcase
	end //if
	end //always


always@(*)begin
if (rst == `rst_enable)begin
	shift_result <= `zero_word;
	end else begin
	
	case(ex_alu_op_in)

	`exe_sll_op: begin//logic shift
	shift_result<=ex_src2_in<<ex_src1_in[4:0];
	end
	
	`exe_srl_op: begin//logic shift
	shift_result<=ex_src2_in>>ex_src1_in[4:0];
	end
	
	`exe_sra_op: begin//logic shift
	shift_result<= ({32{ex_src2_in[31]}}<<(6'd32-{1'b0,ex_src1_in[4:0]})) | ex_src2_in<<ex_src1_in[4:0];
	end
	
	default: begin
	shift_result <= `zero_word;
	end

	endcase
	end //if
	end //always
	


	//2.accoring to alu_sel to choose final result
	always@(*)begin
	ex_des_addr_out <= ex_des_addr_in;
	ex_des_exist_out <= ex_des_exist_in;

	case(ex_alu_sel_in)

		`exe_res_logic:		begin
			ex_des_data_out <= logic_result;
		end


        	`exe_res_shift:		begin
            		ex_des_data_out<=shift_result;
        	end

		
		default:	begin
			ex_des_data_out <= `zero_word;
		end

	endcase
	end

endmodule
