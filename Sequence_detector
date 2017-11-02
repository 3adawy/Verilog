module seq_dect ( y , x , clk);
     output y ;
     input x, clk;
     reg y;
     parameter s0 = 0 ; s1 = 1 ; s2 = 2 ; s3 = 3 ;
     reg [0:1] nxt , pre;
     
   always @(posedge clk)
     pre= nxt ; 

   always @(pre or x)
     case (pre)
       s0 : begin 
              y = x ? 0 : 0;       
              nxt = x ? s0 : s1;
            end;
       s1 : begin 
              y = x ? 0 : 0;       
              nxt = x ? s2 : s1;
            end;
       s2 : begin 
              y = x ? 0 : 0;       
              nxt = x ? s3 : s1;
            end;
       s3 : begin 
              y = x ? 0 : 1;       
              nxt = x ? s0 : s1;
            end;     
     endcase
 endmodule      
