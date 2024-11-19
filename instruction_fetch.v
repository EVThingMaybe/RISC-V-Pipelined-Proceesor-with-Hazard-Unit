`timescale 1ns / 1ps
//****************************************Copyright (c)***********************************//
// Copyright(C)            Wenchao Yu
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/10 20:29:07
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/10 20:29:07
// mail      :            
// Version:                V1.0
// TEXT NAME:              instruction_fetch.v
// PATH:                   Pipeline_CPU_RISC-V/instruction_fetch.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module instruction_fetch(
	//Inputs
                            clk                        ,
                            rst_n                      ,
                            PCTargetE                  ,
							PCSrcE					   ,
                            StallF                     ,
						    StallD                     ,
						    FlushD  				   , 
	//Outputs
                            InstrD				       ,
                            PCD                        ,
                            PCPlus4D				   ,
							validD
);

input clk, rst_n, StallF;  //Clock, Reset, Stall Signal
input [31:0] PCTargetE;    //PC Target from Execute Stage
input PCSrcE;		   //PC Source from Execute Stage
input StallD;		   //Stall Signal from Hazard Unit 
input FlushD;		   //Flush Signal from Hazard Unit


output reg [31:0] InstrD;    		//Instruction from Memory
output reg [31:0] PCD;				//Program Counter
output reg [31:0] PCPlus4D;			//PC+4 
output reg validD ; //Valid Signal to check stall or not in Decode Stage

reg [31:0] PCF;                     //Program Counter

wire [31:0] PCF_prev;         	    //Previous PC
wire [31:0] PCPlus4F;               //Program Counter + 4 


assign PCPlus4F = PCF + 4  ;                 //PC+4;


assign PCF_prev = PCSrcE ? PCTargetE : PCPlus4F;   //PCF_prev = PCTargetE if PCSrcE is true, else PCPlus4F
always @(posedge clk or negedge rst_n)begin                                        
	if(!rst_n)                               
		PCF <= 32'b0;                        
	else begin
		if(!StallF)  
		PCF <= PCF_prev;                                     
	end    
end                                     


wire [31:0] instrD_prev;          //Previous Instruction

//  Instruction Memory Module
InstructionMemory InstructionMemory_inst(
	.Address(PCF),
	.Reg_Data_instr(instrD_prev)
);

//  PCPlus4D ,
//reg ValidF; //Valid Signal to check stall or not in Fetch Stage
reg validF ; //Valid Signal to check stall or not in Fetch Stage

//reg validE ; //Valid Signal to check stall or not in Execute Stage

wire validF_prev; //Previous Valid Signal
assign validF_prev = instrD_prev != 32'b0 ? 1'b1 : 1'b0; //validF_prev = 1 if instrD_prev is not 0, else 0
always @(posedge clk or negedge rst_n)           
	begin                                        
		if(!rst_n)begin                               
			validF <= 1'b0;
			validD <= 1'b0;
		end				                                   
		else begin
			validD  <=  validF_prev && !StallF;
			//validD <= validF; 
		end													                                     
	end                                          



always @(posedge clk or negedge rst_n)begin                                        
	if(!rst_n)begin
		PCD <= 32'b0;                        
		InstrD <= 32'b0;                        
		PCPlus4D <= 32'b0;
	end      
	else begin
		if(FlushD)begin                                     
			//PCD <= 32'h0;                                                                         
			InstrD <= 32'h0;
			//PCPlus4D <= 32'h0;      
		end
		else begin 
			if(!StallD)begin
			PCD <= PCF;                             
			InstrD <= instrD_prev;                      
			PCPlus4D <= PCPlus4F;
			end
			else begin
			PCD <= PCD;
			InstrD <= 32'b0;
			PCPlus4D <= PCPlus4D;
			end
		end                       
	end                                                              
end                                          


endmodule