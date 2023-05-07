
//////////////////////////////////////////////////////////////////////////////////
// Company: NPU
// Engineer: Zehai Yu
// 
// Create Date: 2023/04/15 20:03:40
// Design Name: 
// Module Name: defines
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
//all
`define rst_enable 1'b1
`define rst_disable 1'b0
`define zero_word 32'h00000000
`define write_enable 1'b1
`define write_disable 1'b0
`define read_enable 1'b1
`define read_disabled 1'b0
`define alu_op_bus 7:0
`define alu_sel_bus 2:0
`define inst_valid 1'b0
`define inst_invalid 1'b1

`define stop 1'b1
`define no_stop 1'b0
`define in_delay_slot 1'b1
`define not_in_delay_slot 1'b0
`define branch 1'b1
`define not_branch 1'b0
`define interrupt_assert 1'b1
`define interrupt_not_assert 1'b0
`define trap_assert 1'b1
`define trap_not_assert 1'b0
`define true_v 1'b1
`define false_v 1'b0
`define chip_enable 1'b1
`define chip_disable 1'b0

//instruction
`define exe_and		6'b100100
`define exe_or		6'b100101
`define exe_xor		6'b100110
`define exe_nor		6'b100111
`define exe_andi	6'b001100
`define exe_ori		6'b001101
`define exe_xori	6'b001110
`define exe_lui		6'b001111

`define exe_sll		6'b000000
`define exe_sllv	6'b000100
`define exe_srl		6'b000010
`define exe_srlv	6'b000110
`define exe_sra		6'b000011
`define exe_srav	6'b000111

`define exe_sync	6'b001111
`define exe_pref	6'b110011

`define exe_special_inst	6'b000000
`define exe_regimm_inst 6'b000001
`define exe_special2_inst 6'b011100

`define exe_nop		6'b000000
`define ssnop 32'h00000000

//alu op
`define exe_and_op 8'b00100100
`define exe_or_op  8'b00100101
`define exe_xor_op 8'b00100110
`define exe_nor_op 8'b00100111
`define exe_andi_op 8'b01011001
`define exe_ori_op 8'b01011010
`define exe_xori_op 8'b01011011
`define exe_lui_op 8'b01011100

`define exe_sll_op 8'b01111100
`define exe_sllv_op 8'b00000100
`define exe_srl_op 8'b00000010
`define exe_srlv_op 8'b00000110
`define exe_sra_op 8'b00000011
`define exe_srav_op 8'b00000111

`define exe_nop_op 8'b00000000


//alu sel
`define exe_res_logic 3'b001
`define exe_res_shift 3'b010

`define exe_res_nop 3'b000

//rom
`define inst_addr_bus 31:0
`define inst_bus 31:0
`define inst_mem_num 131071 //rom实际大小128KB
`define inst_mem_num_log2 17 //rom实际使用地址线宽度

//regfile
`define reg_addr_bus 4:0
`define reg_bus 31:0
`define reg_width 32
`define double_reg_width 64
`define double_reg_bus 63:0
`define reg_num 32
`define reg_num_log2 5
`define nop_reg_addr 5'b00000



