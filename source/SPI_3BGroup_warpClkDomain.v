`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:22:15 02/12/2015 
// Design Name: 
// Module Name:    SPI_3BGroup_warpClkDomain 
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
module SPI_3BGroup_warpClkDomain
#(
parameter 

 ByteNum=3

)

(

input spiCLK,//data in spiCLK domain
input css,
input[8-1:0]dat_i,
input spi_rdy,
input spi_prerdy,	

input clk,
output groupRdy,	//data in clk domain
output [ByteNum*8:1]outGroupDat
    );
	  /*
	 
	reg [ByteNum*8-1:0]dat_G;
	reg prespi_rdy,preprespi_rdy;
	reg spi_readPulse,spi_readPulse_;
	reg [$clog2(ByteNum):0]spi_readGroupCounter;
	wire spi_readGroupGate=(spi_readGroupCounter==ByteNum-1);
	reg spi_readGroupPulse;
	assign spi_DatRdy=spi_readGroupPulse;
	assign groupRdy=spi_readGroupPulse;
	assign outGroupDat=dat_G;
	
	
		
	wire [ByteNum*8-1:0]dat_Pix=dat_G;
	always@(posedge clk)begin
		prespi_rdy<=spi_rdy;
		preprespi_rdy<=prespi_rdy;
		spi_readPulse<=(~preprespi_rdy&prespi_rdy);
	
		if(~css||spi_readGroupCounter==ByteNum)spi_readGroupCounter<=0;
		else if(spi_readPulse)spi_readGroupCounter<=spi_readGroupCounter+1;
		
		spi_readGroupPulse<=spi_readGroupGate&spi_readPulse;
		
		if(spi_readPulse)dat_G<={dat_G,dat_i};
	end
	*/
	reg [ByteNum*8-1:0]dat_G;
	reg prespi_rdy,preprespi_rdy;
	reg [ByteNum-1:0]spi_readGroupCounter;
	reg spi_readGroupPulse;
	assign spi_DatRdy=spi_readGroupPulse;
	assign groupRdy=spi_readGroupPulse;
	assign outGroupDat=dat_G;
	
	
		
	wire [ByteNum*8-1:0]dat_Pix=dat_G;
	
	always@(posedge clk)
		if(~css)spi_readGroupCounter<=1;
		else if(spi_readPulse)spi_readGroupCounter<={spi_readGroupCounter,spi_readGroupCounter[ByteNum-1]};
	
	wire spi_readGroupGate=spi_readGroupCounter[ByteNum-1];
	
	reg spi_readPulse;
	always@(posedge clk)begin
	
		
		prespi_rdy<=spi_rdy;
		preprespi_rdy<=prespi_rdy;
		spi_readPulse<=(~preprespi_rdy&prespi_rdy);
	 
		
		spi_readGroupPulse<=spi_readGroupGate&spi_readPulse;
		
		if(spi_readPulse)dat_G<={dat_G,dat_i};
	end

endmodule
