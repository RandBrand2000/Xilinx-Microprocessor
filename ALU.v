`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2024 08:57:45 AM
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [7:0] A, [7:0] B,     //These are the ALU input values
    input [1:0] opc,            //This is the op code that is 2 bits wide
    output reg [7:0]out         //Module output 
    );
    
    always @*  begin //Combinational Logic
        case(opc)      
            2'b00: out = ~(A&B);    //NAND  
            2'b01: out = ~(A|B);    //NOR
            2'b10: out = A^B;       //XOR
            2'b11: out = A+B;       //ADD
        endcase //endcase(opc)        
    end // end always @*
endmodule
