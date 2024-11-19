//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/14 15:21:09
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/14 15:21:09
// mail      :            
// Version:                V1.0
// TEXT NAME:              MemoryWrite.v
// PATH:                   Pipeline_CPU_RISC-V/MemoryWrite.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module MemoryWrite(
    //input Signals
                              clk                        ,
                              rst_n                      ,
                              ResultSrcM                 ,
                              RegWriteM                  ,
                              MemWriteM                  ,  
                              WriteDataM                 ,
                              ALUResultM                 ,
                              RdM                        ,
                              PCPlus4M                   ,

//output Signals
                              RegWriteW                  ,
                              ResultSrcW                 ,
                              ALUResulW                  ,
                              RdW                        ,
                              ReadDataW                  ,
                              PCPlus4W                   


      
);

input clk, rst_n;
input RegWriteM, MemWriteM;
input [31:0] WriteDataM, ALUResultM;
input [4:0]  RdM;
input [31:0] PCPlus4M;
input [1:0]  ResultSrcM;

output reg         RegWriteW;
output reg  [1:0]  ResultSrcW;
output reg [31:0] ALUResulW;
output reg  [4:0]  RdW;
output wire  [31:0] ReadDataW;
output reg  [31:0] PCPlus4W;


//Data Memory
DataMemory DataMemory_inst(
    .clk(clk),
    .rst_n(rst_n),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .MemWriteM(MemWriteM),
    .ReadDataW(ReadDataW)
);

//register output
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        RegWriteW <= 1'b0;
        ResultSrcW <= 2'b00;
        RdW <= 5'b00000;
        PCPlus4W <= 32'b0;

        ALUResulW <= 32'b0;
    end
    else begin
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        RdW <= RdM;
        ALUResulW <= ALUResultM;
        PCPlus4W <= PCPlus4M;

    end
end

endmodule