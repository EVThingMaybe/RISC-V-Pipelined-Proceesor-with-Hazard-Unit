//****************************************Copyright (c)***********************************//
// Copyright(C)            
// All rights reserved     
// File name:              
// Last modified Date:     2024/11/19 13:55:10
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Wenchao Yu
// Created date:           2024/11/19 13:55:10
// mail      :             
// Version:                V1.0
// TEXT NAME:              InstructionMemory .v
// PATH:                   Pipeline_CPU_RISC-V/InstructionMemory .v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
                                               

module InstructionMemory (
                    Address,                    //  Address  
                    Reg_Data_instr            //  Register Data for Instruction
    );

input [31:0] Address;                    //  Address
output wire [31:0] Reg_Data_instr;            //  Register Data for Instruction

    // 
    //reg [31:0] memory [0:63];  // 64 32-bit words

    /* //initial instruction memory
    initial begin
        $readmemh("instructions.mem", memory);  // from hex.file to memory
    end
    */

    // from memory to Instr
    //assign Instr = memory[Address >> 2];  // get the instruction from memory, each instruction is 4 bytes

	wire [31:0] rom [0:63];

	 assign rom[6'h00]=32'h00000000;
	 assign rom[6'h01]=32'h00C48413;   		//addi x8, x9, 12
	 assign rom[6'h02]=32'hFF230913;		//addi  x18, x6,-14
	 assign rom[6'h03]=32'hFFA9A383;		//lw   x7, -6(x19)
	 assign rom[6'h04]=32'h01B01483;	    //lh   x9, 27(x0)
	 assign rom[6'h05]=32'h01FA0A03;	    //lb   x20, 0x1F)x20;
	 assign rom[6'h06]=32'h00000000;        
	 assign rom[6'h07]=32'h00000000;	    
     assign rom[6'h08]=32'h00000000;       
	 assign rom[6'h09]=32'h00000000;       
     assign rom[6'h0A]=32'h00000000;      
	 assign rom[6'h0B]=32'h00000000;      
	 assign rom[6'h0C]=32'h00000000;      
	
	 assign rom[6'h0D]=32'h00000000;
	 assign rom[6'h0E]=32'h00000000;
     assign rom[6'h0F]=32'h00000000;
	 assign rom[6'h10]=32'h00000000;
	 assign rom[6'h11]=32'h00000000;
	 assign rom[6'h12]=32'h00000000;
	 assign rom[6'h13]=32'h00000000;
	 assign rom[6'h14]=32'h00000000;
	 assign rom[6'h15]=32'h00000000;
	 assign rom[6'h16]=32'h00000000;
	 assign rom[6'h17]=32'h00000000;
	 assign rom[6'h18]=32'h00000000;
	 assign rom[6'h19]=32'h00000000;
	 assign rom[6'h1A]=32'h00000000;
	 assign rom[6'h1B]=32'h00000000;
	 assign rom[6'h1C]=32'h00000000;
	 assign rom[6'h1D]=32'h00000000;
	 assign rom[6'h1E]=32'h00000000;
	 assign rom[6'h1F]=32'h00000000;
	 assign rom[6'h20]=32'h00000000;
	 assign rom[6'h21]=32'h00000000;
	 assign rom[6'h22]=32'h00000000;
	 assign rom[6'h23]=32'h00000000;
	 assign rom[6'h24]=32'h00000000;
	 assign rom[6'h25]=32'h00000000;
	 assign rom[6'h26]=32'h00000000;
	 assign rom[6'h27]=32'h00000000;
	 assign rom[6'h28]=32'h00000000;
	 assign rom[6'h29]=32'h00000000;
	 assign rom[6'h2A]=32'h00000000;
	 assign rom[6'h2B]=32'h00000000;
	 assign rom[6'h2C]=32'h00000000;
	 assign rom[6'h2D]=32'h00000000;
	 assign rom[6'h2E]=32'h00000000;
	 assign rom[6'h2F]=32'h00000000;
	 assign rom[6'h30]=32'h00000000;
	 assign rom[6'h31]=32'h00000000;
	 assign rom[6'h32]=32'h00000000;
	 assign rom[6'h33]=32'h00000000;
	 assign rom[6'h34]=32'h00000000;
	 assign rom[6'h35]=32'h00000000;
	 assign rom[6'h36]=32'h00000000;
	 assign rom[6'h37]=32'h00000000;
	 assign rom[6'h38]=32'h00000000;
	 assign rom[6'h39]=32'h00000000;
	 assign rom[6'h3A]=32'h00000000;
	 assign rom[6'h3B]=32'h00000000;
	 assign rom[6'h3C]=32'h00000000;
	 assign rom[6'h3D]=32'h00000000;
	 assign rom[6'h3E]=32'h00000000;
	 assign rom[6'h3F]=32'h00000000;
	 
assign  Reg_Data_instr = rom[Address[7:2]];

endmodule