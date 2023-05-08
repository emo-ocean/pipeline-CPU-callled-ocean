`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/15 21:39:36
// Design Name: 
// Module Name: if_id
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


module if_id(
    input wire rst,
    input wire clk,
    
    input wire[`inst_addr_bus] if_pc,
    input wire[`inst_bus] if_inst,
    
    output reg [`inst_addr_bus] id_pc,
    output reg [`inst_bus] id_inst
    );
    
    always@(posedge clk)begin
        if(rst==`rst_enable)begin
            id_pc<=`zero_word;
            id_inst<=`zero_word;
         end else begin
            id_pc<=if_pc;
            id_inst<=if_inst;
        end
    end
endmodule
