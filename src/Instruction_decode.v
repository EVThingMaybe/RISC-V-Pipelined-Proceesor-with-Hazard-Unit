`timescale 1ns / 1ps
//****************************************Copyright (c)***********************************//
// Copyright(C)            Wenchao Yu
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/05 13:28:56
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu 
// Created date:           2024/11/05 13:28:56
// mail      :              
// Version:                V1.0
// TEXT NAME:              Instruction_decode.v
// PATH:                   Pipeline_CPU_RISC-V/Instruction_decode.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Instruction_decode(

    //input Signals
                            clk                         ,
                            rst_n                       ,
                            InstrD                      ,
                            A3                          ,
                            WD3                         ,
                            FlushE                      ,
                            WE3                         ,     //Write Enable for Register 3
                            PCD                         ,     //Program Counter Decode
                            PCPlus4D                    ,     //Program Counter + 4 in Decode Stage;
                           RD1E                          ,
                           RD2E                          ,

    //Control Unit  output Signals
                           RegWriteE                    ,
                           ALUControlE                  ,
                           ALUSrcE                      ,
                           BranchE                      ,
                           MemWriteE                    ,
                           ResultSrcE                   , 

                           JumpE                        ,
    
    // Register File output Signals
                            Rs1E                         ,
                            Rs2E                         ,
    
    // Decode Stage output Signals
                          PCE                          ,
                          RdE                          ,
                          ExtImmE                      ,
                          PCPlus4E                     ,

    //Hazards Unit output Signals
                           Rs1D                         ,
                           Rs2D                         
);

input clk, rst_n, WE3, FlushE; //Clock, Reset, Write Enable for Register 3, Flush Signal;
input [31:0] InstrD; //Instruction from Memory
input [4:0] A3; //Write Address Register 3
input [31:0] WD3; //Write Data Register 3
input [31:0] PCD; //Program Counter Decode
input [31:0] PCPlus4D; //Program Counter + 4 in Decode Stage

output wire [31:0] RD1E; //Register Data 1 for Execute Stage
output wire [31:0] RD2E; //Register Data 2 for Execute Stage


output wire [4:0] Rs1D; //Read Address 1 for Hazard Unit
output wire [4:0] Rs2D; //Read Address 2 for Hazard Unit
output reg       RegWriteE; //Register Write Enable
output reg [2:0] ALUControlE; //ALU Control Signal
output reg       ALUSrcE; //ALU Source Signal
output reg       BranchE; //Branch Signal
output reg       MemWriteE; //Memory Write Signal
output reg [1:0] ResultSrcE; //Result Source Signal
output reg       JumpE; //Jump Signal

output reg [4:0] Rs1E; //Read Address 1 for Register File
output reg [4:0] Rs2E; //Read Address 2 for Register File

output reg [31:0] PCE; //Program Counter Execute
output reg [4:0]  RdE; //Write Address Register File
output reg [31:0] ExtImmE; //Extended Immediate
output reg [31:0] PCPlus4E; //Program Counter + 4


//Control Unit input and output signals
wire   [6:0]           opcode; //Opcode
wire   [14:12]         funct3; //Funct3
wire                   funct7_5; //Funct7_5
wire   [4:0]           A1; //Read Address 1
wire   [4:0]           A2; //Read Address 2
wire                   RegWriteD; //Register Write Enable
wire   [2:0]           ALUControlD; //ALU Control Signal
wire                   ALUSrcD; //ALU Source Signal
wire                   BranchD; //Branch Signal
wire                   MemWriteD; //Memory Write Signal
wire   [1:0]           ResultSrcD; //Result Source Signal
wire   [1:0]           ImmSrcD; //Immediate Source Signal
wire                   JumpD; //Jump Signal

//Hazards Unit input signals
wire   [4:0]           RdD; //Write Address

//next state signals
wire   [31:0]          ExtImm_prev; //Previous Extended Immediate

assign opcode = InstrD[6:0]; //Opcode
assign funct3 = InstrD[14:12]; //Funct3
assign funct7_5 = InstrD[30]; //Funct7_5
assign A1 = InstrD[19:15]; //Read Address 1
assign A2 = InstrD[24:20]; //Read Address 2

assign ExtImm_prev = InstrD[31:0]; //Previous Extended Immediate
assign RdD = InstrD[11:7]; //Write Address

assign Rs1D = InstrD[19:15]; //Read Address 1 for Hazard Unit
assign Rs2D = InstrD[24:20]; //Read Address 2 for Hazard Unit

//Control Unit Module

Control_Unit Control_Unit_inst(
    .opcode(opcode),
    .funct3(funct3),
    .funct7_5(funct7_5),
    .RegWriteD(RegWriteD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .BranchD(BranchD),
    .MemWriteD(MemWriteD),
    .ResultSrcD(ResultSrcD),
    .ImmSrcD(ImmSrcD),
    .JumpD(JumpD)
);


wire [31:0] RD1 ; //Register Data 1 for Read Address 1
wire [31:0] RD2 ; //Register Data 2 for Read Address 2


// Register File Module
Register_File Register_File_inst(
    .clk(clk),
    .rst_n(rst_n),
    .FlushE(FlushE),
    .Write_Enable_3(WE3),
    .Read_A1(A1),
    .Read_A2(A2),
    .Write_Adress_3(A3),
    .Write_Data_3(WD3),
    .Reg_Data_1(RD1E),
    .Reg_Data_2(RD2E)
);



// Extended Immediate Module
wire [31:0] ExtImmD; //Extended Immediate
Extend ExtImm_inst(
    .InstrD(ExtImm_prev),
    .ImmSrcD(ImmSrcD),
    .ExtImmD(ExtImmD)
);



// next state input signals
always @(posedge clk or negedge rst_n)begin                                        
        if(!rst_n)begin
            RegWriteE <= 1'b0;
            ALUControlE <= 3'b0;
            ALUSrcE <= 1'b0;
            BranchE <= 1'b0;
            MemWriteE <= 1'b0;
            ResultSrcE <= 2'b00;
            JumpE <= 1'b0;
            Rs1E <= 5'b0;
            Rs2E <= 5'b0;
            PCE <= 32'b0;
            RdE <= 5'b0;
            ExtImmE <= 32'b0;
            PCPlus4E <= 32'b0;

        end
        else begin

            if(FlushE)begin
                RegWriteE <= 1'b0;
                ALUControlE <= 3'b0;
                ALUSrcE <= 1'b0;
                BranchE <= 1'b0;
                MemWriteE <= 1'b0;
                ResultSrcE <= 2'b00;
                JumpE <= 1'b0;
                Rs1E <= 5'b0;
                Rs2E <= 5'b0;
                PCE <= 32'b0;
                RdE <= 5'b0;
                ExtImmE <= 32'b0;
                PCPlus4E <= 32'b0;
            end
            else begin
                RegWriteE <= RegWriteD;
                ALUControlE <= ALUControlD;
                ALUSrcE <= ALUSrcD;
                BranchE <= BranchD;
                MemWriteE <= MemWriteD;
                ResultSrcE <= ResultSrcD;
                JumpE <= JumpD;
                Rs1E <= Rs1D;
                Rs2E <= Rs2D;
                PCE <= PCD;
                RdE <= RdD;
                ExtImmE <= ExtImmD;
                PCPlus4E <= PCPlus4D;
            end    
        end                                  
end                                          

                                                                    
endmodule