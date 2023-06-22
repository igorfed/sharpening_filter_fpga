`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2023 09:58:09 AM
// Design Name: 
// Module Name: mult_addition2
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


module mult_addition2 #(
    parameter WIDTH=8

)(



    input clk,
    input reset, 
    input  [WIDTH-1 :0] data_in_0,
    input  [WIDTH-1 :0] data_in_1,
    input  [WIDTH-1 :0] data_in_2,
    input  [WIDTH-1 :0] data_in_3,
    input  [WIDTH-1 :0] data_in_4,
    input  [WIDTH-1 :0] data_in_5,
    input  [WIDTH-1 :0] data_in_6,
    input  [WIDTH-1 :0] data_in_7,
    input  [WIDTH-1 :0] data_in_8,
    input  data_in_done,
    
    output reg [WIDTH-1 :0] data_out,
    output data_out_done     
    );

reg [11:0] g_p;
reg [11:0] g_n;
reg [11:0] g_d;
reg [11:0] d0, d1, d2, d3, d4, d5, d6, d7, d8;
reg [11:0] sum;
reg [WIDTH-1:0] kernel [8:0];

//reg [3:0] done_shift;    
reg [3:0] done_shift;

initial
begin : init_kernel
    
    // https://en.wikipedia.org/wiki/Kernel_(image_processing)
    kernel[0] =  0;
    kernel[1] = -1;
    kernel[2] =  0;
    
    kernel[3] = -1;
    kernel[4] =  5;
    kernel[5] = -1;
    
    kernel[6] =  0;
    kernel[7] = -1;
    kernel[8] =  0;
    
end   


always @(posedge clk) begin
    if (reset) begin 
        g_p <= 0;
        g_n <= 0;
        
    end  else begin 
        g_p <= (data_in_4 *4) + data_in_4; // FF*2 10 bit + FF 11 bit
        g_n <= data_in_1 + data_in_3 + data_in_5 + data_in_7; //FF+FF+FF+FF 10 bit
    end
     
end 

always @(posedge clk) begin
    if (reset) begin 
        g_d <= 0;
    end  else begin 
        //g_d<= (g_p>=g_n) ? (g_p-g_n) : (g_p); // xdata
        if (g_p>g_n) begin
            if (g_p-g_n >=255) begin
                g_d<= 255;
            end else begin
                g_d <= g_p-g_n;
            end
            
        end else begin
            g_d<= 0;
        end
        
                                  
    end 
end    

/*
always @(posedge clk) begin
    if (reset) begin 
        d0 <=0;
        d1 <=0;
        d2 <=0;
        d3 <=0;
        d4 <=0;
        d5 <=0;
        d6 <=0;
        d7 <=0;
        d8 <=0;
    end  else begin 
        d0 <=  data_in_0 * kernel[0]; //0
        d1 <=  data_in_1 * kernel[1]; // -data_in_1
        d2 <=  data_in_2 * kernel[2]; //
        d3 <=  data_in_3 * kernel[3]; // -data_in_3
        d4 <=  data_in_4 * kernel[4]; //(data_in_4 <<2) + data_in_4
        d5 <=  data_in_5 * kernel[5]; //-data_in5
        d6 <=  data_in_6 * kernel[6]; //0
        d7 <=  data_in_7 * kernel[7]; // -data_in7
        d8 <=  data_in_8 * kernel[8]; // 0
        
    end
     
end 

always @(posedge clk) begin
    if (reset) begin 
        sum <= 0;
    end  else begin 
        sum<= d0+d1+d2+d3+d4+d5+d6+d7+d8;
    end 
end   
*/

always @(posedge clk) begin
    if (reset) begin 
        sum <= 0;
    end  else begin 
        sum<= g_d;
    end 
end 


always @(posedge clk) begin
    if (reset) begin 
        data_out <= 0;
    end  else begin 
        data_out<= sum[7:0];
    end 
end 
always @(posedge clk) begin
    if (reset) begin 
        done_shift <= 0;
    end  else begin 
        done_shift<= {done_shift[2:0], data_in_done};
    end 
end    
assign data_out_done = done_shift[3];
    
    
    
endmodule
