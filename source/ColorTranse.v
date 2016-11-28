`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:27:38 10/01/2014 
// Design Name: 
// Module Name:    ColorTranse 
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
module ColorTranse(H,R,G,B);
input[7:0]H;
output wire[7:0]R;
output wire[7:0]G;
output wire[7:0]B;

assign R=H;

assign G=(H[7]==1)?~{H,1'b0}:{H,1'b0};
assign B=~H;

//0~42


/*
wire [7:0]coff ={ H[5:0], 2'b0};
wire [7:0]coff_={~H[5:0], 2'b0};

always@(H)
begin
	case(H[7:6])
		0:begin
			R<=coff_;
			G<=coff;
			B<=0;
		end
		1:begin
			R<=0;
			G<=coff_;
			B<=coff;
		end
		2:begin
			R<=coff;
			G<=0;
			B<=coff_;
		end
		default:begin
			R<=0;
			G<=0;
			B<=0;
		end
	endcase


end*/




endmodule