`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2018 07:48:34 PM
// Design Name: 
// Module Name: apb_interconnect
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


module apb_interconnect
  # ( parameter addr_width = 32,
      parameter data_width = 32 
    )
  
  (
 //  input                         PSLVERR,
     input                         PCLK,
     input                         PRESET,
     input      [data_width-1:0]   PRDATA,
     output reg [data_width-1:0]   PWDATA,
     output reg [addr_width-1:0]   PADDR,
     
     input                      PREADY,
     output                     PSEL,
     output  reg                PENABLE,
     output                     PWRITE
      
    );
    reg [addr_width-1:0]  adrs_reg ;
    reg [data_width-1:0]  data_reg ;
    reg [1:0] state ;
    
    parameter IDLE   = 0,
              SETUP  = 1,
              ACCESS = 2;
    parameter Ready = 0,
              NotReady = 1;          
    
    
    always @(posedge PCLK)
       
       case (state)
         
         IDLE : if (PSEL & PENABLE)
                  state <= ACCESS;
                else if (PSEL)
                  state <= SETUP;  
                else
                  state <= IDLE;
         
         SETUP : if (PWRITE)     
                   begin
                    data_reg = PWDATA   ;
                    PADDR  = adrs_reg ;
                    PENABLE <= 1;                             // lazem hna a3'yr el enable a5liha b 1
                    state <= ACCESS;
                   end
                  
                  else if (!PWRITE)
                   begin
                    PADDR = adrs_reg  ;
                    PENABLE <= 1;                           // lazem hna a3'yr el enable a5liha b 1
                    state <= ACCESS;
                   end 
             
         ACCESS : if (PENABLE & PSEL)
                   case (PREADY)
                    Ready : if (PWRITE)
                            begin 
                           //   tx_memoey = data_reg;
                           //   address_in_tx_memory = adrs_reg; 
                               PENABLE <= 0 ;          // i think en hna el enable lazem tb2a b zero b3d ma a-check 3la el PREADY Lsa b Zero wla La2 
                              // always @(!PREADY)     // wait state
                            
                              state <= ACCESS;
                             end
                           else
                             begin
                            //   data_reg = rx_fifo;
                                data_reg = PRDATA ;
                                PENABLE <= 0 ;           // i think en hna el enable lazem tb2a b zero b3d ma a-check 3la el PREADY Lsa b Zero wla La2
                                // always @(!PREADY)      // wait state
           
                                state <= ACCESS ;
                              end
                  NotReady :  if (PSEL)
                               state <= SETUP;
                              else 
                               state <= IDLE;         
                      endcase                 
                 
                  else if (PSEL & PREADY)
                       state <= SETUP ; 
                       
                    else                                 //include the state of (PREADY=1 and PENABLE=0 and PSEL=0)
                        state <= IDLE ;   
                        
         endcase   
    
   // if (PENABLE & PSEL & PREADY & PSLVERR)
    //DO SOMETHING ABOUT IT  
    //YET TO BE CONSIDERED (DEPENDS ON THE PERIPHERAL BEHAVIOUR)
    
endmodule
