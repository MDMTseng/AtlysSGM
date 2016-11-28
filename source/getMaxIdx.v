module getMaxIdx
       #(parameter
           data_depth=8,
           ArrL = 4,
           IdxOffSet=0,
			  isRetIndex=1,
			  
			  pipeInterval=0,
			  levelIdx=0
       )(
			  input clk,input en,
           input [data_depth*ArrL-1:0]DIn,
           output [data_depth-1:0]MaxData,
           output [IdxDept-1:0]MaxDataIdx
       );
	   localparam 
				IdxDept=10;
	wire  [data_depth-1:0]max1;
   wire [IdxDept-1:0]maxIdx1;
	wire  [data_depth-1:0]max2;
   wire [IdxDept-1:0]maxIdx2;
   wire [IdxDept-1:0]offSetw=IdxOffSet;
   wire [IdxDept-1:0]ArrLw=ArrL;
	
	
	generate 
		localparam Sp1=ArrL/2;
		localparam Sp2=ArrL-Sp1;
		if(Sp1==1)
		begin
			assign max1=DIn[0+:data_depth];
			assign maxIdx1=IdxOffSet;
			
		end
		else
		begin
			getMaxIdx #(.data_depth(data_depth),.ArrL(Sp1),.IdxOffSet(IdxOffSet),.isRetIndex(isRetIndex),.pipeInterval(pipeInterval),.levelIdx(levelIdx+1))
			GMI1(clk,en,DIn[0+:Sp1*data_depth],max1,maxIdx1);
		
		end
		if(Sp2==1)
		begin
			assign max2=DIn[Sp1*data_depth+:data_depth];
			assign maxIdx2=IdxOffSet+Sp1;
			
		end
		else
		begin
			getMaxIdx #(.data_depth(data_depth),.ArrL(Sp2),.IdxOffSet(IdxOffSet+Sp1),.isRetIndex(isRetIndex),.pipeInterval(pipeInterval),.levelIdx(levelIdx+1))
			GMI2(clk,en,DIn[Sp1*data_depth+:Sp2*data_depth],max2,maxIdx2);
		
		end
	endgenerate
	
	
	reg [data_depth-1:0]MaxData_;
   reg [IdxDept-1:0]MaxDataIdx_;
	always@(*)
	begin
		if(max2>max1)
		begin
			MaxData_=max2;
			MaxDataIdx_=maxIdx2;
		end
		else
		begin
			MaxData_=max1;
			MaxDataIdx_=maxIdx1;
		end
	
	end
	
	
	localparam IsNotAStage=(pipeInterval==0)?1:levelIdx%pipeInterval!=0;
	generate//choose pipeline or not
		if(IsNotAStage)begin
		
			if(isRetIndex)assign MaxDataIdx=MaxDataIdx_;
			assign MaxData=MaxData_;
		end else begin
			reg [data_depth-1:0]MaxData_reg;
			reg [IdxDept-1:0]MaxDataIdx_reg;
			always@(posedge clk)if(en)begin
				MaxDataIdx_reg<=MaxDataIdx_;
				MaxData_reg<=MaxData_;
			end
			if(isRetIndex)assign MaxDataIdx=MaxDataIdx_reg;
			assign MaxData=MaxData_reg;
		end
	
	endgenerate

endmodule
