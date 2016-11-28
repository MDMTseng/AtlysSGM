`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:19 03/16/2015 
// Design Name: 
// Module Name:    ShiftRegister 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ShiftRegister
 #(parameter
           data_depth=8,
           ShiftL = 4
       )(
			  input clk,input en,
           input [data_depth-1:0]DIn,
           input [data_depth-1:0]DOut
       );
		 
		 
		 
		 reg [ShiftL*data_depth-1:0]SReg;
		 assign DOut=SReg[ShiftL*data_depth-1-:data_depth];
		 
		 always@(posedge clk)if(en)SReg<={SReg,DIn};


endmodule
