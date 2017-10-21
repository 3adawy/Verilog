module tff (q , t , clk , rst);
     output q;
     input t,clk,rst ;
     reg q ;
     
  always @(posedge clk)
     if (rst)
       q <= 0 ;
     else if (t) 
       q <= ~q;
     else 
       q <= q;
       
 endmodule
       
       
