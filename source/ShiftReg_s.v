`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Albert Wang
// 
// Create Date:    20:02:59 09/08/2014 
// Design Name:    ShiftReg_window
// Module Name:    ShiftReg_window 
// Project Name: 
// Target Devices: Spartan6
// Tool versions: Xilinx ISE 14.7
// Description: 
//
// Dependencies: No
//
// Revision 0.11 - works as it should
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ShiftReg_s(input clk,input [dataDept-1:0]inData,output[windowW*windowH*dataDept-1:0] Window);
/*
Simply using shift register to achieve window extraction
EX:
for a width=10, window_W=3, window_H=3
we need shift register in length (window_H-1)*width+window_W=23
shift registerd data as below from 01 to 23

|01 02 03|04 05 06 07 08 09 10
|11 12 13|14 15 16 17 18 19 10
|01 22 23|

the window as below
01 02 03
11 12 13
01 22 23

**if we push one more pixel (24) in **
XX|02 03 04|05 06 07 08 09 10
11|12 13 14|15 16 17 18 19 10
01|22 23 24|
(XX) means discard data

the window will be
02 03 04
12 13 14
22 23 24


**if we push one more pixel (25) in **
XX XX|03 04 05|06 07 08 09 10
11 12|13 14 15|16 17 18 19 10
01 22|23 24 25|

the window will be
03 04 05
13 14 15
23 24 25


The window moves along with data push in
*/
	parameter dataDept=8;
	parameter frameW=640;
	parameter windowW=3;
	parameter windowH=3;
	
	parameter shiftRegSize=dataDept*((windowH-1)*frameW+windowW);
	
	//Window extraction
	 genvar i,j;
	 generate
		for(i = 0; i < windowH; i = i + 1) begin : array
		  for(j = 0; j < windowW; j = j + 1) begin : vector
			 assign Window[dataDept*(i * windowW + j)+:dataDept] = 
				shiftReg[dataDept*(i*frameW+j)+:dataDept];
		  end
		end
	 endgenerate
	
	reg[shiftRegSize-1:0] shiftReg;
	
	
	//Shift register
	always@(posedge clk)
	begin
		shiftReg<={shiftReg,inData};
	end

endmodule
