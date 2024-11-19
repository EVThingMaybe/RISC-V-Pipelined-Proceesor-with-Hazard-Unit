//****************************************Copyright (c)***********************************//
// Copyright(C)            
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/15 12:29:45
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu 
// Created date:           2024/11/15 12:29:45
// mail      :            
// Version:                V1.0
// TEXT NAME:              writeback.v
// PATH:                   Pipeline_CPU_RISC-V/writeback.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Writeback(
    //input Signals
                             ReadDataW                  ,
                             ResultSrcW                 ,
                             ALUResulW                  ,
                             PCPlus4W                   ,
    //output Signals
                             ResultW                  
);

input [31:0]    ReadDataW;
input [1:0]     ResultSrcW;
input [31:0]    ALUResulW;
input [31:0]    PCPlus4W;

output reg [31:0]    ResultW;

//Writeback Stage
always @(*)begin                                        
        case(ResultSrcW)
            2'b00:begin
                ResultW = ALUResulW;
            end
            2'b01:begin
                ResultW = ReadDataW;
            end
            2'b10:begin
                ResultW = PCPlus4W;
            end
            default:begin
                ResultW = 32'h0;
            end                         
        endcase                          
end                                          

                                                                   
endmodule