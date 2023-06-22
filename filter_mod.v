`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2023 08:42:12 AM
// Design Name: 
// Module Name: filter_mod
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


module filter_mod #( 
    parameter WIDTH = 8, 
    parameter DEPTH = 6,
    parameter LINE_BITS = 10,
    parameter ROWS = 5,
    parameter COLS = 6
)

(
    input clk,    //System clock
    input reset,  //System reset
    
    input [WIDTH-1:0] r_data_in,
    input [WIDTH-1:0] g_data_in,
    input [WIDTH-1:0] b_data_in,
    
    input data_in_done,
     

    output [WIDTH-1:0] r_data_out,
    output [WIDTH-1:0] g_data_out,
    output [WIDTH-1:0] b_data_out,
    
    output data_out_done

    );
    
wire [WIDTH-1:0] r_channel_i;
wire [WIDTH-1:0] g_channel_i;     
wire [WIDTH-1:0] b_channel_i;     

     
wire r_channel_i_done;
wire b_channel_i_done;
wire g_channel_i_done;

wire [WIDTH-1:0] r_channel_filtered_o;     
wire [WIDTH-1:0] g_channel_filtered_o;
wire [WIDTH-1:0] b_channel_filtered_o;
wire r_channel_filtered_o_done;
wire g_channel_filtered_o_done;
wire b_channel_filtered_o_done;

rgb2gray #(
    .WIDTH(WIDTH)
)
inst0
(
    .clk(clk),
    .reset(reset),
    .r_data_in(r_data_in),
    .g_data_in(g_data_in),
    .b_data_in(b_data_in),
    .mode(2'b00),
    .data_in_done(data_in_done),
    
    .data_out(r_channel_i),
    .data_out_done(r_channel_i_done)

    );

rgb2gray #(
    .WIDTH(WIDTH)
)
inst1
(
    .clk(clk),
    .reset(reset),
    .r_data_in(r_data_in),
    .g_data_in(g_data_in),
    .b_data_in(b_data_in),
    .mode(2'b01),
    .data_in_done(data_in_done),
    
    .data_out(g_channel_i),
    .data_out_done(g_channel_i_done)

    );
    
rgb2gray #(
    .WIDTH(WIDTH)
)
inst2
(
    .clk(clk),
    .reset(reset),
    .r_data_in(r_data_in),
    .g_data_in(g_data_in),
    .b_data_in(b_data_in),
    .mode(2'b10),
    .data_in_done(data_in_done),
    
    .data_out(b_channel_i),
    .data_out_done(b_channel_i_done)

    );    
    
filter_kernel #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .LINE_BITS(LINE_BITS),
    .ROWS(ROWS),
    .COLS(COLS)
)
inst3
(
    .clk(clk),
    .reset(reset),
    .data_in(r_channel_i),
    .data_in_done(r_channel_i_done),

    .data_out(r_channel_filtered_o),
    .data_out_done(r_channel_filtered_o_done)

    );    

filter_kernel #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .LINE_BITS(LINE_BITS),
    .ROWS(ROWS),
    .COLS(COLS)
)
inst4
(
    .clk(clk),
    .reset(reset),
    .data_in(g_channel_i),
    .data_in_done(g_channel_i_done),

    .data_out(g_channel_filtered_o),
    .data_out_done(g_channel_filtered_o_done)

    );    

filter_kernel #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .LINE_BITS(LINE_BITS),
    .ROWS(ROWS),
    .COLS(COLS)
)
inst5
(
    .clk(clk),
    .reset(reset),
    .data_in(b_channel_i),
    .data_in_done(b_channel_i_done),

    .data_out(b_channel_filtered_o),
    .data_out_done(b_channel_filtered_o_done)

    );    


    
channels2RGB #(
    .WIDTH(WIDTH)
)
inst6
(

    .clk(clk),
    .reset(reset),
    //This is a test for single channel
    /*.r_data_in(r_channel_filtered_o),
    .g_data_in(r_channel_filtered_o),
    .b_data_in(r_channel_filtered_o),
    */
    .r_data_in(b_channel_filtered_o),
    .g_data_in(g_channel_filtered_o),
    .b_data_in(r_channel_filtered_o),
    .data_in_done(r_channel_filtered_o_done),

    .r_data_out(r_data_out),
    .g_data_out(g_data_out),
    .b_data_out(b_data_out),
    .data_out_done(data_out_done)

    
     
    );

        
endmodule
