`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2018 03:49:30 PM
// Design Name: 
// Module Name: reg_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_file
   #( parameter data_width =32,
      parameter addr_width = 4,  // need to be a log2 opertation
      parameter reg_depth = 16
     )
   (
      input     [data_width-1:0]  data_in1, data_in2,
       input     [addr_width-1:0]  addr1 ,addr2,
       input                       wr1, wr2,
       input                       clk,
       input                       reset,
       output reg [data_width-1:0] data_out1, data_out2
      ); 
      
      reg [data_width-1:0] rf [reg_depth-1:0];
    
     //reset
       always @(posedge clk)    
            begin
               if(reset)
                 begin
                   for(i=0;i<reg_depth;i=i+1)
                    begin
                     rf[i] <= 0;
                    end
                 end
              end 
     //port 1  
      always @(posedge clk)
       begin
              if (wr1)      //high > write   ,low > read   
                begin
                  rf[addr1] <= data_in1;
                end
               else        
                  begin
                    data_out1 <= rf[addr1];
                  end
       end
       
       // port 2
       always @(posedge clk)
           begin
                 if (wr2)      //high > write   ,low > read   
                    begin
                      rf[addr2] <= data_in2;
                    end
                  else        
                     begin
                       data_out2 <= rf[addr2];
                     end
            end
       
       
  endmodule
