`timescale 1ns / 1ps

`define MAXVALUE_WIDTH(MAXVALUE) ($clog2(MAXVALUE)+(((2**$clog2(MAXVALUE))==MAXVALUE)?0:1))
module hijacker
#(parameter
CameraDataDepth=16,//Data from camera
//Set the width parameter for window extraction module
ImageW=640,
ImageH=480,

dispLevel=32, //32
DataDepth=16,
SGMDataDepth=6
)
(
	 input fclk,
	 input clk1,
	 input clk2,
	 
	 input CamADV,
	 input FbWrARst,
	 input CamBDV,
	 input FbWrBRst,
	 
	  
    input [CameraDataDepth-1:0] DI1,
    input [CameraDataDepth-1:0] DI2,
    input [CameraDataDepth-1:0] DIx,
    output [CameraDataDepth-1:0] DO1,
    output [CameraDataDepth-1:0] DO2,
	 output [7:0]LED_O,
	 input [7:0]SW_I,
	 output [7:0]IO_O,
	 
	 
	 input sck,input css,input mosi,inout miso,
	 output spi_DatRdy,output spi_ScreenRst
    );
	 wire miso_;
	 
	 reg misoGate;
	wire mosi;
	 assign miso = (misoGate) ? miso_ : 1'bz;
	 
	 wire clk_p=clk2;
	 always@(posedge clk_p)misoGate<=css;
	 
	 
	reg [8-1:0]SaData[7:0];
	 
	
	wire [8-1:0]dat_i;
	wire [8-1:0]ndat_i;
	wire spi_rdy;
	wire spi_prerdy;
	
	wire sck_posedge;
	reg [8-1:0]feedData;
	

	
	
	SPI_slave SPI_S1(clk_p,sck,css, mosi,miso_,
	feedData,dat_i,ndat_i,sck_posedge,accep_dat_o,spi_rdy,spi_prerdy
	);
	
	reg[8*6-1:0]dataG;
	wire SPIByteRdy=sck_posedge&spi_prerdy;
	
	reg enD;
	always@(posedge clk_p)begin//sec for data shift counter 1, 2, 4 
		enD<=SPIByteRdy&Pix_C[5];
	end
	
	
	wire en_p=(SaData[2]==0)?CamBDV:enD;//enD;
	assign spi_DatRdy=en_p;
	wire rst_p=(SaData[2]==0)?FbWrBRst:spi_ScreenRst;
	
	
	always@(posedge clk_p)begin//sec for data shift counter 1, 2, 4 
		if(SPIByteRdy)dataG<={dataG,ndat_i};
	end
	
	reg [2:0]SPI_C;
	always@(posedge clk_p,negedge css)begin//sec for data shift counter 1, 2, 4 
		if(~css)SPI_C<=1;
		else if(SPIByteRdy)SPI_C<={SPI_C,SPI_C[2]};
	end
	
   reg [5:0]Pix_C;
	always@(posedge clk_p,negedge KGate)begin//sec for data shift counter 1, 2, 4 
		if(~KGate)Pix_C<=1;
		else if(SPIByteRdy)Pix_C<={Pix_C,Pix_C[5]};
	end
	
	reg [8*6-1:0]dat_PixK;
	always@(posedge clk_p)begin//sec for data shift counter 1, 2, 4 
		if(SPIByteRdy&Pix_C[5])dat_PixK<={dataG,ndat_i};
	end
	
	/*
	wire clk_p=clk1;
	wire en_p=CamADV;
	wire rst_p=FbWrARst;*/
	
	always@(posedge clk_p,negedge css)begin
		if(~css) KGate=0;
		else if(SPIByteRdy)begin//new spi data byte comes in
			if(KGate)begin
				feedData=spiRet;
			end
			else begin
				feedData=8'hff;
				
				if(SPI_C[1])begin//receive 2 datas 1st data=dat_Pix[0+:8],2nd data=preData , usually for return data 
					if(dataG[0+:8]==16'h81)
						feedData=SaData[ndat_i];
				end
				else if(SPI_C[2])begin//receive 3 datas 1st data=dat_Pix[8+:8],2nd data=dat_Pix[0+:8] 3rd data at , usually for accept data 
					case(dataG[8+:8])
					8'h80:
						SaData[dataG[0+:8]]=ndat_i;
					8'h55:
						KGate=1;
					8'h40:
						spi_ScreenRst=0;
					8'h41:
						spi_ScreenRst=1;
					default:
						KGate=0;
					endcase
				
				end
			end
		end
	end
	
	
	assign LED_O={Pix_C,KGate,spi_ScreenRst};
	
	
	reg KGate,spi_ScreenRst;
	
	
	
	wire [10:0]pixX;
	wire [10:0]pixY;
	parameter dispLevelDataW=`MAXVALUE_WIDTH(dispLevel);
	reg [dispLevelDataW-1:0]FinalDisp;
	reg [dispLevelDataW-1:0]DispL;
	reg [8:0]spiRet;//=MinDataIdx;
	
	wire [dispLevelDataW-1:0]dispRM;//After midian Filter
	wire [dispLevelDataW-1:0]dispLM;
	wire [dispLevelDataW-1:0]dispFM;//
	always@(*)
	begin
		case(SaData[0])
		 0:spiRet<=MinDataIdx*(256/dispLevel);
		 1:spiRet<=FinalDisp*(256/dispLevel);
		 
		 2:spiRet<=dat_PixK[16+:8];
		 3:spiRet<=dat_PixK[40+:8];
		// 3:spiRet<=DIxL;
		 //4:spiRet<=(DIxL==0)?0:255;
		 5:spiRet<=(pixX>pixY)?pixX:pixY;
		 default:spiRet<=0;
		 endcase
	
	end
	
	wire [DataDepth-1:0]ColorMean1=DI1[11+:5]+DI1[0+:5]+DI1[5+:6];//(DI1[11+:5]+DI1[0+:5]*2+DI1[5+:6]*2);
	wire [DataDepth-1:0]ColorMean2=DI2[11+:5]+DI2[0+:5]+DI2[5+:6];//(DI2[11+:5]+DI2[0+:5]*2+DI2[5+:6]*2);
	
	wire [DataDepth-1:0]DI2r=(SaData[2]==0)?ColorMean2:{dat_PixK[24+23-:5],dat_PixK[24+15-:6],dat_PixK[24+7-:8]};//giv full bit of blue
	
	 
	wire [DataDepth-1:0]DI1r=(SaData[2]==0)?ColorMean1:{dat_PixK[23-:5],dat_PixK[15-:6],dat_PixK[7-:8]};//may kick off red
	
	
	
	wire[8-1:0]OR,OG,OB;
	ColorTranse(spiRet,OR,OG,OB);
	assign DO2=(SW_I[7])?{OR[7-:5],OG[7-:6],OB[7-:5]}:DI2;//(pixX[0])?DIxL:DIxR;
	assign DO1=(SW_I[7])?((pixY[3])?DI1:DI2):DI1;
	//assign DO1={ColorMean2[6-:5],ColorMean1[6-:6],ColorMean2[6-:5]};//(pixX[0])?DIxL:DIxR;
	
	//assign IO_O[7:4]={KGate,spi_DatRdy,css&sck,spi_prerdy};
	PixCoordinator # (.frameW(ImageW),.frameH(ImageH)) 
	Pc1(clk_p,en_p,rst_p,pixX,pixY);
	
	
	
	//  7x7 Census outfence window
localparam 
	censusWin=7,
	censusWinCenter=(censusWin-1)/2,
	censusEdgeThick=1,
	censusWinCenter_ArrPos=censusWinCenter*censusWin+censusWinCenter,
	censusVecW=4*(censusWin-censusEdgeThick)*censusEdgeThick;
	//4*(n(w-1)-2*sigma[1~n:k](k-1))=4*(n(w-1)- 2*((1+n)*n/2-n) )
	
	
	
	
	
	wire [censusWin*censusWin*32-1:0]W1;
	
	wire [censusWin*censusWin*32-1:0]W2=W1>>16;
	
	
	localparam grayW=8;
	ScanLWindow_blkRAM #(.block_height(censusWin),.block_width(censusWin)) win1(clk_p,en_p,{DI2r,DI1r},W1);
	
	integer winLi,winLj,winC,OnFenceCounter;
	
	/*
	07@@@@@
	1     @
	2     @
	3     @
	4     @
	5     @
	68@@@@@
	
	
	07E@@@@
	18F   @
	29    @
	3A    @
	4B    @
	5CG   @
	6DG@@@@
	*/
	reg [censusVecW*grayW-1:0]DIxLWin;
	reg [censusVecW*grayW-1:0]DIxRWin;
	always@(*)begin
		OnFenceCounter=0;
		for(winLj=0;winLj<censusWin;winLj=winLj+1)for(winLi=0;winLi<censusWin;winLi=winLi+1)
			if(winLi<censusEdgeThick||winLj<censusEdgeThick||winLi>=censusWin-censusEdgeThick||winLj>=censusWin-censusEdgeThick)begin
				winC=(winLi*censusWin+winLj)*32;
				DIxRWin[OnFenceCounter*grayW+:grayW]=W2[winC+:grayW];
				DIxLWin[OnFenceCounter*grayW+:grayW]=W1[winC+:grayW];
				OnFenceCounter=OnFenceCounter+1;
			end
	end
	
	
	wire [censusVecW-1:0]DIxL_,DIxR_;
	
	CensusVec #(.WinW(censusVecW),.dataInDepth(grayW),.skipIdx(999),.CVPadding(3)) CenV1(DIxLWin,W1[censusWinCenter_ArrPos*32+:grayW],DIxL_);
	CensusVec #(.WinW(censusVecW),.dataInDepth(grayW),.skipIdx(999),.CVPadding(3)) CenV2(DIxRWin,W2[censusWinCenter_ArrPos*32+:grayW],DIxR_);
	
	
	
	

	reg [censusVecW*(dispLevel)-1:0]PixShiftRegL_rev;
	reg [censusVecW*(dispLevel)-1:0]PixShiftRegR;
	wire [censusVecW-1:0]DIxL_h=PixShiftRegL_rev[censusVecW*(dispLevel)-censusVecW+:censusVecW];
	//this shift register has opposite direction as PixShiftRegR
	wire [censusVecW-1:0]DIxR_t=PixShiftRegR[censusVecW*(dispLevel)-censusVecW+:censusVecW];
	always@(posedge clk_p)if(en_p)begin 
		PixShiftRegL_rev<={DIxL_,PixShiftRegL_rev[censusVecW*(dispLevel)-1:censusVecW]};
		PixShiftRegR<={PixShiftRegR,DIxR_}; //DIxR_
	end//pipe stage 1


	wire IsOnEdge_=(pixX==0||pixY==0);//detect edge and reset SGM data
	reg IsOnEdge;
	reg [6-1:0]P1;
	reg [6-1:0]P2;
	always@(posedge clk_p) if(en_p)begin
		P1=SW_I[3:0];
		P2=P1*3;
		IsOnEdge=IsOnEdge_;
	end
	
	

	wire [dispLevelDataW-1:0]MinDataIdx;
	wire [dispLevelDataW-1:0]MinDataIdxR;
	SGMCore #(.censusVecW(censusVecW),.dispLevel(dispLevel),.SGMDataDepth(SGMDataDepth)) SGMCORE1(clk_p,en_p,
	PixShiftRegR,DIxL_h,
	IsOnEdge,
	P1,P2,
	MinDataIdx);
	
	
	
	/*SGMCore #(.censusVecW(censusVecW),.dispLevel(dispLevel),.SGMDataDepth(SGMDataDepth)) SGMCORE2(clk_p,en_p,
	PixShiftRegL_rev,DIxR_t,
	IsOnEdge,
	P1,P2,
	MinDataIdxR);*/
	
	//L/R Check
	/*integer i=0;
	
	reg [dispLevelDataW-1:0]DispR;
	reg [dispLevelDataW-1:0]DispLArr[dispLevel-1:0];
	
	wire [dispLevelDataW:0]RLCDiff=DispLArr[DispR]-DispR;
	wire [dispLevelDataW-1:0]ABS_RLCDiff=(RLCDiff[dispLevelDataW])?-RLCDiff:RLCDiff;
	
	always@(posedge clk_p) if(en_p)begin
		DispL<=MinDataIdx;
		DispR<=MinDataIdxR;
		DispLArr[0]<=MinDataIdx;
		for(i=1;i<dispLevel;i=i+1)DispLArr[i]<=DispLArr[i-1];
		
		
		FinalDisp<=(ABS_RLCDiff<4)?DispR:0;//simple filling
		
		//RLCDiff<=DispLArr[DispR]-DispR;
	end
	
	
	wire [3*3*32-1:0]disLW;
	wire [3*3*32-1:0]disRW=disLW>>dispLevelDataW;
	wire [3*3*32-1:0]disFW=disRW>>dispLevelDataW;
	
	
	ScanLWindow_blkRAM #(.block_height(3),.block_width(3)) win2(clk_p,en_p,{FinalDisp,MinDataIdxR,MinDataIdx},disLW);
	
	`define DWINS(A,I) A[(I)*32+:dispLevelDataW]
	
	
	midianFilter9 #(.dataW(dispLevelDataW),.pipeInterval(999)) mF1(
	clk_p,en_p,
	{
		`DWINS(disLW,0),`DWINS(disLW,1),`DWINS(disLW,2),
		`DWINS(disLW,3),`DWINS(disLW,4),`DWINS(disLW,5),
		`DWINS(disLW,6),`DWINS(disLW,7),`DWINS(disLW,8)
	}
	,dispLM);
	
	
	midianFilter9 #(.dataW(dispLevelDataW),.pipeInterval(999)) mF2(
	clk_p,en_p,
	{
		`DWINS(disRW,0),`DWINS(disRW,1),`DWINS(disRW,2),
		`DWINS(disRW,3),`DWINS(disRW,4),`DWINS(disRW,5),
		`DWINS(disRW,6),`DWINS(disRW,7),`DWINS(disRW,8)
	}
	,dispRM);
	
	midianFilter9 #(.dataW(dispLevelDataW),.pipeInterval(999)) mFF(
	clk_p,en_p,
	{
		`DWINS(disFW,0),`DWINS(disFW,1),`DWINS(disFW,2),
		`DWINS(disFW,3),`DWINS(disFW,4),`DWINS(disFW,5),
		`DWINS(disFW,6),`DWINS(disFW,7),`DWINS(disFW,8)
	}
	,dispFM);*/
endmodule
