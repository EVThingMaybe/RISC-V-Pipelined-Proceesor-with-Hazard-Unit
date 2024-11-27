//****************************************Copyright (c)***********************************//
// Copyright(C)           
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/05 16:16:14
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/05 16:16:14
// mail      :              
// Version:                V1.0
// TEXT NAME:              Main_Decoder.v
// PATH:                   Pipeline_CPU_RISC-V/Main_Decoder.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Main_Decoder(
   
                             op                     ,  //Instruction Opcode 
                          RegWriteD                 ,
                          ResultSrcD                ,
                          MemWriteD                 ,
                          JumpD                     ,
                          BranchD                   ,
                          ALUSrcD                   ,
                          ALUOp                     ,
                          ImmSrcD
    );                                                    

input [6:0] op;
output reg RegWriteD;
output reg [1:0] ResultSrcD;
output reg MemWriteD;
output reg BranchD;
output reg ALUSrcD;
output reg [1:0] ImmSrcD;
output reg [1:0] ALUOp;
output reg JumpD;  //Extended Functionality:jal


/******************************Function Main_Decoder FSM****************************************************/
// Op  Instruct. |  RegWrite  |  ImmSrc  |  ALUSrc  |  MemWriteD  | ResultScrD  |  BranchD  |  ALUOp  | JumpD
// 3    lw       |    1       |    00    |    1     |     0       |     01      |    0      |   00    |  0
// 35   sw       |    0       |    01    |    1     |     1       |     xx      |    0      |   00    |  0
// 51   R-Type   |    1       |    xx    |    0     |     0       |     00      |    0      |   10    |  0
// 99   beq      |    0       |    10    |    0     |     0       |     xx      |    1      |   01    |  0                                                                   
// 19   I-Type   |    1       |    00    |    1     |     0       |     00      |    0      |   10    |  0   
//111   jal      |    1       |    11    |    x     |     0       |     10      |    0      |   xx    |  1

/******************************FSM for Main_Decoder****************************************************/
//FSM for Main_Decoder

always @(*) begin
  case(op)
    7'd3: begin
      RegWriteD = 1'b1;
      ImmSrcD = 2'b00;
      ALUSrcD = 1'b1;
      MemWriteD = 0;
      ResultSrcD = 2'b01;
      BranchD = 1'b0;
      ALUOp = 2'b00;
      JumpD = 1'b0;
    end
    7'd35: begin
      RegWriteD = 1'b0;
      ImmSrcD = 2'b01;
      ALUSrcD = 1'b1;
      MemWriteD = 1'b1;
      ResultSrcD = 2'b00;
      BranchD = 1'b0;
      ALUOp = 2'b00;
      JumpD = 1'b0;
    end
    7'd51: begin
      RegWriteD = 1'b1;
      ImmSrcD = 2'b00;
      ALUSrcD = 1'b0;
      MemWriteD = 1'b0;
      ResultSrcD = 2'b00;
      BranchD = 1'b0;
      ALUOp = 2'b10;
      JumpD = 1'b0;
    end
    7'd99: begin
      RegWriteD =1'b0;
      ImmSrcD = 2'b10;
      ALUSrcD = 1'b0;
      MemWriteD = 1'b0;
      ResultSrcD = 2'b00;
      BranchD = 1'b1;
      ALUOp = 2'b01;
      JumpD = 1'b0;
    end
    7'd19: begin
      RegWriteD = 1'b1;
      ImmSrcD = 2'b00;
      ALUSrcD = 1'b1;
      MemWriteD = 1'b0;
      ResultSrcD = 2'b00;
      BranchD = 1'b0;
      ALUOp = 2'b10;
      JumpD = 1'b0;
    end
    7'd111: begin
      RegWriteD = 1'b1;
      ImmSrcD = 2'b11;
      ALUSrcD = 1'b0;
      MemWriteD = 1'b0;
      ResultSrcD = 2'b10;
      BranchD = 1'b0;
      ALUOp = 2'b00;
      JumpD = 1'b1;
    end
    default: begin
      RegWriteD = 1'b0;
      ImmSrcD = 2'b00;
      ALUSrcD = 1'b0;
      MemWriteD = 1'b0;
      ResultSrcD = 2'b00;
      BranchD = 1'b0;
      ALUOp = 2'b00;
      JumpD = 1'b0;
    end
  endcase
end

endmodule