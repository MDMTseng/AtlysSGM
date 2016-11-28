`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:29 02/08/2015 
// Design Name: 
// Module Name:    ShiftReg_blkRAM 
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
module ShiftReg_blkRAM

(
	input clk,
	input en,
	input [data_depth-1:0] data_in,
	output [data_depth-1:0] data_out
);
	 

	parameter //cannot be adjusted
	data_depth=32,
	shiftRegL=640;











endmodule
