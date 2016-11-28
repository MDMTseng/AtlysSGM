module AdderTree
       #(parameter
         data_depth=8,
         ArrL = 4
        )(
           input [data_depth*ArrL-1:0]DIn,
           output [sumDepth-1:0]Sum
       );
parameter
    sumDepth=($clog2(ArrL)+(((2**$clog2(ArrL))==ArrL)?0:1))+data_depth;
parameter Sp1=ArrL/2;
parameter Sp2=ArrL-Sp1;
parameter Sp1L=($clog2(Sp1)+(((2**$clog2(Sp1))==Sp1)?0:1))+data_depth;
parameter Sp2L=($clog2(Sp2)+(((2**$clog2(Sp2))==Sp2)?0:1))+data_depth;

assign Sum=subLevelSum1+subLevelSum2;

wire [Sp1L-1:0]subLevelSum1;
wire [Sp2L-1:0]subLevelSum2;




generate
    if(Sp1==1)
        assign subLevelSum1=DIn[0+:data_depth];

else
    AdderTree #(.data_depth(data_depth),.ArrL(Sp1))
              ATI1(DIn[0+:Sp1*data_depth],subLevelSum1);

if(Sp2==1)
    assign subLevelSum2=DIn[Sp1*data_depth+:data_depth];
else
    AdderTree #(.data_depth(data_depth),.ArrL(Sp2))
              ATI1(DIn[Sp1*data_depth+:Sp2*data_depth],subLevelSum2);


endgenerate


    endmodule
