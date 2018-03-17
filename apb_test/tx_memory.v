`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2018 01:17:19 AM
// Design Name: 
// Module Name: tx_memory
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


module tx_memory
 #( parameter data_width =32,
    parameter addr_width = 4,  // need to be a log2 opertation
    parameter mem_depth = 16
 )
(
input                        clk,
input                        reset,
input                        wr,
input      [data_width-1:0]  data_in,
input      [addr_width-1:0]  addr,
output reg [data_width-1:0]  data_out
    );
 
 reg [data_width-1:0] mem [mem_depth:0] ;
 
 always@(posedge clk)
 begin
 
       if(reset)
          begin
             for(i=0;i<mem_depth;i=i+1)
               begin
                mem[i] <= 0;
               end
          end
          
        else  
            begin 
                if(wr)            //high is write and low is raed
                  mem[addr] <= data_in;
                 
                 else
                  data_out <= mem[addr];
             end      
 end   
    
endmodule
