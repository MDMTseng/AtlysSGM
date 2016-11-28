module comparitor#(
parameter 
dataW=8
)
(
input [dataW-1:0]din1,
input [dataW-1:0]din2,
output [dataW-1:0]max,
output [dataW-1:0]min
);
wire c=(din1>din2);
assign max=(c)?din1:din2;
assign min=(c)?din2:din1;

endmodule

module midianFilter9_internal
#(

parameter 
dataW=8,
level=0,
pipeLevel=0,
pipeInterval=0)
(
input clk,input en,
input [dataW*9-1:0]din,
output [dataW*9-1:0]dout
);
`define DE_(A,I,D) A[(I)*D+:D]
//`define din(A,I) `DE_(A,I,9)
//`define COMPA comparitor#(.dataW(dataW))


`define DIN(I) `DE_(din,I,dataW)
`define DOU(I) `DE_(dout,I,dataW)
wire [dataW*9-1:0]dout_tmp;

`define DOUT(I) `DE_(dout_tmp,I,dataW)
//parameter integer WIRING[4-1:0]= {1, 0, 0, 2};
wire [4*9-1:0]WIRING;
`define WIR(I) `DE_(WIRING,I,4)

wire [dataW*9-1:0]compOut;
wire [dataW*9-1:0]subModOut;
`define COM(I) `DE_(compOut,I,dataW)
`define SUBM(I) `DE_(subModOut,I,dataW)


localparam skipP=
(level==6)?0:
(level==5)?8:
(level==4)?8:
(level==3)?6:
(level==2)?0:0;
wire [5:0] ss=skipP;
localparam IsNotAStage=(pipeInterval==0)?1:pipeLevel%pipeInterval!=0;
generate

		
		genvar i;
		if(level==6)assign subModOut=din;
		else midianFilter9_internal #(.dataW(dataW),.level(level+1),.pipeInterval(pipeInterval),.pipeLevel(pipeLevel+1)) mi(clk,en,din,subModOut);
		assign `COM(skipP)=`SUBM(skipP);
		for(i=0;i<8;i=i+2)begin:compLoop
			if(i<skipP)
				comparitor#(.dataW(dataW))com
				(`SUBM(i),`SUBM(i+1),`COM(i),`COM(i+1));
			else
				comparitor#(.dataW(dataW))com
				(`SUBM(i+1),`SUBM(i+2),`COM(i+1),`COM(i+2));
		end
		
		if(level==6)begin
			assign dout_tmp=
			{
			`COM(7),`COM(6),`COM(4),`COM(5),`COM(3),
			`COM(8),`COM(1),`COM(2),`COM(0)
			};
		end else if(level==5)begin
			assign dout_tmp=
			{
			`COM(3),`COM(7),`COM(1),`COM(5),`COM(6),
			`COM(8),`COM(4),`COM(2),`COM(0)
			};
		end else if(level==4)begin
			assign dout_tmp=
			{
			`COM(8),`COM(4),`COM(7),`COM(5),`COM(1),
			`COM(3),`COM(6),`COM(2),`COM(0)
			};
		end else if(level==3)begin
			assign dout_tmp=
			{
			`COM(8),`COM(3),`COM(6),`COM(5),`COM(7),
			`COM(1),`COM(2),`COM(4),`COM(0)
			};
		end else if(level==2)begin
			assign dout_tmp=
			{
			`COM(8),`COM(6),`COM(7),`COM(5),`COM(4),
			`COM(2),`COM(3),`COM(1),`COM(0)
			};
		end else begin//1
			assign dout_tmp=
			{
			`COM(8),`COM(6),`COM(7),`COM(4),`COM(5),
			`COM(2),`COM(3),`COM(1),`COM(0)
			};
		end 
		
		if(IsNotAStage)
			assign dout=dout_tmp;
		else
		begin
			reg [dataW*9-1:0]dout_reg;
			
			assign dout=dout_reg;
			always@(posedge clk)if(en)begin
				dout_reg<=dout_tmp;
			end
		end
endgenerate

endmodule

module midianFilter9
#(

parameter 
dataW=8,
pipeLevel=0,
pipeInterval=0
)
(
input clk,input en,
input [dataW*9-1:0]din,
output [dataW-1:0]midian
);
	
	wire [dataW*9-1:0]subModOut;
	midianFilter9_internal#(.dataW(dataW),.level(1),.pipeInterval(pipeInterval),.pipeLevel(pipeLevel+1)) mi
	(clk,en,din,subModOut);
	
	wire [dataW-1:0]zzzOut;
	wire [dataW-1:0]midian_t;
`define DE_(A,I,D) A[(I)*D+:D]
`define SUBM(I) `DE_(subModOut,I,dataW)
	comparitor#(.dataW(dataW))com
	(`SUBM(4),`SUBM(5),midian_t,zzzOut);
	localparam IsNotAStage=(pipeInterval==0)?1:pipeLevel%pipeInterval!=0;
	generate//choose pipeline or not
		if(IsNotAStage)begin
			assign midian=midian_t;
		end else begin
			reg [dataW-1:0]midian_reg;
			always@(posedge clk)if(en)begin
				midian_reg<=midian_t;
			end
			assign midian=midian_reg;
		end
	
	endgenerate
endmodule
