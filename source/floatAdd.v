`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:09 02/06/2015 
// Design Name: 
// Module Name:    floatAdd 
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
module floatAdd(
           input CLK,input rst,input en,
           input [Float_L-1:0]Float_A,
           input [Float_L-1:0]Float_B,
           output[Float_L-1:0]Float_C,
				output rdy
       );
parameter ExpWidth=(8);
parameter MantissaWidth=(23);
parameter Float_L=1+ExpWidth+MantissaWidth;

parameter pipeStages=5;
reg [pipeStages-1:0]rdyShifter;//consider clock trigger delay 1
assign rdy=rdyShifter[pipeStages-1];
always@(posedge CLK or posedge rst)
begin
	
	if(rst)rdyShifter<=0;
	else rdyShifter<={rdyShifter,en};
	
end

function  getSign;
   input [Float_L-1:0]f;
   begin
     getSign =f[Float_L-1];
   end
endfunction
function [ExpWidth-1:0] getExp;
   input [Float_L-1:0]f;
   begin
     getExp =f[MantissaWidth+:ExpWidth];
   end
endfunction
   
function [MantissaWidth-1:0] getManti;
   input [Float_L-1:0]f;
   begin
     getManti =f[0+:MantissaWidth];
   end
endfunction
   
   
reg [Float_L-1:0]s1_float_M,s1_float_m;////M has the biggest exponent value
reg [MantissaWidth:0]s1_Manti_m_mod;

reg [ExpWidth-1:0]s1_expDiff;
//stage 1

always@(posedge CLK)
begin
	if(en)begin
		if((getExp(Float_A)==getExp(Float_B)&&getManti(Float_A)>getManti(Float_B))
		||getExp(Float_A)>getExp(Float_B)
		)//find dominate number
		begin
			 s1_float_M=Float_A;
			 s1_float_m=Float_B;
		end
		else
		begin
		 s1_float_M=Float_B;
		 s1_float_m=Float_A;
		
		end
		s1_expDiff=getExp(s1_float_M)-getExp(s1_float_m);
		
		s1_Manti_m_mod={1'b1,getManti(s1_float_m)}>>s1_expDiff;
	end
end


reg [MantissaWidth+1:0]s2_Manti_sum;
reg [Float_L-1:0]s2_float_M,s2_float_m;
//stage 2

always@(posedge CLK)
begin
#1 
	if(getSign(s1_float_M)^getSign(s1_float_m))//pos&neg
		s2_Manti_sum<={1'b1,getManti(s1_float_M)}-s1_Manti_m_mod;
	else
		s2_Manti_sum<={1'b1,getManti(s1_float_M)}+s1_Manti_m_mod;
	
	s2_float_M<=s1_float_M;
	s2_float_m<=s1_float_m;
end


//stage 3
wire [$clog2(MantissaWidth):0]onesLCount;

reg [$clog2(MantissaWidth):0]s3_onesLCount;

reg [MantissaWidth+1:0]s3_Manti_sum;
reg [Float_L-1:0]s3_float_M,s3_float_m;

genvar i;
generate
	
	for(i=0;i<MantissaWidth+1;i=i+1) begin : zerosTest
		wire [MantissaWidth+1:0]Manti_sumR=s2_Manti_sum;
		wire [MantissaWidth-1:0]ddd=Manti_sumR[MantissaWidth:MantissaWidth-i];
		wire [$clog2(MantissaWidth):0]ZC;
		wire [$clog2(MantissaWidth):0]index=i;
		
		assign ZC=(i==0)?0:((ddd==1)?index:zerosTest[i-1].ZC);
		
	end
	assign onesLCount=zerosTest[MantissaWidth].ZC;
endgenerate
always@(posedge CLK)
begin 
	s3_onesLCount<=onesLCount;
	s3_Manti_sum<=s2_Manti_sum;
	s3_float_M<=s2_float_M;
	s3_float_m<=s2_float_m;
end


//stage 4
reg [ExpWidth-1:0]s4_newExp;
reg [MantissaWidth-1:0]s4_newManti;
reg s4_newSign;
always@(posedge CLK)
begin 
	
	s4_newSign<=getSign(s3_float_M);
	if(s3_Manti_sum[MantissaWidth+1]==1)
	begin
		s4_newExp<=getExp(s3_float_M)+1;
		s4_newManti<=s3_Manti_sum[0]+(s3_Manti_sum[MantissaWidth-:MantissaWidth]);
	end
	else if(s3_Manti_sum==0)
	begin
		
		s4_newExp<=0;
		s4_newManti<=0;
	end
	else
	begin
		s4_newExp<=getExp(s3_float_M)-s3_onesLCount;
		s4_newManti<=s3_Manti_sum<<(s3_onesLCount);
	end
end


reg [Float_L-1:0]sF_outBuf;
always@(posedge CLK) sF_outBuf<={s4_newSign,s4_newExp,s4_newManti};
assign Float_C=sF_outBuf;

endmodule
