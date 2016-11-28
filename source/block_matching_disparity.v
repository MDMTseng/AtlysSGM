/*
`timescale 1ns/100ps
module block_matching_disparity#(
           pixel_depth=4,
           core_width = 2,
           core_height = 2,
           CompL = 4
       )(clk,rst, win_comp,win_core);

input [core_width*(core_height+CompL-1)*pixel_depth-1:0] win_comp;
input [core_width*core_height*pixel_depth-1:0] win_core;
input clk, rst;

parameter costL=8;

wire [costL*CompL-1:0] SubCost;
genvar i;
generate
    for(i = 0; i < CompL; i = i + 1) begin : array
        DiffGetter
		#(dataInDepth=pixel_depth,dataInL=core_width*core_height)
		DG(
		win_comp[core_width*i+:core_width*core_height*pixel_depth]
		,win_core,SubCost[costL*i+:costL]);
			
    end
endgenerate

     

endmodule
*/