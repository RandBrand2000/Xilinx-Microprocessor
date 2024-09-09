`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 05:00:18 PM
// Design Name: 
// Module Name: IF_module
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


module IF_module(
    input   clk,                //Clock signal
            rst,                //reset
            [11:0]address,      //address of next instruction
            start,              //start signal
    output reg [11:0] nextPC,   //The next PC being propogated through the system
            wire [15:0] inst     //The instruction that will be passed forward
    );
    
    blk_mem_gen_0 inst_mem(
        .clka(clk),
        .addra(address),
        .douta(inst)
    );
    
    always@(posedge clk) begin 
            if(rst)
                nextPC = 1;
                
            else if(start)
                nextPC = 4;
            
            else
                nextPC = address + 1;
    end

endmodule
