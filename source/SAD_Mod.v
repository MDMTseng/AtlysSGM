`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MDM
// Engineer: Chia-Pin Tseng
// 
// Create Date:    20:02:59 09/08/2014 
// Design Name:    
// Module Name:    hijacker 
// Project Name: 
// Target Devices: Spartan6
// Tool versions: Xilinx ISE 14.7
// Description: 
//
// Dependencies: (ShiftReg_window,ShiftComparator:(DiffGetter))
//
// Revision 0.11 - 1st prototype for disparity mapping
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module SAD_Mod
#(
parameter 
dataInDepth=8,
dataInL=10
)
(// Computing the difference between two windows
	input [dataInDepth*dataInL-1:0]DIn1,
	input [dataInDepth*dataInL-1:0]DIn2,
	output [dataOutDepth-1:0]OutResult
    );
	 parameter dataOutDepth=dataInDepth+$clog2(dataInL);
	 //dataInDepth+(dataInL-1);
	 // 2 data width +1
	 // n data width +(n-1)
		
	
	 wire [(dataInDepth+1)*dataInL-1:0]CompTmp;
	 wire [dataInDepth*dataInL-1:0]ABSCompTmp;
	 genvar i;
	 generate
		for(i = 0; i < dataInL; i = i + 1) begin : array
			 assign CompTmp[((dataInDepth+1)*(i))+:dataInDepth+1]= 
				DIn2[dataInDepth*(i)+:dataInDepth]-DIn1[dataInDepth*(i)+:dataInDepth];//SUB 
				
			 assign ABSCompTmp[((dataInDepth)*(i))+:dataInDepth]= 
			 (CompTmp[((dataInDepth+1)*(i))+dataInDepth]==1'b1)?//find highest bit neg/pos
			  -CompTmp[((dataInDepth+1)*(i))+:dataInDepth]:
			  CompTmp[((dataInDepth+1)*(i))+:dataInDepth];
		end
	 endgenerate
	
	AdderTree #(.data_depth(dataInDepth),.ArrL(dataInL))
			AT1(ABSCompTmp,OutResult);
		
endmodule
