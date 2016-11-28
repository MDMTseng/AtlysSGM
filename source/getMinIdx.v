module getMinIdx
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
           output [data_depth-1:0]MinData,
           output [IdxDept-1:0]MinDataIdx
       );
	   localparam 
				IdxDept=10;
	wire  [data_depth-1:0]min1;
   wire [IdxDept-1:0]minIdx1;
	wire  [data_depth-1:0]min2;
   wire [IdxDept-1:0]minIdx2;
   wire [IdxDept-1:0]offSetw=IdxOffSet;
   wire [IdxDept-1:0]ArrLw=ArrL;
	
	
	generate 
		localparam Sp1=ArrL/2;
		localparam Sp2=ArrL-Sp1;
		if(Sp1==1)
		begin
			assign min1=DIn[0+:data_depth];
			assign minIdx1=IdxOffSet;
			
		end
		else
		begin
			getMinIdx #(.data_depth(data_depth),.ArrL(Sp1),.IdxOffSet(IdxOffSet),.isRetIndex(isRetIndex),.pipeInterval(pipeInterval),.levelIdx(levelIdx+1))
			GMI1(clk,en,DIn[0+:Sp1*data_depth],min1,minIdx1);
		
		end
		if(Sp2==1)
		begin
			assign min2=DIn[Sp1*data_depth+:data_depth];
			assign minIdx2=IdxOffSet+Sp1;
			
		end
		else
		begin
			getMinIdx #(.data_depth(data_depth),.ArrL(Sp2),.IdxOffSet(IdxOffSet+Sp1),.isRetIndex(isRetIndex),.pipeInterval(pipeInterval),.levelIdx(levelIdx+1))
			GMI2(clk,en,DIn[Sp1*data_depth+:Sp2*data_depth],min2,minIdx2);
		
		end
	endgenerate
	
	
	reg [data_depth-1:0]MinData_;
   reg [IdxDept-1:0]MinDataIdx_;
	always@(*)
	begin
		if(min2<min1)
		begin
			MinData_=min2;
			MinDataIdx_=minIdx2;
		end
		else
		begin
			MinData_=min1;
			MinDataIdx_=minIdx1;
		end
	
	end
	
	
	localparam IsNotAStage=(pipeInterval==0)?1:levelIdx%pipeInterval!=0;
	generate//choose pipeline or not
		if(IsNotAStage)begin
		
			if(isRetIndex)assign MinDataIdx=MinDataIdx_;
			assign MinData=MinData_;
		end else begin
			reg [data_depth-1:0]MinData_reg;
			reg [IdxDept-1:0]MinDataIdx_reg;
			always@(posedge clk)if(en)begin
				MinDataIdx_reg<=MinDataIdx_;
				MinData_reg<=MinData_;
			end
			if(isRetIndex)assign MinDataIdx=MinDataIdx_reg;
			assign MinData=MinData_reg;
		end
	
	endgenerate

endmodule
