module ShiftReg_window(input clk,input enable,input [pixel_depth-1:0]inData,output[block_width*block_height*pixel_depth-1:0] Window);
/*
Simply using shift register to achieve window extraction
EX:
for a width=10, window_W=3, window_H=3
we need shift register in length (window_H-1)*width+window_W=23
shift registerd data as below from 01 to 23

|01 02 03|04 05 06 07 08 09 10
|11 12 13|14 15 16 17 18 19 10
|01 22 23|

the window as below
01 02 03
11 12 13
01 22 23

**if we push one more pixel (24) in **
XX|02 03 04|05 06 07 08 09 10
11|12 13 14|15 16 17 18 19 10
01|22 23 24|
(XX) means discard data

the window will be
02 03 04
12 13 14
22 23 24


**if we push one more pixel (25) in **
XX XX|03 04 05|06 07 08 09 10
11 12|13 14 15|16 17 18 19 10
01 22|23 24 25|

the window will be
03 04 05
13 14 15
23 24 25


The window moves along with data push in
*/
	parameter pixel_depth=7;
	parameter frame_width=640;
	parameter block_width=1;
	parameter block_height=8;
	
	parameter shiftRegSize=pixel_depth*((block_height-1)*frame_width+block_width);
	
	//Window extraction
	 genvar i,j;
	 generate
		for(i = 0; i < block_height; i = i + 1) begin : array
		  for(j = 0; j < block_width; j = j + 1) begin : vector
			 assign Window[pixel_depth*(i * block_width + j)+:pixel_depth] = 
				shiftReg[pixel_depth*(i*frame_width+j)+:pixel_depth];
		  end
		end
	 endgenerate
	
	reg[shiftRegSize-1:0] shiftReg;
	
	
	//Shift register
	always@(posedge clk)
	begin
		if(enable)
			shiftReg<={shiftReg,inData};
	end

endmodule
