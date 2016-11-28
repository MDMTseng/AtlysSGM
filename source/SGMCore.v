`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:13:12 03/16/2015 
// Design Name: 
// Module Name:    SGMCore 
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
module SGMCore
#(
parameter
	SGMDataDepth=6,
	censusVecW=24,
	dispLevel=32,
	ImageW=640,
	ImageH=480

)(
input clk,input en,
input [censusVecW*(dispLevel)-1:0]LineData,
input [censusVecW-1:0]PixData,
input IsOnEdge,
input [6-1:0]P1,
input [6-1:0]P2,
output [DispDataW-1:0]disparity
    );
parameter DispDataW=$clog2(dispLevel);


	/*
	       *    | 
	********  <--    left image as reference image
	P0     P6
	
	vs
	
	|	   P6     P0 
	-->	********      right image as reference image
	      *
	
	
	*/
	
	
	//dir0 : left top
	//dir1 : top
	//dir2 : right top
	//dir3 : left
	parameter LSGMDirs=4;
	wire [SGMDataDepth*(dispLevel)-1:0]SGMInfo[LSGMDirs-1:0];
	wire [SGMDataDepth*(dispLevel)-1:0]SGMInfo_sm[LSGMDirs-1:0];
	
	
	wire [SGMDataDepth*(dispLevel)-1:0]SGMInfo_sm_middle[LSGMDirs-1:0];
	
	/*
	  |->minL-|
	->SGMInfo->SGMInfo_buff->SGMInfo_sm->(for init delay)SGMInfo_in->(image Width-4 delay)->SGMInfo_shiftOut[2:0]->SGMInfo_shiftOut_reg[2:0]->SGMInfo_shiftOut_buf[3:0]
	                                           SGMInfo_in3_reg------------------------------------------------------------------->
	*/
	
	
	reg [SGMDataDepth*(dispLevel)-1:0]SGMInfo_tmp_d0;
	reg [SGMDataDepth*(dispLevel)-1:0]SGMInfo_in0_reg;
	reg [SGMDataDepth*(dispLevel)-1:0]SGMInfo_in1_reg;
	reg [SGMDataDepth*(dispLevel)-1:0]SGMInfo_in3_reg;
	
	
	wire [SGMDataDepth*(dispLevel)-1:0]SGMInfo_in[LSGMDirs-2:0];
	assign SGMInfo_in[0]=SGMInfo_in0_reg;
	assign SGMInfo_in[1]=SGMInfo_in1_reg;
	assign SGMInfo_in[2]=SGMInfo_sm[2];
	
	wire [SGMDataDepth*(dispLevel)-1:0]SGMInfo_shiftOut[LSGMDirs-1:0];
	assign SGMInfo_shiftOut[3]=SGMInfo_sm[3];//SGMInfo_in3_reg;
	
	
	
	//dir3 is just to use privious SGM data, so it needs only 1 delay.
	//dir0,dir2,dir3 data will be sent in module ShiftRegWd1 to produce delay effect(SGMInfo_shiftOut_dirX is the video_width-1 delay output of )
	//dir2 is right top pixel from current pixel(that is it needs video_width-1 delay).
	//And module ShiftRegWd1 does is exactly video_width-1 delay, there for dir2 don't need extra delay
	
	parameter alpha8=7;
	parameter alpha8_re=8-alpha8;
	
	genvar gdi;//generate disparity index
	genvar gri;//generate r index (r is direction)
	parameter SGMDataDepth_reduce=SGMDataDepth-2;
	parameter SGMDataDepth_branch_reduce=SGMDataDepth-1;
	generate
		for(gri=0;gri<LSGMDirs;gri=gri+1)
		begin
			
			
			/*
			wire [SGMDataDepth-1:0]minL;
			getMinIdx  #(.data_depth(SGMDataDepth ),.ArrL(dispLevel),.isRetIndex(0),.levelIdx(-3),.pipeInterval(999))minL_m
			(clk,en,SGMInfo[gri],minL,ZZZIdx_);
			
			reg [SGMDataDepth*(dispLevel)-1:0]SGMInfo_delay;
			always@(posedge clk)if(en)SGMInfo_delay=SGMInfo[gri];
			
			ArrayAddSubValue
			#(.dataW(SGMDataDepth),.ArrL(dispLevel),.Add1_Sub0(0)) AAS
			(SGMInfo_delay,minL,SGMInfo_sm[gri]);*/
			
			
			wire [SGMDataDepth_reduce-1:0]minL;
			wire [SGMDataDepth_reduce*(dispLevel)-1:0]SGMInfo_reduce;
			ArrayEleWidthReduce #(.dataIn_depth(SGMDataDepth),.dataOut_depth(SGMDataDepth_reduce),.ArrL(32))MEWR
			(SGMInfo[gri],SGMInfo_reduce);
			
			getMinIdx  #(.data_depth(SGMDataDepth_reduce ),.ArrL(dispLevel),.isRetIndex(0),.levelIdx(-1),.pipeInterval(2))minL_m
			(clk,1,SGMInfo_reduce,minL,ZZZIdx_);
			reg [SGMDataDepth*(dispLevel)-1:0]SGMInfo_delay;
			always@(posedge clk)if(en)SGMInfo_delay=SGMInfo[gri];
			wire [SGMDataDepth-1:0]minLEx=minL;
			ArrayAddSubValue
			#(.dataW(SGMDataDepth),.ArrL(dispLevel),.Add1_Sub0(0)) AAS
			(SGMInfo_delay,minLEx,SGMInfo_sm_middle[gri]);
			
			
			
			/*wire [SGMDataDepth_reduce-1:0]minL;
			wire [SGMDataDepth_reduce*(dispLevel)-1:0]SGMInfo_reduce;
			ArrayEleWidthReduce #(.dataIn_depth(SGMDataDepth),.dataOut_depth(SGMDataDepth_reduce),.ArrL(32))MEWR
			(SGMInfo[gri],SGMInfo_reduce);
			getMinIdx  #(.data_depth(SGMDataDepth_reduce ),.ArrL(dispLevel),.isRetIndex(0),.levelIdx(-3),.pipeInterval(999))minL_m
			(clk,en,SGMInfo_reduce,minL,ZZZIdx_);
			reg [SGMDataDepth*(dispLevel)-1:0]SGMInfo_delay;
			always@(posedge clk)if(en)SGMInfo_delay=SGMInfo[gri];
			
			wire [SGMDataDepth-1:0]minLEx=minL;
			ArrayAddSubValue
			#(.dataW(SGMDataDepth),.ArrL(dispLevel),.Add1_Sub0(0)) AAS
			(SGMInfo_delay,minLEx,SGMInfo_sm[gri]);*/
		end
		
		for(gri=0;gri<dispLevel;gri=gri+1)
		begin
		//wire [SGMDataDepth*(dispLevel)-1:0]SGMInfo_sm_middle[LSGMDirs-1:0];
			
			
			wire[SGMDataDepth_branch_reduce-1:0]Lr0=
			SGMInfo_sm_middle[0][(gri+1)*SGMDataDepth-1-:SGMDataDepth_branch_reduce];
			wire[SGMDataDepth_branch_reduce-1:0]Lr1=
			SGMInfo_sm_middle[1][(gri+1)*SGMDataDepth-1-:SGMDataDepth_branch_reduce];
			wire[SGMDataDepth_branch_reduce-1:0]Lr2=
			SGMInfo_sm_middle[2][(gri+1)*SGMDataDepth-1-:SGMDataDepth_branch_reduce];
			wire[SGMDataDepth_branch_reduce-1:0]Lr3=
			SGMInfo_sm_middle[3][(gri+1)*SGMDataDepth-1-:SGMDataDepth_branch_reduce];
			
			
			wire[SGMDataDepth_branch_reduce-1:0]max0t;
			wire[SGMDataDepth_branch_reduce-1:0]max1t;
			wire[SGMDataDepth_branch_reduce-1:0]max2t;
			wire[SGMDataDepth_branch_reduce-1:0]max3t;
			getMaxIdx  #(.data_depth(SGMDataDepth_branch_reduce),.ArrL(3),.isRetIndex(0))MAX0
			(clk,1,{Lr3,Lr0,Lr1},max0t,ZZZmax0);
			
			getMaxIdx  #(.data_depth(SGMDataDepth_branch_reduce),.ArrL(3),.isRetIndex(0))MAX1
			(clk,1,{Lr0,Lr1,Lr2},max1t,ZZZmax1);
			
			getMaxIdx  #(.data_depth(SGMDataDepth_branch_reduce),.ArrL(2),.isRetIndex(0))MAX2
			(clk,1,{Lr1,Lr2},max2t,ZZZmax2);
			
			getMaxIdx  #(.data_depth(SGMDataDepth_branch_reduce),.ArrL(2),.isRetIndex(0))MAX3
			(clk,1,{Lr3,Lr0},max3t,ZZZmax3);
			
			wire[SGMDataDepth-1:0]max0=max0t<<(SGMDataDepth-SGMDataDepth_branch_reduce);
			wire[SGMDataDepth-1:0]max1=max1t<<(SGMDataDepth-SGMDataDepth_branch_reduce);
			wire[SGMDataDepth-1:0]max2=max2t<<(SGMDataDepth-SGMDataDepth_branch_reduce);
			wire[SGMDataDepth-1:0]max3=max3t<<(SGMDataDepth-SGMDataDepth_branch_reduce);
			
			assign SGMInfo_sm[0][gri*SGMDataDepth+:SGMDataDepth]=(Lr0*7+max0)>>3;
			assign SGMInfo_sm[1][gri*SGMDataDepth+:SGMDataDepth]=(Lr1*7+max1)>>3;
			assign SGMInfo_sm[2][gri*SGMDataDepth+:SGMDataDepth]=(Lr2*7+max2)>>3;
			assign SGMInfo_sm[3][gri*SGMDataDepth+:SGMDataDepth]=(Lr3*7+max3)>>3;
			
		
		end
		/*wire [SGMDataDepth-1:0]minL3;
		getMinIdx  #(.data_depth(SGMDataDepth ),.ArrL(dispLevel),.isRetIndex(0))minL_m
			(clk,en,SGMInfo[3],minL3,ZZZIdx_);
		ArrayAddSubValue
			#(.dataW(SGMDataDepth),.ArrL(dispLevel),.Add1_Sub0(0)) AAS
			(SGMInfo[3],minL3,SGMInfo_sm[3]);	*/
		
	endgenerate
	
	
	
	
	
	always@(posedge clk)begin 
		if(en)begin
			
		
			SGMInfo_tmp_d0  <=SGMInfo_sm[0];
			SGMInfo_in0_reg<=SGMInfo_tmp_d0;
			SGMInfo_in1_reg<=SGMInfo_sm[1];
			//SGMInfo_in3_reg<=SGMInfo_sm[3];
			
			
			
			
		end
	end
	reg[10-1:0]addra_bramR;
	always@(posedge clk)begin 
		if(en)begin
		//addra_bramR:from 0~ImageW-3==> store ImageW-2 data
			if(addra_bramR==ImageW-1-2-1-1)//we need video_width-1 delay (ImageW-1-1 -1) the extra -1 is because we need one clock to send data to RAM
			addra_bramR=0;
			else
			addra_bramR=addra_bramR+1;
		end
	end
	generate
		for(gdi=0;gdi<dispLevel;gdi=gdi+1)
		begin
			blkRAM_W18D639 ShiftRegWd1(
			.clka(clk),
			.ena(en),
			.wea(~0),
			.addra(addra_bramR),
			.dina({
			
			SGMInfo_in[0][gdi*SGMDataDepth+:SGMDataDepth],
			SGMInfo_in[1][gdi*SGMDataDepth+:SGMDataDepth],
			SGMInfo_in[2][gdi*SGMDataDepth+:SGMDataDepth]
			}),
			.douta({
			SGMInfo_shiftOut[0][gdi*SGMDataDepth+:SGMDataDepth],
			SGMInfo_shiftOut[1][gdi*SGMDataDepth+:SGMDataDepth],
			SGMInfo_shiftOut[2][gdi*SGMDataDepth+:SGMDataDepth]
			}
			)
			); 
			
		end
	endgenerate
	
	
	parameter SGMDataAggreDepth=SGMDataDepth+$clog2(LSGMDirs);//4 data Aggregate=> extend 2 bits
	wire [(SGMDataAggreDepth)*(dispLevel)-1:0]SGMInfoAggre;

	
	generate
		for(gdi=0;gdi<dispLevel;gdi=gdi+1)
		begin:SGMLoop
			reg [6-1:0]P1_reg,P2_reg;
			reg [censusVecW-1:0]LineData_reg;
			reg [censusVecW-1:0]PixData_reg;
			always@(posedge clk)begin 
				if(en)begin
					LineData_reg=LineData[gdi*censusVecW+:censusVecW];
					PixData_reg=PixData;
				
					P1_reg=P1;
					P2_reg=P2;
				end
			end
			
			
			wire [censusVecW-1:0]censusDiff;
			assign censusDiff=LineData_reg^PixData_reg;

			wire [SGMDataDepth-1:0]pixDiffGate=(IsOnEdge)?0:~0;

			wire [$clog2(censusVecW):0]pixDiff_;
			reg [$clog2(censusVecW)-2:0]pixDiff;
			AdderTree#(.data_depth(1),.ArrL(censusVecW)) ATL(censusDiff,pixDiff_);
			
			/*
			calculate Lr(p,d)=SGMInfo[r]=Cr(p,d)+Cs'
			
			Cs'=Cs-min(Lr(p-r,d))
			calculate Lr'=SGMInfo[gri]=Lr-minLr=
			*/
			
			for(gri=0;gri<LSGMDirs;gri=gri+1)begin//
				wire [SGMDataDepth-1:0]Cs_;
				reg [SGMDataDepth-1:0]Cs;
				if(gdi==0)
					getMinIdx  #(.data_depth(SGMDataDepth),.ArrL(3),.isRetIndex(0))Cs
					(clk,en,
					{SGMInfo_shiftOut[gri][gdi*SGMDataDepth+:SGMDataDepth],
					SGMInfo_shiftOut[gri][(gdi+1)*SGMDataDepth+:SGMDataDepth]+P1_reg,
					P2_reg
					},Cs_,ZZZCsIndex);
				else if(gdi==dispLevel-1)
					getMinIdx  #(.data_depth(SGMDataDepth),.ArrL(3),.isRetIndex(0))Cs
					(clk,en,
					{SGMInfo_shiftOut[gri][gdi*SGMDataDepth+:SGMDataDepth],
					SGMInfo_shiftOut[gri][(gdi-1)*SGMDataDepth+:SGMDataDepth]+P1_reg,
					P2_reg
					},Cs_,ZZZCsIndex);
				else
					getMinIdx  #(.data_depth(SGMDataDepth),.ArrL(4),.isRetIndex(0))Cs0S
					(clk,en,
					{SGMInfo_shiftOut[gri][gdi*SGMDataDepth+:SGMDataDepth],
					SGMInfo_shiftOut[gri][(gdi-1)*SGMDataDepth+:SGMDataDepth]+P1_reg,
					SGMInfo_shiftOut[gri][(gdi+1)*SGMDataDepth+:SGMDataDepth]+P1_reg,
					P2_reg
					},Cs_,ZZZCsIndex);
					
				always@(posedge clk)if(en)begin
					Cs=Cs_;
					pixDiff=(pixDiff_>>1);
				end
				assign SGMInfo[gri][gdi*SGMDataDepth+:SGMDataDepth]=
					pixDiffGate&(pixDiff+Cs);
			end
			assign SGMInfoAggre[gdi*SGMDataAggreDepth+:SGMDataAggreDepth]=
			SGMInfo[0][gdi*SGMDataDepth+:SGMDataDepth]+
			SGMInfo[1][gdi*SGMDataDepth+:SGMDataDepth]+
			SGMInfo[2][gdi*SGMDataDepth+:SGMDataDepth]+
			SGMInfo[3][gdi*SGMDataDepth+:SGMDataDepth];
		end
	endgenerate
	
	
	
	wire [$clog2(dispLevel):0]MinDataIdx_;
	assign disparity=MinDataIdx_;
	reg [(SGMDataAggreDepth)*(dispLevel)-1:0]SGMInfoAggreReg;//pipe stage 2
	always@(posedge clk)
		if(en)SGMInfoAggreReg=SGMInfoAggre;
	
	wire [SGMDataAggreDepth-1:0]MinData;
	
	getMinIdx  #(.data_depth(SGMDataAggreDepth),.ArrL(dispLevel),.pipeInterval(3))gMI
	(clk,en,
      SGMInfoAggreReg,
      MinData,MinDataIdx_
   );

endmodule




