//****************************************Copyright (c)***********************************//
// Copyright(C)            Wenchao Yu
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/05 14:28:29
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/05 14:28:29
// mail      :             wenchao.yu@rwth-aachen.de
// Version:                V1.0
// TEXT NAME:              Control_Unit.v
// PATH:                   Pipeline_CPU_RISC-V/Control_Unit.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Control_Unit(

                             opcode                         ,   // 7-bit opcode
                             funct3                      ,   // 3-bit function code
                             funct7_5                    ,   // the fifth bit of function7 code
                             RegWriteD                   ,   // Register Write
                             ResultSrcD                  ,   // Result Source
                             MemWriteD                   ,   // Memory Write
                             JumpD                       ,   // Jump
                             BranchD                     ,   // Branch
                             ALUControlD                 ,   // ALU Control
                             ALUSrcD                     ,   // ALU Source
                             ImmSrcD                         // Immediate Source    
    );

input [6:0] opcode;
input [2:0] funct3;
input funct7_5;

output wire         RegWriteD;
output wire [1:0]   ResultSrcD;    
output wire         MemWriteD;
output wire         JumpD;
output wire         BranchD;
output wire [2:0]   ALUControlD;
output wire         ALUSrcD;
output wire [1:0]   ImmSrcD;

//********************************************************************************************************************
//  7-bit opcode is the part of instrction code  : Instr[6:0]
//  3-bit function code is the part of instrction code  : Instr[14:12]
//  1-bit function7 code is the part of instrction code  : Instr[30] 




wire [1:0] ALUop;
// Main_Decoder and ALU_Decoder  used in Control_Unit

Main_Decoder Main_Decoder_init(
    .op(opcode),
    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUSrcD(ALUSrcD),
    .ImmSrcD(ImmSrcD),
    .ALUOp(ALUop)
);

ALU_Decoder ALU_Decoder_init(
    .op_5(opcode[5]),
    .funct3(funct3),
    .funct7_5(funct7_5),
    .ALUop(ALUop),
    .ALUControl(ALUControlD)
);


endmodule
                                                  