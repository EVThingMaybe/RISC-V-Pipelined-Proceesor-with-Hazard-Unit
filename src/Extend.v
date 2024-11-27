//****************************************Copyright (c)***********************************//
// Copyright(C)            
// All rights reserved    
// File name:              
// Last modified Date:     2024/11/05 17:56:53
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/05 17:56:53
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Extend.v
// PATH:                   Pipeline_CPU_RISC-V/Extend.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Extend(
              InstrD            ,
              ImmSrcD           ,
              ExtImmD
    );
                          
    input [31:0] InstrD;
    input [1:0]  ImmSrcD;
    output reg [31:0] ExtImmD;

//******************Extended Functionality ****************************************************
//InstrD is orignally 32-bit instruction, here we extend it to 32-bit immediate value 
//InstrD[31:7] as input to InstrD in this module, that means we only consider the last 25 bits of the instruction

// ImmSrcD                      ImmExt                                     Instruction Type
// 00           {{20{InstrD[31]}}, InstrD[31:20]}                                I-Type
// 01           {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]}                   S-Type
// 10           {{19{InstrD[31]}}, InstrD[31], InstrD[7],InstrD[30:25]}            B-Type
// 11           {{12{InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21],1'b0}  J-Type




    always @(*) begin
        case(ImmSrcD)
        2'b00: ExtImmD = {{20{InstrD[31]}}, InstrD[31:20]};
        2'b01: ExtImmD = {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]};
        2'b10: ExtImmD = {{19{InstrD[31]}}, InstrD[31], InstrD[7], InstrD[30:25],1'b0};
        2'b11: ExtImmD = {{12{InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0};
        default: ExtImmD = 32'b0;
        endcase
    end

                                                                   
                                                                   
endmodule