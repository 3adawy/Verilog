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
    // MASTER PORT (peripheral port)
 //  input                         PSLVERR,
     input                         PCLK,
     input                         PRESET,
     input      [data_width-1:0]   PRDATA,
     output reg [data_width-1:0]   PWDATA,
     output reg [addr_width-1:0]   PADDR,
     
     input                      PREADY,
     output  reg                PSEL,
     output  reg                PENABLE,
     output  reg                PWRITE,
     
     
         // SLAVE PORT (PULPino interface)

     input                                          psel_i,   
     input                                          penable_i,
     input                                          pwrite_i,
     input      [31:0]                              paddr_i,
     input      [31:0]                              pwdata_i,
     output reg [31:0]                              prdata_o,
     output reg                                     pready_o
 //  output                                         pslverr_o,

     
    );
    
    reg [addr_width-1:0]  adrs_reg ;
    reg [data_width-1:0]  data_reg ;
    reg [1:0] state1 ;
 //   reg [1:0] state2 ;
    //   state1 = 0;
     //  state2 = 0;
    parameter IDLE   = 0,
               SETUP  = 1,
               ACCESS = 2;
     parameter Ready = 1,
               NotReady = 0;          
     
     
     always @(posedge PCLK)
       begin  
        case (state1)
          
          IDLE : if (PSEL && PENABLE)
                   state1 <= ACCESS;
                 else if (PSEL)
                   state1 <= SETUP;  
                 else
                   state1 <= IDLE;
          
          SETUP :
                 state1 <= ACCESS;
          /* if (PWRITE)     
                    begin
                    // PWDATA = pwdata_i ;
                    // PADDR  = paddr_i ;
                    // PENABLE <= 1;                             // lazem hna a3'yr el enable a5liha b 1
                     state1 <= ACCESS;
                    end
                   
                  else if (!PWRITE)
                    begin
                    // PADDR = paddr_i ;
                    // PENABLE <= 1;                           // lazem hna a3'yr el enable a5liha b 1
                     state1 <= ACCESS;
                    end 
              */
          ACCESS : if (PENABLE && PSEL)
                    case (PREADY)
                     Ready : if (PWRITE)
                             begin 
                                // el mafrod yb2a fe wait one cycle b3d kda ntsna el Pready tt8yar                       
                                PENABLE <= 0 ;          // i think en hna el enable lazem tb2a b zero b3d ma a-check 3la el PREADY Lsa b Zero wla La2 
                                state1 <= ACCESS;
                              end
                            else
                              begin
                                 // el mafrod yb2a fe wait one cycle b3d kda ntsna el Pready tt8yar
                                 PENABLE <= 0 ;           // i think en hna el enable lazem tb2a b zero b3d ma a-check 3la el PREADY Lsa b Zero wla La2
                                 state1 <= ACCESS;
                               end
 
                   NotReady :  if (PSEL)
                                state1 <= SETUP;
                               else 
                                state1 <= IDLE;         
                       endcase                 
                  
                   else if (PSEL & PREADY)
                        state1 <= SETUP ; 
                        
                   else                                 //include the state of (PREADY=1 and PENABLE=0 and PSEL=0)
                        state1 <= IDLE ;   
                         
          endcase   
     end
   // if (PENABLE & PSEL & PREADY & PSLVERR)
    //DO SOMETHING ABOUT IT  
    //YET TO BE CONSIDERED (DEPENDS ON THE PERIPHERAL BEHAVIOUR)
    
         
       // Interface with PULPino    
       always @(posedge PCLK)
       
          begin  // always block begin
          
             if (penable_i && psel_i)    //access state
                begin       // if begin
                    PSEL = 1; 
                    
                      if (pwrite_i)
                          begin   // if begin
                                
                                PENABLE = 1;                    // pwdata bta3t el peripheral = pwdata_i; 
                                pready_o = 1;
                                PWDATA = pwdata_i ;
                                state1 <= ACCESS;
                          end   // if end
                    
                      else
                          begin    // else begin
                                PENABLE = 1; 
                                pready_o = 1;
                                prdata_o = PRDATA ;                   //  prdata_o = prdata bta3t el peripheral ; 
                                state1 <= ACCESS;
                          end     // else end
                          
                  pready_o <= 0;       // set pready to low 
                  PSEL <= 0;
                end     // if end
              
             else if (psel_i)
                    begin     // else if begin
                          PSEL = 1;
                          PADDR = paddr_i ;                           // el address line for the periperal PADDR = the address from pulpino  paddr_i 
                          pready_o = 0;
                            if (!pwrite_i)
                              begin 
                               PWRITE = 0 ;
                               prdata_o = PRDATA ;
                              end
                            else 
                              begin 
                               PWRITE = 1 ;
                               PWDATA = pwdata_i ;  
                              end

                          state1 <= SETUP;
                    end      // else if end
             else  
                    begin    // else begin 
                          pready_o = 0;
                          state1 <= IDLE;
                    end    // else end
           
           end   // always block end
  
    
   endmodule
