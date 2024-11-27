`timescale 1ns / 1ps
//****************************************Copyright (c)***********************************//
// Copyright(C)            
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/15 16:35:54
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/15 16:35:54
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              PPWHU_Test.v
// PATH:                   Pipeline_CPU_RISC-V/PPWHU_Test.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module PPWHU_Test;

//Input signals
reg clk;
reg rst_n;

//Output signals
wire [31:0] PCF_out;
wire [31:0] InstrD_out;
wire [31:0] ALUResultE_out;
wire [31:0] ReadDataW_out;
wire [31:0] ALUResultW_out;
wire  StallF_out;

//Instantiate the Pipelined_Processor_with_Hazard_Unit module
Pipelined_Processor_with_Hazard_Unit Pipelined_Processor_with_Hazard_Unit(
    .clk(clk),
    .rst_n(rst_n),
    .PCF_out(PCF_out),
    .InstrD_out(InstrD_out),
    .ALUResultE_out(ALUResultE_out),
    .ReadDataW_out(ReadDataW_out),
    .ALUResultW_out(ALUResultW_out),
    .StallF_out(StallF_out)
);

//Initial block to initialize the input signals
initial begin
    clk = 0;
    rst_n = 0;

    //Toggle the clock signal
    #15 rst_n = 1;

    //Toggle the clock signal
end

always #10 clk = ~clk;
                                                                   
endmodule