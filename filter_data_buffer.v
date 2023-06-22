`timescale 1ns / 1ps

// Sobel Data bufer coding
module filter_data_buffer #(
    parameter WIDTH = 8,
    parameter DEPTH = 512,
    parameter LINE_BITS = 10,
    parameter ROWS = 512,
    parameter COLS = 512

)


(

    input clk,
    input reset, 
    input [WIDTH-1:0] data_in, // grayscale stream
    input data_in_done,
    
    output  [WIDTH-1 :0] data_out_0,
    output  [WIDTH-1 :0] data_out_1,
    output  [WIDTH-1 :0] data_out_2,
    output  [WIDTH-1 :0] data_out_3,
    output  [WIDTH-1 :0] data_out_4,
    output  [WIDTH-1 :0] data_out_5,
    output  [WIDTH-1 :0] data_out_6,
    output  [WIDTH-1 :0] data_out_7,
    output  [WIDTH-1 :0] data_out_8,
    output   data_out_done
    
    );
    
wire [WIDTH-1 :0] double_line_fifo_data0;
wire [WIDTH-1 :0] double_line_fifo_data1;
wire [WIDTH-1 :0] double_line_fifo_data2;
wire double_line_fifo_done;
    
buffer_controller #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),// = 512, // length of one line
    .LINE_BITS(LINE_BITS)// = 10  // 512 , 10000000000 10 bits

)
inst0
(
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .data_in_valid(data_in_done),
    //output  reg [(3*WIDTH*3)-1 :0] data_out,  
    .data_out_0(double_line_fifo_data0),
    .data_out_1(double_line_fifo_data1),
    .data_out_2(double_line_fifo_data2),
    
    .data_out_valid(double_line_fifo_done)

);

data_modulate #(
    .WIDTH(WIDTH),
    .ROWS(ROWS), // Y 2160 // 512
    .COLS(COLS), //X 3840 //512
    .LINE_BITS(LINE_BITS) // 512 - 10 bit
)    inst1
(
    .clk(clk),
    .reset(reset),
    // from buffer controller
    .data_in_0(double_line_fifo_data0),
    .data_in_1(double_line_fifo_data1),
    .data_in_2(double_line_fifo_data2),
    .data_in_valid(double_line_fifo_done),
    
    .data_out_0(data_out_0),
    .data_out_1(data_out_1),
    .data_out_2(data_out_2),
    .data_out_3(data_out_3),
    .data_out_4(data_out_4),
    .data_out_5(data_out_5),
    .data_out_6(data_out_6),
    .data_out_7(data_out_7),
    .data_out_8(data_out_8),
    .data_out_done(data_out_done)
    );
    
endmodule
