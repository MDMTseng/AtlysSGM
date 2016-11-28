
module frameBuff
#(
	parameter pixel_dept=5,
	parameter frame_w=100,
	parameter frame_h=100,
	parameter window_w=10,
	parameter window_h=10,
	
	parameter windowSize=(window_w*window_h*pixel_dept)
	)
(input pclk,input rst,input en,input [pixel_dept-1:0]inData,output [pixel_dept-1:0]outData,
output [windowSize-1:0] f1win,output [windowSize-1:0] f2win
);
	
	
	
	
	parameter buffRegSize=(frame_w*(frame_h+window_h-1)+window_w)*pixel_dept;
	
	reg [buffRegSize-1:0] buffReg;
	
	genvar i;
	generate
		for(i = 0; i <window_h ; i = i + 1) begin : array//i=h~1
			assign f1win[windowSize-1-pixel_dept*window_w*i-:pixel_dept*window_w]
			 =buffReg[buffRegSize-1-pixel_dept*frame_w*i-:pixel_dept*window_w];
			
			assign f2win[windowSize-1-pixel_dept*window_w*i-:pixel_dept*window_w]
			 =buffReg[buffRegSize-frame_w*frame_h*pixel_dept
			 -1-pixel_dept*frame_w*i-:pixel_dept*window_w];
		end
	endgenerate
	assign outData=buffReg[frame_w*frame_h*pixel_dept-1-:pixel_dept];
	//Shift register
	always@(posedge pclk)
	begin
		if(rst)
			buffReg<=0;
		else if(en)
			buffReg<={buffReg,inData};
		else
			buffReg<=buffReg;
	end

endmodule
