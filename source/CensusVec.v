`timescale 1ns / 1ps

module CensusVec
#(
parameter
	 CVPadding=0,
	 dataInDepth=8,
	 WinW=9,
	 skipIdx=(WinW-1)/2

)

(
	input [dataInDepth*WinW-1:0]WinIn,
	input [dataInDepth-1:0]DIn,
	output [OutW-1:0]OutResult
    );
	localparam OutW=WinW-((skipIdx>=WinW)?0:1);
	 
	wire [dataInDepth-1:0]DInp=DIn+CVPadding;
	 genvar i;
	 generate
		for(i = 0; i < WinW; i = i + 1) begin : array
			if(i<skipIdx)
			 assign OutResult[i]= (WinIn[i*dataInDepth+:dataInDepth]<DInp);
			else if(i>skipIdx)
			 assign OutResult[i-1]= (WinIn[i*dataInDepth+:dataInDepth]<DInp);
		end
	 endgenerate
	 

endmodule
