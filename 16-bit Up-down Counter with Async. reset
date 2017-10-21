module ud_counter ( count , rst, clk ,mod);
     parameter N= 15;
     output [N:0] count;
     input rst, clk ,mod ;
     reg [N:0] count ;
     
   always @(posedge clk or negedge rst)
     if (rst)
        count <= 0 ;
     else if (mod)
        count <= count+1;
     else
        count <= count-1;
endmodule   
