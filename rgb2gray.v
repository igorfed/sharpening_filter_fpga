`timescale 1ns / 1ps

module rgb2gray #(
    parameter WIDTH = 8
)

(
    input clk,
    input reset,
    input [WIDTH-1:0] r_data_in,
    input [WIDTH-1:0] g_data_in,
    input [WIDTH-1:0] b_data_in,
    input [1:0] mode, // 0 - R, 1 - G ,  2 B
    
    input data_in_done,
    
    output reg [WIDTH-1:0] data_out,
    output reg data_out_done

    );
    
//reg [WIDTH-1:0] results;     
//reg results_done;    

// simple convert from RGB888 to Grayscale 8    
always @(posedge clk) 

begin 
    if (reset) 
    begin 
        data_out <= 0;
        data_out_done<= 0;
        
    end else 
    
        begin 
            if (data_in_done) 
            begin
                case (mode) 
                0: begin 
                    data_out<= r_data_in;
                end
                1: begin 
                    data_out<= g_data_in;
                end             
                2: begin 
                    data_out<= b_data_in;
                end             
                3: begin                                              
                
                    data_out <= (r_data_in>>2) + (r_data_in>>5) + (g_data_in>>1) + (g_data_in>>4) + (b_data_in>>4) + (b_data_in>>5);
                end
                endcase                                            
                            
                //data_out <=r_data_in;                             
                data_out_done<= 1;
            end
            else 
            begin 
                data_out <=0;
                data_out_done<= 0;
            end  
        end
end 

//assign data_out = results;


endmodule
