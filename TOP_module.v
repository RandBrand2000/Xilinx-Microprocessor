`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 09:40:50 AM
// Design Name: 
// Module Name: TOP_module
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


module TOP_module(
    input   clk,                //Clock signal
            rst,                //Reset signal
            start,              //Start signal
    output wire [11:0] opResult  //Operation result - For testing purposes
    );
    
    wire [11:0]address; //Loops the resulting address to the PC
    wire [11:0]nextPC;  //The incremented PC passed from IF to EX
    wire [15:0]inst;    //The instruction associated with the current PC
    
    /*********************************************************
                           EX_module
    Takes the instruction and the incremented PC. Does any 
    computaions and decides the next PC value based on the
    instruction passed to it.                 
    **********************************************************/
    EX_module EXinst(
        //inputs
        .inst(inst),    
        .clk(clk),            
        .rst(rst),
        .start(start),
        .nextPC(nextPC),
        //outputs
        .address(address),
        .opResult(opResult)
    );
    
    /*********************************************************
                           IF_module
    Increments the current PC and retrieves the instruction from
    memory based on the current PC.                 
    **********************************************************/
    IF_module IFinst(
        //inputs
        .clk(clk),
        .rst(rst),
        .start(start),
        .address(address),
        //outputs
        .nextPC(nextPC),
        .inst(inst)
    );

endmodule
