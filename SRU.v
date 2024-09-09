`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2024 09:25:41 AM
// Design Name: 
// Module Name: SRU
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


module SRU(
    input signed [7:0] A,              //This are the SRU input value
    input [1:0] opc,            //This is the op code that is 2 bits wide
    output reg [7:0] out        //Module output 
    );
    
    always @* begin          // combinational Logic
        case(opc)
            2'b00 : out = {A[6:0], A[7]};   // ROTL 
            2'b01 : out = {A[6:0], 1'b0};   // SLA 
            2'b10 : out = {A[7], A[7:1]};   // SRA
            2'b11 : out = {1'b0, A[7:1]};   // SRL
        endcase //endcase(opc)
    end
endmodule
