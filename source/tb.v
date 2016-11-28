//`include "block_matching_disparity.v"
`include "frameBuff.v"
`include "getMinIdx.v"
`include "AdderTree.v"
`include "PixCoordinator.v"
`include "hijacker.v"
`include "xMatching.v"
`include "SAD_Mod.v"
`timescale 1ns/100ps
`define DELAY 20

module motion_est_tb;
wire Ready2NextPixel;
reg clk, rst;

reg [8*8*4-1:0] cf, pf;

wire [3:0]cfpix=cf[8*8*4-1-:4];
wire [3:0]pfpix=pf[8*8*4-1-:4];
//reg signed [8:0] dx, dy;
//block_matching_disparity aa(clk,rst, Ready2NextPixel,cfpix, pfpix);



/*always @ (*)
begin
	dx = (dxa + dxb + dxc + dxd + dxe + dxf + dxg + dxh + dxi + dxj + dxk + dxl + dxm + dxn + dxo + dxp);//rounding
	dy = (dya + dyb + dyc + dyd + dye + dyf + dyg + dyh + dyi + dyj + dyk + dyl + dym + dyn + dyo + dyp);
	$display("IJIJI");
end
*/

wire [3:0]ppfpix;

wire [4*4*4-1:0]win1;
wire [4*4*4-1:0]win2;
/*
frameBuff fB(clk,0,pfpix,ppfpix,win1,win2);
defparam fB.pixel_dept=4,
         fB.frame_w=8,
         fB.frame_h=8,
         fB.window_w=4,
         fB.window_h=4;*/


reg FbWrARst;
//block_matching_disparity aa(clk,rst, Ready2NextPixel,cfpix, pfpix);
hijacker #(.CameraDataDepth(16),.ImageW(8),.ImageH(8),.DataDepth(4))
         hj(
             _fclk,
             clk,
             _clk2,
             clk,
             FbWrARst,
             _CamBDV,
             _FbWrBRst,
             {pfpix,1'b0,pfpix,2'b0,pfpix,1'b0},
             _DI2,
             _DO1,
             _DO2,
             _LED_O);
			 
			 
	defparam hj.SampW=7;
	defparam hj.SampH=7;
	defparam hj.ExWinW=4;
	defparam hj.ExWinH=4;
	defparam hj.coreWinW=2;
	defparam hj.coreWinH=2;
	/*
parameter getMinIdxL=5;
getMinIdx #(.data_depth(4),.ArrL(getMinIdxL),.IdxOffSet(0))
          GMI(pf[0+:getMinIdxL*4],min2,minIdx2);


AdderTree #(.data_depth(4),.ArrL(getMinIdxL))
          GS(pf[0+:getMinIdxL*4],Sum);*/
reg flag;
initial
begin
    FbWrARst=1;
    flag=0;
    clk = 0;
    rst = 1;
	cf = {
4'd3, 4'd2, 4'd5, 4'd3, 4'd14, 4'd13, 4'd12, 4'd15, 
4'd2, 4'd2, 4'd3, 4'd1, 4'd12, 4'd13, 4'd15, 4'd14,
4'd5, 4'd4, 4'd2, 4'd3, 4'd15, 4'd14, 4'd14, 4'd12, 
4'd8, 4'd2, 4'd1, 4'd4, 4'd14, 4'd12, 4'd13, 4'd13,
4'd2, 4'd3, 4'd2, 4'd2, 4'd 7, 4'd 8, 4'd 5, 4'd 6, 
4'd3, 4'd1, 4'd2, 4'd1, 4'd 3, 4'd 3, 4'd 4, 4'd 2,
4'd1, 4'd2, 4'd6, 4'd5, 4'd 1, 4'd 4, 4'd 5, 4'd 1, 
4'd1, 4'd1, 4'd2, 4'd3, 4'd 2, 4'd 1, 4'd 1, 4'd 8};

pf = {
4'd1, 4'd2, 4'd0, 4'd2, 4'd1, 4'd2, 4'd4, 4'd2, 
4'd0, 4'd1, 4'd1, 4'd0, 4'd3, 4'd4, 4'd1, 4'd5,
4'd1, 4'd4, 4'd15, 4'd14, 4'd15, 4'd13, 4'd2, 4'd3, 
4'd1, 4'd3, 4'd13, 4'd15, 4'd15, 4'd14, 4'd2, 4'd3,
4'd4, 4'd1, 4'd12, 4'd14, 4'd12, 4'd12, 4'd3, 4'd4, 
4'd1, 4'd2, 4'd14, 4'd13, 4'd13, 4'd15, 4'd1, 4'd2, 
4'd2, 4'd2, 4'd3, 4'd1, 4'd2, 4'd3, 4'd1, 4'd1, 
4'd2, 4'd1, 4'd4, 4'd2, 4'd3, 4'd1, 4'd1, 4'd1};
	#3 FbWrARst=0;
    #150
     rst = 0;
end
integer pixC=0;
always @ (posedge clk)
begin
    pixC=pixC+1;
    if(pixC==64)
	  begin 
		  FbWrARst=1;
		  pixC=0;
		  #2 FbWrARst=0;
	  end
end


always
begin
    #100 clk = ~clk;

end
integer cc=0;
always @ (posedge clk)
begin
    pf <= {pf, cfpix};
    cf <= {cf, 4'b0};
    cc=cc+1;
    if(cc[5:0]==6'h3F)flag=~flag;
    //$display("%d ",cfpix);
end

integer  advC;
wire [7:0]R=(advC<<3+advC<<2+advC)>>5;//{advC,1'b0}+advC>>1;//*2.5
initial
begin
    advC=30;
    $dumpfile("wave.vcd");
    $dumpvars;
    #40000 $finish;
end

endmodule
