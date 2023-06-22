`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2023 08:23:48 AM
// Design Name: 
// Module Name: gray2rgb
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


module channels2RGB #(
    parameter WIDTH = 8
)

(

    input clk,
    input reset,
    input [WIDTH-1:0] r_data_in, // prosessed R or G or B channel
    input [WIDTH-1:0] g_data_in, // prosessed R or G or B channel
    input [WIDTH-1:0] b_data_in, // prosessed R or G or B channel
    input data_in_done, 
    
    output reg [WIDTH-1:0] r_data_out,
    output reg [WIDTH-1:0] g_data_out,
    output reg [WIDTH-1:0] b_data_out,
    output reg data_out_done
     
    );
    
    
always @(posedge clk) begin 
    if (reset) begin
        r_data_out <= 8'd0;
        g_data_out <= 8'd0;
        b_data_out <= 8'd0;
        
    end else begin 
    if (data_in_done) begin 
        r_data_out <= r_data_in;
        g_data_out <= g_data_in;
        b_data_out <= b_data_in;
    end 
    data_out_done <= data_in_done;
    end
end     
endmodule
