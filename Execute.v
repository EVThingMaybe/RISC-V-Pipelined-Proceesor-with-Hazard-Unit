//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/12 15:27:52
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             WenChao Yu
// Created date:           2024/11/12 15:27:52
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Execute.v
// PATH:                   Pipeline_CPU_RISC-V/Pipeline_CPU_RISC-V/Execute.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Execute(
    //input Signals
                            clk                        ,
                            rst_n                      ,
                            ALUControlE                ,
                            ALUSrcE                    ,
                            BranchE                    ,
                            MemWriteE                  ,
                            ResultSrcE                 ,
                            JumpE                      ,
                            RegWriteE                  ,
                            PCPlus4E                   ,
                            RD1E                       ,
                            RD2E                       ,
                            ExtImmE                    ,
                            PCE                        ,
                            RdE                        ,
                            ALUResultM_in              ,
                            ResultW                    ,
                            ForwardAE                  , 
                            ForwardBE                  ,
//output Signals
                            RegWriteM                  ,
                            ResultSrcM                 , 
                            MemWriteM                  ,  
                            PCSrcE                     ,
                            PCPlus4M                   ,
                            WriteDataM                 ,       
                            ALUResultM                 ,
                            RdM                        ,
                            PCTargetE                  ,          
                            ResultSrcE_0                                                                      
); // 
                                                                   

// input Signals
input clk, rst_n, RegWriteE, MemWriteE;
input [2:0] ALUControlE;
input [1:0] ResultSrcE;
input [31:0] ALUResultM_in, ResultW;
input [4:0] RdE;


input  ALUSrcE;
input  BranchE;
input  JumpE;
input [31:0] ExtImmE, PCPlus4E, PCE, RD1E, RD2E;
input [1:0] ForwardAE, ForwardBE;


// output Signals
output reg          RegWriteM, MemWriteM;
output reg  [1:0]   ResultSrcM;
output reg  [4:0]   RdM;
output reg  [31:0]  ALUResultM, WriteDataM, PCPlus4M;
output wire         PCSrcE;
output wire [31:0]  PCTargetE;
output wire         ResultSrcE_0;

reg   [31:0]     SrcAE_prev, WriteDataE;
wire  [31:0]     ALUResultE;

//SrcAE
always@(*)begin
    case(ForwardAE)
    2'b00: SrcAE_prev = RD1E;
    2'b01: SrcAE_prev = ResultW;
    2'b10: SrcAE_prev = ALUResultM_in;
    default: SrcAE_prev = 32'b0;
    endcase
end

wire [31:0] SrcAE;
assign SrcAE = SrcAE_prev;

//SrcBE_prev
always@(*)begin
    case(ForwardBE)
    2'b00: WriteDataE = RD2E;
    2'b01: WriteDataE = ALUResultM_in;
    2'b10: WriteDataE = ResultW;
    default: WriteDataE = 32'b0;
    endcase
end

wire [31:0] SrcBE;
assign SrcBE = ALUSrcE == 1'b1 ? ExtImmE : WriteDataE ;



//ALUResultE
wire ZeroE;
ALU ALU1(
    .ALUControlE(ALUControlE),
    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .ResultE(ALUResultE),
    .ZeroE(ZeroE)
);


//PCSrE
assign PCSrcE = JumpE | (BranchE & ZeroE);

//PCTargetE
assign PCTargetE = PCE + ExtImmE;

// register write
always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        RegWriteM <= 1'b0;
        MemWriteM <= 1'b0;
        ResultSrcM <= 2'b00;
        RdM <= 5'b00000;
        ALUResultM <= 32'b0;
        WriteDataM <= 32'b0;
        PCPlus4M <= 32'b0;
    end
    else begin
        RegWriteM <= RegWriteE;
        MemWriteM <= MemWriteE;
        ResultSrcM <= ResultSrcE;
        RdM <= RdE;
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        PCPlus4M <= PCPlus4E;
    end
end

assign ResultSrcE_0 = ResultSrcE[0];


endmodule