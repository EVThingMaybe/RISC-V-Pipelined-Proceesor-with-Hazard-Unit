//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/14 18:23:40
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/11/14 18:23:40
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              DataMemory.v
// PATH:                   Pipeline_CPU_RISC-V/DataMemory.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module DataMemory(
                            clk                        ,
                            rst_n                      ,
                            ALUResultM                 ,
                            WriteDataM                 ,
                            MemWriteM                  ,
                            ReadDataW                                 
);


input clk, rst_n;
input [31:0] ALUResultM;
input [31:0] WriteDataM;
input MemWriteM;

output reg [31:0] ReadDataW;


reg [31:0] DataMem[63:0]; //Data Memory  //4GB 2^32-1 = 4294967295

//initial Data Memory
integer i;
initial begin
    for(i = 0; i < 64; i = i + 1)begin
        DataMem[i] <= 32'b0;
    end
end

//Data Memory
always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        ReadDataW <= 32'b0;
    end
    else begin
        if(MemWriteM)begin
            DataMem[ALUResultM[5:0]] <= WriteDataM;
        end
        else begin
            ReadDataW <= DataMem[ALUResultM[5:0]];
        end
    end
end
                                                                                                       
endmodule