`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:25:58 01/25/2015 
// Design Name: 
// Module Name:    PixDiff 
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
module PixDiff(
    input [15:0] pix1,
    input [15:0] pix2,
    output [6:0] diff
    );
	 wire [4:0]diffR=(pix1[4:0]>pix2[4:0])? pix1[4:0]-pix2[4:0]:pix2[4:0]-pix1[4:0];
	 wire [5:0]diffG=(pix1[10-:6]>pix2[10-:6])? pix1[10-:6]-pix2[10-:6]:pix2[10-:6]-pix1[10-:6];
	 wire [4:0]diffB=(pix1[15-:5]>pix2[15-:5])? pix1[15-:5]-pix2[15-:5]:pix2[15-:5]-pix1[15-:5];
	 
	 assign diff=(diffR+diffB)+diffG;


endmodule
