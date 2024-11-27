//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/12 13:14:58
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/12 13:14:58
// mail      :             
// Version:                V1.0
// TEXT NAME:              ALU.v
// PATH:                   Pipeline_CPU_RISC-V/ALU.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ALU(
             SrcAE,
             SrcBE,
             ALUControlE,
             ZeroE,
             ResultE
            );

input [31:0] SrcAE;
input [31:0] SrcBE;
input [2:0] ALUControlE;
output ZeroE;
output reg [31:0] ResultE;

//******************ALU Functionality ****************************************************
//ALU Control Signal
// 000: ADD
// 001: SUB
// 010: AND
// 011: OR
// 101: SLT

//Zero Flag
// 0: Zero
// 1: Not Zero

//ResultE is the output of the ALU
//ZeroE is the Zero Flag

wire [31:0] invSrcBE;
wire [31:0] selectSrcBE;

assign invSrcBE = ~SrcBE;
assign selectSrcBE  =  ALUControlE[0]==1'b1 ? invSrcBE : SrcBE;

wire         cout ;
wire [31:0]  sum  ;

add32 add32_ALU(
    .a(SrcAE),
    .b(selectSrcBE),
    .sum(sum),
    .carry_in(ALUControlE[0]),
    .carry_out(cout)
);

wire [31:0] andResult;
wire [31:0] orResult;
wire [31:0] sllResult;
wire [31:0] srlResult;
wire [31:0] xorResult;

//And operation, Or operation, shift left logical operation , shift right logical operation, xor operation
assign andResult = SrcAE & selectSrcBE;
assign orResult  = SrcAE | selectSrcBE;
assign sllResult = SrcAE << SrcBE[4:0];
assign srlResult = SrcAE >> SrcBE[4:0];
assign xorResult = SrcAE ^ selectSrcBE;

// SLT operation: check if A < B by using the MSB (sign bit) of Sum
wire SltResult;
assign SltResult = sum[31];


// ALU result selection based on ALUControl
always @(*) begin
    case (ALUControlE)
        3'b000: ResultE = sum;       // Add
        3'b001: ResultE = sum;       // Subtract
        3'b010: ResultE = andResult; // AND
        3'b011: ResultE = orResult;  // OR
        3'b100: ResultE = sllResult;       // SLL 
        3'b110: ResultE = srlResult;       // SRL
        3'b111: ResultE = xorResult; // XOR
        3'b101: ResultE = {31'b0, SltResult}; // SLT (Set Less Than)
        default: ResultE = 32'b0;
    endcase
end

// Zero Flag
assign ZeroE = (ResultE == 32'b0);

endmodule