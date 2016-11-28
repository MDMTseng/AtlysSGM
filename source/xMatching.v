
	



module xMatching
#(
	parameter 
	dataDept=4,
	Rewin_W=8,
	Rewin_H=8,
	Cowin_W=2,
	Cowin_H=2

)
(input [dataDept*Cowin_W*Cowin_H-1:0]coreWin,input [dataDept*Rewin_W*Rewin_H-1:0]RegionWin,
output[CompResultDepth-1:0] MinV,output [CompResultIndexDepth-1:0]MinVIdx);

	parameter CompResultDepth=dataDept+$clog2(Cowin_W*Cowin_H);
	parameter CompResultIndexDepth=dataDept+$clog2(shiftW*shiftH);
	
	
	localparam shiftW=(Rewin_W-Cowin_W+1);//search avalible region
	localparam shiftH=(Rewin_H-Cowin_H+1);
	wire[dataDept*Cowin_W*Cowin_H*shiftW*shiftH-1:0] StratchWin;
	
	genvar si,sj,sk;
	/*function[dataDept:0] idx2Weight
	begin
		
	
	end*/
	
	generate
		for(si=0;si<shiftH;si=si+1)for(sj=0;sj<shiftW;sj=sj+1)//tripple loop
			for(sk=0;sk<Cowin_H;sk=sk+1)
			begin
				assign StratchWin[dataDept*Cowin_W*(Cowin_H*(si*shiftW+sj)+sk)+:dataDept*Cowin_W]=
				RegionWin[dataDept*((si+sk)*Rewin_W+sj)+:dataDept*Cowin_W];
			end
	endgenerate
	
	
	wire[CompResultDepth*shiftW*shiftH-1:0] compData;
	wire[CompResultDepth*shiftW*shiftH-1:0] compDataWithWeight;
	genvar sadi;
	generate
		for(sadi=0;sadi<shiftH*shiftW;sadi=sadi+1)
			begin
				SAD_Mod#(dataDept,Cowin_W*Cowin_H)
				SM(
					StratchWin[sadi*dataDept*Cowin_W*Cowin_H+:dataDept*Cowin_W*Cowin_H],
					coreWin
					,compData[CompResultDepth*sadi+:CompResultDepth]
					
				);
				/*compDataWithWeight[CompResultDepth*sadi+:CompResultDepth]=
				compData[CompResultDepth*sadi+:CompResultDepth]+
				
				;*/
				
			end
		
	endgenerate
	
	
	getMinIdx #(.data_depth(CompResultDepth),.ArrL(shiftW*shiftH),.IdxOffSet(0))
          GMI(compDataWithWeight,MinV,MinVIdx);

endmodule
