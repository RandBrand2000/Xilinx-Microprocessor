`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 08:34:51 AM
// Design Name: 
// Module Name: EX_module
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


module EX_module(
    input  wire [15:0] inst,        //The 16-bit instrucction being loaded from BRAM
           wire clk,                //Clock signal
           wire rst,
           wire start,
           wire [11:0] nextPC,
    output  reg [11:0] address,
            reg [7:0]   opResult
    );
    
    reg [7:0] RegFile [15:0];    //Declaration of the RegFile that is 16regs x 8bit
    reg [12:0] stack   [7:0];    //stack 8 deep
    reg sPointer = 3'b000;       //Stack Pointer
    reg wea = 0;                //Write enable
    reg writeFlg = 0;               //Write flg
    
    wire [7:0] ALUout;          //ALU output
    wire [7:0] SRUout;          //SRU output
    wire [7:0] MEMout;          //Byte read from BRAM memory
    
    ALU instALU(
        .A(RegFile[inst[7:4]]),
        .B(RegFile[inst[3:0]]),
        .opc(inst[13:12]),
        .out(ALUout)
    );
    
    SRU instSRU(
        .A(RegFile[inst[7:4]]),
        .opc(inst[13:12]),
        .out(SRUout)
    );
    
  blk_mem_gen_1 BRAM (
    .clka(clk), 
    .wea(wea), 
    .addra(RegFile[inst[7:4]]), 
    .dina(RegFile[inst[11:8]]), 
    .clkb(clk), 
    .addrb(RegFile[inst[7:4]]), 
    .doutb(MEMout)
  );
        
    integer i;    
    initial begin
        opResult = 0;
        address = 0;
       for (i = 0; i < 16; i = i + 1)begin  //initializes of RegFile values to 0. 
            RegFile[i] = 0;
        end     //end for loop
    end //end initial
    
    always @(posedge rst) begin
        opResult = 0;
       for (i = 0; i < 16; i = i + 1)begin 
            RegFile[i] = 0;
        end     //end for loop 
    end //end initial
    
    always @(posedge clk) begin
        if(inst[15:12] != 4'b1101) wea <=0;  
    end
        
    always @ (posedge clk) begin
    /*********************************************
                    Memory
   *********************************************/     
        if(inst[15:14] == 2'b11) begin 
             case(inst[13:12])
                2'b00 : RegFile[inst[11:8]] <= MEMout; //MEMR
                2'b01 : begin   //MEMW 
                   wea = 1;
                end //end 2'b01    
                2'b10 : begin   //LDI 
                   RegFile[inst[11:8]] <= inst[7:0]; 
                   opResult <= inst[7:0];
                end //end 2'b10 
             endcase
        end//end if
        
        /************************************
                        ALU
        ************************************/             
        if(inst[15:14] == 2'b00)begin           
                RegFile[inst[11:8]] = ALUout;
                opResult <= ALUout;
        end//end if
        
        /************************************
                        SRU
        *************************************/                 
        if(inst[15:14] == 2'b01)begin
                RegFile[inst[11:8]] = SRUout;
                opResult <= SRUout;
        end//end if
        
        
    end//end always
    
   /**********************************************************
                    Address Resolution
   This always block decides the next to be sent to the PC. 
   It also deals with any of the jump instructions. 
   **********************************************************/
    always @ (posedge clk or posedge start or posedge rst) begin
        if(start)
            address = 3;
            
        else if(rst)
            address = 0; 
    
        else begin
            case(inst[15:12])
                4'b1000 : begin  //JMPC
                    if(RegFile[inst[7:4]] == 0) begin
                        address <= RegFile[inst[11:8]];
                        opResult <= RegFile[inst[11:8]];
                    end //if
                    else begin
                        address <= nextPC;
                        opResult <= nextPC;
                     end
                end //end 4'b1000
                
                4'b1001 : begin
                    address <= inst[11:0];    //JMPD
                    opResult <= inst[7:0];
                end //end 4'b1001 
                
                4'b1010 : begin     //JMPS
                    stack[sPointer] <= nextPC;
                    sPointer <= sPointer + 1;
                    address <= RegFile[inst[11:8]];
                    opResult <= RegFile[inst[11:8]];
                end //end 4'b1010
                
                4'b1011 :   begin            //JMP
                    sPointer <= sPointer - 1;
                    address <= stack[sPointer];
                    opResult <= stack[sPointer];
                end  //end 4'b1011  
                
                4'b1101 : begin             //MEMW
                    if(writeFlg == 0)begin
                        address <= nextPC-1;
                        writeFlg <= 1;
                    end     //end if
                    else    address <= nextPC; 
                 end //end 4'b1101
                        
                default : address <= nextPC;
            endcase
        end //end else     
    end // end awasy
endmodule
