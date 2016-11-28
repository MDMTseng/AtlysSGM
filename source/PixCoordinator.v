`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:48 11/03/2014 
// Design Name: 
// Module Name:    PixCoordinator 
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
module PixCoordinator
#(
parameter
frameW=640,
frameH=480)
(input clk,input en,input rst,output reg[$clog2(frameW):0]X,output reg[$clog2(frameH):0]Y);
	
	always@(posedge clk or posedge rst)
	begin 
		if(rst)
		begin
			X<=0;
			Y<=0;
		end
		else if(en)begin
			if(X==frameW-1)
			begin
				Y<=Y+1;
				X<=0;
			end
			else 
				X<=X+1;
		end
	end
	

endmodule
