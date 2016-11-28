module SPI_slave
#(
parameter
baseDepth=8,
IODepth=baseDepth

)
(input fclk,input sck,input css,input mosi,output miso,
input [IODepth-1:0]dat_o,output [IODepth-1:0]dat_i,output [IODepth-1:0]ndat_i,output sck_posedge,output  accep_dat_o,output  rdy,output  prerdy);
	
	/*reg [IODepth-1:0]RSReg;
	reg [IODepth-1-1:0]WSReg;
	assign dat_i=RSReg;
	assign miso=(spiDataCount)?WSReg[IODepth-1-1]:dat_o[IODepth-1];
	reg [2:0]spiDataCount;//0~7
	reg pre_sck;
	
	reg startF;
	assign accep_dat_o=(spiDataCount==0);
	assign rdy=(accep_dat_o&startF);
	assign prerdy=(spiDataCount==7&startF);
	
	wire _css=~css;
	always@(posedge sck,posedge _css)
	begin
		
		if(_css)begin
			startF<=0;
			spiDataCount<=0;
		end
		else
		begin
			startF<=1;
			spiDataCount<=spiDataCount+1;
			RSReg<={RSReg,mosi};
		end
	end
	
	always@(posedge sck,posedge _css)
	begin
		if(_css|(spiDataCount==0))
			WSReg<=dat_o;
		else
			WSReg<={WSReg,1'b0};
	end*/
	
	/*always@(posedge clk)
	if(css)begin
		pre_sck<=sck;
		if((!pre_sck)&sck)//sck posedge
		begin
			startF<=1;
			spiDataCount<=spiDataCount+1;
			RSReg<={RSReg,mosi};
			WSReg<={WSReg,1'b0};
		end
		else
		if(spiDataCount==0)
			WSReg<=dat_o;
	end
	else
	begin
		startF<=0;
		WSReg<=dat_o;
		spiDataCount=0;
	end*/
	
	reg [IODepth-1:0]RSReg;
	reg [IODepth-1-1:0]WSReg;
	
	wire [IODepth-1:0]nRSReg={RSReg,mosi};
	assign dat_i=RSReg;
	
	assign ndat_i=nRSReg;
	assign miso=(spiDataCount[0])?dat_o[IODepth-1]:WSReg[IODepth-1-1];
	reg [IODepth-1:0]spiDataCount;//0~7
	reg pre_sck;
	
	reg startF;
	assign accep_dat_o=(spiDataCount[0]);
	assign rdy=(accep_dat_o&startF);
	assign prerdy=(spiDataCount[IODepth-1]);
	
	
	reg presck,prepresck;
	always@(posedge fclk)
		presck<=sck;
	always@(posedge fclk)
		prepresck<=presck;
	
	assign sck_posedge=presck&~prepresck;
	
	always@(posedge fclk,negedge css)
	begin
		
		if(~css)begin
			startF<=0;
			spiDataCount<=1;
			WSReg<=dat_o;
		end
		else if(sck_posedge)
		begin
			startF<=1;
			spiDataCount<={spiDataCount,spiDataCount[IODepth-1]};
			RSReg<=nRSReg;
			
			if(spiDataCount[0])
				WSReg<=dat_o;
			else
				WSReg<={WSReg,1'b0};
		end
	end
	
endmodule
