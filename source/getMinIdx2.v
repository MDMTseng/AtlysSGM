module getMinIdx2
       #(parameter
           data_depth=8,
           ArrL = 4,
           IdxOffSet=0
       )(
           input [data_depth*ArrL-1:0]DIn,
           output reg [data_depth-1:0]MinData,
           output reg [IdxDept-1:0]MinDataIdx
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
			getMinIdx #(.data_depth(data_depth),.ArrL(Sp1),.IdxOffSet(IdxOffSet))
			GMI1(DIn[0+:Sp1*data_depth],min1,minIdx1);
		
		end
		if(Sp2==1)
		begin
			assign min2=DIn[Sp1*data_depth+:data_depth];
			assign minIdx2=IdxOffSet+Sp1;
			
		end
		else
		begin
			getMinIdx #(.data_depth(data_depth),.ArrL(Sp2),.IdxOffSet(IdxOffSet+Sp1))
			GMI2(DIn[Sp1*data_depth+:Sp2*data_depth],min2,minIdx2);
		
		end
	endgenerate
	
	always@(*)
	begin
		if(min2<min1)
		begin
			MinData=min2;
			MinDataIdx=minIdx2;
		end
		else
		begin
			MinData=min1;
			MinDataIdx=minIdx1;
		end
	
	end


endmodule