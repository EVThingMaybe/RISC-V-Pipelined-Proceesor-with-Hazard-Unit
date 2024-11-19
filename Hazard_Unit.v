`timescale 1ns / 1ps
//****************************************Copyright (c)***********************************//
// Copyright(C)            Wenchao Yu
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/11 12:57:34
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/11 12:57:34
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              Hazard_Unit.v
// PATH:                   Pipeline_CPU_RISC-V/Hazard_Unit.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Hazard_Unit(
  //Inputs Signals
                          validD                      ,   //Valid Signal check stall or not
                          Rs1E                        ,   //Rs1 from Execute Stage
                          Rs2E                        ,   //Rs2 from Execute Stage
                          Rs1D                        ,   //Rs1 from Decode Stage;
                          Rs2D                        ,   //Rs2 from Decode Stage
                          RdE                         ,   //Rd from Execute Stage
                          RdM                         ,   //Rd from  Memory Stage
                          RdW                         ,   //Rd from Write Back Stage
                         PCSrcE                      ,   //PC Source from Execute Stage
                         RegWriteW                   ,   //RegWrite from Write Back Stage
                         RegWriteM                   ,   //RegWrite from Memory Stage;
                         ResultSrcE_0                ,   //Result Source from Execute Stage
//Outputs Signals
                          StallD                      ,   //Stall Signal;
                          FlushD                      ,   //Flush Signal;
                          StallF                      ,   //Stall Signal;
                          FlushE                      ,   //Flush Signal;

                          ForwardAE                   ,   //Forward A from Execute Stage
                          ForwardBE                      //Forward B from Execute Stage                      
);
                                                                   

input RegWriteW, RegWriteM, ResultSrcE_0, PCSrcE; //Inputs
input [4:0] Rs1E, Rs2E, Rs1D, Rs2D, RdE, RdM, RdW; //Inputs
input validD; //Valid Signal

output reg [1:0] ForwardAE, ForwardBE; //Outputs
output wire StallD, FlushD, StallF, FlushE; //Outputs

//Forward A and Forward B Signals
always @(*)begin                                        
        if((Rs1E == RdM) && (RegWriteM) && (Rs1E != 5'b0)) begin
            ForwardAE = 2'b10; //Forward A from Memory Stage
        end
        else if(((Rs1E == RdW) && RegWriteW )&&(Rs1E != 5'b0)) begin
            ForwardAE = 2'b01; //Forward A from Write Back Stage
        end
        else begin
            ForwardAE = 2'b00; //No Forwarding
        end                                                    
end                                          

always @(*)begin
        if((Rs2E == RdM && RegWriteM)&&(Rs1E!= 5'b0)) begin
            ForwardBE = 2'b10; //Forward B from Memory Stage
        end
        else if((Rs2E == RdW && RegWriteW)&&(Rs1E!= 5'b0)) begin
            ForwardBE = 2'b01; //Forward B from Write Back Stage
        end
        else begin
            ForwardBE = 2'b00; //No Forwarding
        end                                                    
end


//Stall and Flush Signals  // Stalling Logic

wire lwStall ;
assign lwStall = (Rs1D == RdE || Rs2D == RdE) && validD; //Load Use Hazard

assign StallF = lwStall; //Stall Signal from Fetch Stage
assign StallD = lwStall; //Stall Signal from Decode Stage;

//Flushing Logic
assign FlushD = PCSrcE;  //Flush Signal from Decode Stage;
assign FlushE = lwStall || PCSrcE; //Flush Signal from Execute Stage;

                                                          
endmodule