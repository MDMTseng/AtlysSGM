//`include "block_matching_disparity.v"
`timescale 1ns/100ps
`define DELAY 20

module motion_est_tb;
reg clk;
always
begin
    #100 clk = ~clk;
end
integer cc=0;
reg [5:0]A;
reg [5:0]B;
reg [5:0]C;
wire [11:0]SSS=A*B/C;
wire [5:0]SSS2=SSS;
always @ (posedge clk)
begin
    
end

initial
begin
	 clk=0;
    A=50;
    B=50;
    C=50;
    $dumpfile("wave.vcd");
    $dumpvars;
    #40000 $finish;
end

endmodule
