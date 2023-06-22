`timescale 1ns / 1ps

module buffer_controller #(
    parameter WIDTH = 8,
    parameter DEPTH = 512, // length of one line
    parameter LINE_BITS = 10  // 512 , 10000000000 10 bits

)

(
    input clk,
    input reset,
    input [WIDTH-1:0] data_in,
    input  data_in_valid,
    //output  reg [(3*WIDTH*3)-1 :0] data_out,  
    output  [WIDTH-1 :0] data_out_0,
    output  [WIDTH-1 :0] data_out_1,
    output  [WIDTH-1 :0] data_out_2,
    
    output data_out_valid

);

wire [WIDTH-1:0] line0_data_out;

wire [WIDTH-1:0] line1_data_out;

wire line0_data_out_ready;

wire line1_data_out_ready;


line_buffer #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .LINE_BITS(LINE_BITS)
)
inst0
(
    .clk(clk),
    .reset(reset),     
    .data_in(data_in),  
    .data_in_valid(data_in_valid),   // write enable input 
    
    .data_out(line0_data_out),  // fifo1 data
    .data_out_done(line0_data_out_ready) // fifo 1 done
    );
    
    
line_buffer #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .LINE_BITS(LINE_BITS)
)
inst1
(
    .clk(clk),
    .reset(reset),     
    .data_in(line0_data_out),  
    .data_in_valid(line0_data_out_ready),   // write enable input 
    
    .data_out(line1_data_out),
    .data_out_done(line1_data_out_ready)
    );
    
assign data_out_0 = data_in;
assign data_out_1 = line0_data_out;
assign data_out_2 = line1_data_out;
assign data_out_valid = line0_data_out_ready;

     
endmodule
