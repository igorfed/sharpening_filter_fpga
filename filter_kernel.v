`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2023 08:54:11 AM
// Design Name: 
// Module Name: filter_kernel
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


module filter_kernel #(
    parameter WIDTH = 8,
    parameter DEPTH = 6,
    parameter LINE_BITS = 10,
    parameter ROWS = 5,
    parameter COLS = 6
)

(
    input clk,    //System clock
    input reset,  //System reset
    input [WIDTH-1:0] data_in,
    input data_in_done,

    output [WIDTH-1:0] data_out,
    output data_out_done

    );
    
wire [WIDTH-1:0] data [0:8];    
wire filter_data_buffer_done;    
    
filter_data_buffer #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .LINE_BITS(10),
    .ROWS(ROWS),
    .COLS(COLS)
)
inst0
(
    .clk(clk),
    .reset(reset),
    .data_in(data_in), //grayscale
    .data_in_done(data_in_done),
    
    .data_out_0(data[0]),
    .data_out_1(data[1]),
    .data_out_2(data[2]),
    .data_out_3(data[3]),
    .data_out_4(data[4]),
    .data_out_5(data[5]),
    .data_out_6(data[6]),
    .data_out_7(data[7]),
    .data_out_8(data[8]),
    .data_out_done(filter_data_buffer_done)
    
    );
    
//Sobel calculation
//mult_addition1 #(
mult_addition2 #(
    .WIDTH(WIDTH)

)
inst1
(
    .clk(clk),
    .reset(reset),
    .data_in_0(data[0]),
    .data_in_1(data[1]),
    .data_in_2(data[2]),
    .data_in_3(data[3]),
    .data_in_4(data[4]),
    .data_in_5(data[5]),
    .data_in_6(data[6]),
    .data_in_7(data[7]),
    .data_in_8(data[8]),
    .data_in_done(filter_data_buffer_done),
    
    .data_out(data_out),
    .data_out_done(data_out_done)     
    );    
endmodule
