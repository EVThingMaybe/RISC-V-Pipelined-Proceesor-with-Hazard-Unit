//****************************************Copyright (c)***********************************//
// Copyright(C)            
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/05 15:56:01
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/05 15:56:01
// mail      :             
// Version:                V1.0
// TEXT NAME:              ALU_Decoder.v
// PATH:                   Pipeline_CPU_RISC-V/ALU_Decoder.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ALU_Decoder(
                                   op_5                        ,
                                   funct3                      ,
                                   funct7_5                    ,
                                   ALUop                       ,
                                   ALUControl                   
    );

input op_5;
input [2:0] funct3;
input funct7_5;
input [1:0] ALUop;

output reg [2:0] ALUControl;

wire [1:0] op_5_func7_5 ;
assign op_5_func7_5 = {op_5, funct7_5};

//******************ALU Decodeer FSM****************************************************
// ALUop    funct3     op_5_func7_5     instruction      ALUControl
// 00        xxx        xx              lw,sw              000(add)
// 01        xxx        xx              beq                001(sub)
// 10        000        00,01,10        add                000(add)
// 10        000        11              sub                001(sub)
// 10        010        xx              slt                101(set less than)
// 10        110        xx              or                 011(or)
// 10        111        xx              slt                010(and)
// 10        101        xx              srl                110(srl)
// 10        100        xx              sll                100(sll)


always @(*)
begin                                        
    case(ALUop[1:0])
        2'b00 : ALUControl = 3'b000; // add
        2'b01 : ALUControl = 3'b001; // sub
        2'b10 : 
            case(funct3)
                3'b000 : ALUControl = op_5_func7_5 == 2'b11 ? 3'b001 : 3'b000; // subtract, ohterwise add
                3'b010 : ALUControl = 3'b101; // slt(set less than)
                3'b001 : ALUControl = 3'b100; // sll
                3'b101 : ALUControl = 3'b110; // srl
                3'b110 : ALUControl = 3'b011; // or
                3'b111 : ALUControl = 3'b010; // and
                //xor
                3'b100 : ALUControl = 3'b111; // xor
                default : ALUControl = 3'b000; // add
            endcase
    endcase                                                                                
end                                          
                                                                   
endmodule