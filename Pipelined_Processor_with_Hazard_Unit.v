//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/15 12:58:24
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/15 12:58:24
// mail      :             wenchao.yu@rwth-aachen.de
// Version:                V1.0
// TEXT NAME:              Pipelined_Processor_with_Hazard_Unit.v
// PATH:                   Pipeline_CPU_RISC-V/Pipelined_Processor_with_Hazard_Unit.v
// Descriptions:          
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Pipelined_Processor_with_Hazard_Unit(
    //input Signals
                              clk                        ,
                              rst_n                      ,

    //output Signals
                              PCF_out                    ,
                              InstrD_out                 ,  
                              ALUResultE_out             ,
                              ReadDataW_out              ,
                              ALUResultW_out             ,
                              StallF_out                 
    );
                                                                   
input clk, rst_n;
output [31:0] PCF_out;
output [31:0] InstrD_out;
output [31:0] ALUResultE_out;
output [31:0] ReadDataW_out;
output [31:0] ALUResultW_out;
output StallF_out;


wire [31:0]  InstrD, ALUResultE, ReadDataW, ALUResultW, ResultW;
wire StallD, FlushD, FlushE;    
wire StallF, PCSrcE;
wire [31:0] PCD, PCPlus4D, PCTargetE;


//Hazard Unit 
wire  RegWriteM, RegWriteW, ResultSrcE_0;
wire [1:0]  ForwardAE, ForwardBE;
wire [4:0]  RdM, Rs1E, Rs2E, Rs1D, Rs2D, RdE, RdW;



wire validD;
//instruction_fetch
instruction_fetch IF(
    .clk(clk),
    .rst_n(rst_n),
    .validD(validD),
    .PCD(PCD),
    .InstrD(InstrD),
    .StallF(StallF),
    .StallD(StallD),
    .FlushD(FlushD),
    .PCPlus4D(PCPlus4D),
    .PCTargetE(PCTargetE),
    .PCSrcE(PCSrcE)

);

assign PCF_out = PCD;
assign InstrD_out = InstrD;
//instruction_decode
wire [31:0] RD1E, RD2E, ExtImmE, PCPlus4E, PCE;
wire RegWriteE,  ALUSrcE, BranchE, MemWriteE, JumpE;
wire [1:0] ResultSrcE;
wire [2:0] ALUControlE;



Instruction_decode ID(
    .clk(clk),
    .rst_n(rst_n),
    .InstrD(InstrD),
    .A3(RdW),
    .WD3(ResultW),
    .FlushE(FlushE),
    .WE3(RegWriteW),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .RegWriteE(RegWriteE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .BranchE(BranchE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),
    .JumpE(JumpE),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .PCE(PCE),
    .RdE(RdE),
    .ExtImmE(ExtImmE),
    .PCPlus4E(PCPlus4E),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D)
);

//execute
wire [31:0] ALUResultM;
assign ALUResultM = ALUResultE;
wire [31:0] WriteDataM, PCPlus4M;

wire [1:0]  ResultSrcM;
wire MemWriteM;


Execute EX_inst(
    .clk(clk),
    .rst_n(rst_n),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .RegWriteE(RegWriteE),
    .BranchE(BranchE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),
    .JumpE(JumpE),
    .ExtImmE(ExtImmE),
    .PCPlus4E(PCPlus4E),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .PCE(PCE),
    .RdE(RdE),
    .ALUResultM_in(ALUResultM),
    .ResultW(ResultW),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM),
    .PCSrcE(PCSrcE),
    .PCPlus4M(PCPlus4M),
    .WriteDataM(WriteDataM),
    .ALUResultM(ALUResultE),
    .RdM(RdM),
    .PCTargetE(PCTargetE),
    .ResultSrcE_0(ResultSrcE_0)
);

//memory_write

wire [31:0] PCPlus4W;
wire [1:0] ResultSrcW;


MemoryWrite MW(
    .clk(clk),
    .rst_n(rst_n),
    .ResultSrcM(ResultSrcM),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .WriteDataM(WriteDataM),
    .ALUResultM(ALUResultM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),
    .ALUResulW(ALUResultW),
    .RdW(RdW),
    .ReadDataW(ReadDataW),
    .PCPlus4W(PCPlus4W)
);


//writeback
Writeback WB(
    .ReadDataW(ReadDataW),
    .ResultSrcW(ResultSrcW),
    .ALUResulW(ALUResultW),
    .PCPlus4W(PCPlus4W),
    .ResultW(ResultW)
);

//Hazards Unit
Hazard_Unit Hazard_Unit_inst(
    .validD(validD),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdE(RdE),
    .RdM(RdM),
    .RdW(RdW),
    .PCSrcE(PCSrcE),
    .RegWriteW(RegWriteW),
    .RegWriteM(RegWriteM),
    .ResultSrcE_0(ResultSrcE_0),
    .StallD(StallD),
    .FlushD(FlushD),
    .StallF(StallF),
    .FlushE(FlushE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)
);



assign ALUResultE_out = ALUResultM;
assign ReadDataW_out = ReadDataW;
assign ALUResultW_out = ALUResultW;
assign StallF_out = StallF;

                                                                   
endmodule