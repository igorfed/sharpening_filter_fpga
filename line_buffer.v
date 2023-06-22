`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2023 01:33:38 PM
// Design Name: 
// Module Name: line_buffer
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

//FIFO buffer
module line_buffer #(
    parameter WIDTH=8,
    parameter DEPTH=512,
    parameter LINE_BITS=10
)

(
    input clk,
    input reset,     
    input [WIDTH-1:0] data_in,  
    input data_in_valid, 
    
    output [WIDTH-1:0]  data_out,
    output data_out_done
    );
    
//Internal sygnal
reg [WIDTH-1:0] line [DEPTH-1:0];

reg [LINE_BITS-1:0] wrPntr; // LINE_WIDTH = 512 - 10 bits
reg [LINE_BITS-1:0] rdPntr; // LINE_WIDTH = 512 - 10 bits

reg [LINE_BITS-1:0] cnt; // LINE_WIDTH = 512 - 10 bits
reg done;

//assign data_out_done = (cnt == DEPTH) ? 1:0;

assign data_out = line[rdPntr];

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end
    else begin
        done <= (cnt == DEPTH) ? 1:0;
    end 
end   
                
assign data_out_done = done;        


always @(posedge clk) begin : counter
    if (reset) begin
        cnt <= 0;
    end else begin
        if (data_in_valid==1) begin
            cnt <= (cnt == DEPTH) ? cnt:cnt+1;
        end
    end
end


always @(posedge clk) begin : write_pointer_logic
    if(reset) begin
        wrPntr <= 0;
    end else begin 
        if(data_in_valid==1) begin 
            line[wrPntr] <= data_in;
            wrPntr <= (wrPntr == DEPTH-1) ? 0:wrPntr+1;
        end 
    end                    
end

always @(posedge clk) begin : read_pointer_logic
    if(reset) begin 
        rdPntr <= 0;
    end else begin
        if(data_in_valid==1) begin 
            if (cnt == DEPTH) begin
                rdPntr <= (rdPntr == DEPTH-1)? 0:rdPntr+1;
            end
        end
    end                    
end


    
/*
//Internal sygnal

reg [WIDTH-1:0] line [IMG_WIDTH-1:0];

reg [WIDTH:0] wrPntr;
reg [WIDTH:0] rdPntr;

always @(posedge clk) begin : label

    if(data_in_valid)
        line[wrPntr] <= data_in;
end


always @(posedge clk) begin : write_pointer_logic
    if(reset)
        wrPntr <= 'd0;
    else if(data_in_valid)
        wrPntr <= wrPntr+1;
end



always @(posedge clk) begin : read_pointer_logic

    if(reset)
        rdPntr <= 'd0;
    else if(data_in_ready)
        rdPntr <= rdPntr + 'd1;
end

// Here we read tree sequental pixels 3 Bytes in one short
 
assign o_data = {line[rdPntr],line[rdPntr+1],line[rdPntr+2]};


*/    
endmodule
