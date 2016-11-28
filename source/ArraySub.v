`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:02:36 02/28/2015 
// Design Name: 
// Module Name:    ArraySub 
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
module ArrayAddSubValue
#(
parameter dataW=8,
ArrL=1,
Add1_Sub0=1
)
(input [dataW*ArrL-1:0]Arr,input[dataW-1:0]Value,output[dataW*ArrL-1:0]OutArr);

generate 
	genvar i;
	for(i=0;i<ArrL;i=i+1)
	begin:ccc
		if(Add1_Sub0)begin
			assign OutArr[i*dataW+:dataW]=Arr[i*dataW+:dataW]+Value;
		end else begin
			assign OutArr[i*dataW+:dataW]=Arr[i*dataW+:dataW]-Value;
			
		end
	end
endgenerate



endmodule
