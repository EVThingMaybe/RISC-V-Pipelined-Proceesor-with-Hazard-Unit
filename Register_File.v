//****************************************Copyright (c)***********************************//
// Copyright(C)            
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/10 16:22:46
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/10 16:22:46
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Register_File.v
// PATH:                   Pipeline_CPU_RISC-V/Register_File.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Register_File(
    //input signals
                              clk                         ,
                              rst_n                       ,
                              FlushE                      ,
                              Read_A1                     ,   //Read Address 1 A1
                              Read_A2                     ,   //Read Address 2 A2
                              Write_Enable_3              ,   //Write Enable for Register 3 WE3
                              Write_Data_3                ,   //Write Data Register 3 WD3
                              Write_Adress_3              ,   // Write Address Register 3 A3
    //output signals
                              Reg_Data_1                  ,   //Register Data 1 RD1 for Read Address 1
                              Reg_Data_2                     //Register Data 2 RD2 for Read Address 2;
);


input  clk, rst_n, Write_Enable_3; //Clock, Reset, Write Enable for Register 3
input FlushE; //Flush Enable
input [4:0] Read_A1; //Read Address Register 1
input [4:0] Read_A2; //Read Address Register 2
input [4:0] Write_Adress_3; //Write Address Register 3
input [31:0] Write_Data_3; //Write Data Register 3

output reg [31:0]  Reg_Data_1; //Register Data 1 for Read Address 1
output reg [31:0] Reg_Data_2; //Register Data 2 for Read Address 2


reg [31:0] Register_File_rd[31:0]; //Register File with 32 registers

always @(posedge clk or negedge rst_n)           
    begin                                        
        if(!rst_n)begin
            Register_File_rd[0] <= 32'h0;
            Register_File_rd[1] <= 32'h00000001;
            Register_File_rd[2] <= 32'h00000002;
            Register_File_rd[3] <= 32'h00000003;
            Register_File_rd[4] <= 32'h00000004;
            Register_File_rd[5] <= 32'h00000005;
            Register_File_rd[6] <= 32'h00000006;
            Register_File_rd[7] <= 32'h00000007;
            Register_File_rd[8] <= 32'h00000008;
            Register_File_rd[9] <= 32'h00000009;
            Register_File_rd[10] <= 32'h00000010;
            Register_File_rd[11] <= 32'h00000011;
            Register_File_rd[12] <= 32'h00000012;
            Register_File_rd[13] <= 32'h00000013;
            Register_File_rd[14] <= 32'h00000014;
            Register_File_rd[15] <= 32'h00000015;
            Register_File_rd[16] <= 32'h00000016;
            Register_File_rd[17] <= 32'h00000017;
            Register_File_rd[18] <= 32'h00000018;
            Register_File_rd[19] <= 32'h00000019;
            Register_File_rd[20] <= 32'h00000020;
            Register_File_rd[21] <= 32'h00000021;
            Register_File_rd[22] <= 32'h00000022;
            Register_File_rd[23] <= 32'h00000023;
            Register_File_rd[24] <= 32'h00000024;
            Register_File_rd[25] <= 32'h00000025;
            Register_File_rd[26] <= 32'h00000026;
            Register_File_rd[27] <= 32'h00000027;
            Register_File_rd[28] <= 32'h00000028;
            Register_File_rd[29] <= 32'h00000029;
            Register_File_rd[30] <= 32'h00000030;
            Register_File_rd[31] <= 32'h00000031;
            Reg_Data_1 <= 32'h00000000;
            Reg_Data_2 <= 32'h00000000; 
        end                                                                                
        else begin
            if(FlushE) begin
                Reg_Data_1 <= 32'h00000000;
                Reg_Data_2 <= 32'h00000000;           
            end
            else begin
                Reg_Data_1 <= Register_File_rd[Read_A1];
                Reg_Data_2 <= Register_File_rd[Read_A2];

            end
        end                               
end                                          

//Write Data to Register 3
always@(negedge clk) begin
    if (Write_Enable_3) begin
        Register_File_rd[Write_Adress_3] <= Write_Data_3;
    end
    
end                                                            
endmodule