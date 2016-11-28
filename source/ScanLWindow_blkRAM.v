`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:44 02/08/2015 
// Design Name: 
// Module Name:    ScanLWindow_blkRAM 
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
module ScanLWindow_blkRAM(input clk,input enable,input [pixel_depth-1:0]inData,output reg[block_width*block_height*pixel_depth-1:0] Window);

	parameter block_width=1;
	parameter block_height=8;
	
	
	localparam pixel_depth=32;//fixed
	localparam frame_width=640;
	localparam RAMAccessSpace=frame_width-block_width;
	
	reg [10-1:0]addra_bramR;
	always@(posedge clk)
	begin
		if(enable)begin
			if(addra_bramR==RAMAccessSpace-2)
			addra_bramR=0;
			else
			addra_bramR=addra_bramR+1;
		end
	end
	
/*	

xxxxSSSRRRRRRRRRR
RRRRSSSRRRRRRRRRR
RRRRSSS

R: data in the RAM block(blkRAM_W32D640_SP)
S: data in the shift register(Window)
	
	
	

xxxx S S<S>RRRRRRRRRR
RRRR[S]S<S>RRRRRRRRRR
RRRR[S]S S


[?]: data saaign to RAMFEED[?].inRAMIf
<?>: data saaign to RAMFEED[?].outRAMIf

*/	
	localparam shiftRegSliceL=block_width*pixel_depth;
	
	genvar bri;
	generate
		for(bri=0;bri<block_height-1;bri=bri+1)begin:RAMFEED
			wire [pixel_depth-1:0]inRAMIf,outRAMIf;
			/*
			
			xxxx S S<S>RRRRRRRRRR
			RRRR[S]S<S>RRRRRRRRRR
			RRRR[@]S S

			Window= {S S <S> [S] S <S> [@] S S}
			[@] presents inRAMIf at bri=1
			*/
			assign inRAMIf=Window[(bri+1)*shiftRegSliceL-1-:pixel_depth];
			blkRAM_W32D640_SP RAM(
			.clka(clk),
			.ena(enable),
			.wea(~0),
			.addra(addra_bramR),
			.dina(inRAMIf),
			.douta(outRAMIf)
			);
			
		end
	endgenerate
	
	
	integer i;
	always@(posedge clk)begin
		if(enable)for(i=0;i<block_height;i=i+1)begin
			if(i==0)
				Window[i*shiftRegSliceL+:shiftRegSliceL]={Window[i*shiftRegSliceL+:shiftRegSliceL],inData};
			else
				Window[i*shiftRegSliceL+:shiftRegSliceL]={Window[i*shiftRegSliceL+:shiftRegSliceL],RAMFEED[i-1].outRAMIf};
		
		end
		
	end
	

endmodule
