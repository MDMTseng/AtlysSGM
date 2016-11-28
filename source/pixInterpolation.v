
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:18:39 02/08/2015 
// Design Name: 
// Module Name:    pixInterpolation 
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
module pixInterpolation
#(
parameter 
dataDepth=8,
dataSelDepth=1,
subPixDepth=5

)(
input [DataL*dataDepth-1:0]DataCol,
input [dataSelDepth+subPixDepth-1:0]interpValue,
output [dataDepth-1:0]res

    );
localparam DataL=2**(dataSelDepth)+1;

wire [dataDepth-1:0]ress[DataL-1-1:0];
genvar i;
generate
	for(i=0;i<DataL-1;i=i+1)
	begin:loop
		wire[subPixDepth-1:0]_iV=~interpValue[0+:subPixDepth];
		wire[dataDepth+subPixDepth-1:0]A=DataCol[(i+1)*dataDepth+:dataDepth]*interpValue[0+:subPixDepth];
		wire[dataDepth+subPixDepth-1:0]B=DataCol[(i+0)*dataDepth+:dataDepth]*(_iV);
			
		wire[dataDepth+subPixDepth+1-1:0]Sum=A+B;
		
		
		wire[dataDepth-1:0]interP=Sum[dataDepth+subPixDepth-1-:dataDepth];
		
		assign ress[i]=Sum[dataDepth+subPixDepth-1-:dataDepth];
		
	end
	if(dataSelDepth!=0)
		assign res=ress[interpValue[subPixDepth+:dataSelDepth]];
	else
		assign res=ress[0];
endgenerate





endmodule
