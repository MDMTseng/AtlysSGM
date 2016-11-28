`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:29:04 11/06/2014 
// Design Name: 
// Module Name:    ColorTranse2d 
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
module ColorTranse2d(input[7:0]X,input[7:0]Y,output [7:0]R,output [7:0]G,output [7:0]B);
//X=0~255
//Y=0~255
assign R=X;
assign G=Y;

wire [8:0]XpY=X+Y;
assign B=~XpY[8-:8];


endmodule