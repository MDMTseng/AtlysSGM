`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:46:11 03/17/2015 
// Design Name: 
// Module Name:    ArrayEleWidthReduce 
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
module ArrayEleWidthReduce
#(
parameter
dataIn_depth=6,
dataOut_depth=4,
ArrL=32)(
  input [dataIn_depth*ArrL-1:0]DIn,
  output[dataOut_depth*ArrL-1:0]DOut);
  genvar i;
	generate
		for(i=0;i<ArrL;i=i+1)
		begin:ccc
			assign DOut[dataOut_depth*i+:dataOut_depth]=
				(DIn[dataIn_depth*(i+1)-1-:(dataIn_depth-dataOut_depth)])?
					~0:
					DIn[dataIn_depth*i+:dataOut_depth];
		end
	endgenerate
endmodule
