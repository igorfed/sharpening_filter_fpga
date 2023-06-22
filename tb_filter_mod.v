`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2023 09:25:53 AM
// Design Name: 
// Module Name: tb_filter_mod
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
`define clk_period 10
`define soursed_image_name  "test/source_rgb_512.bmp"
`define processed_image_name  "image/sharpened_fpga_rgb_512.bmp"





module tb_filter_mod #(
    parameter WIDTH = 8, 
    parameter DEPTH = 512, //3840
    parameter LINE_BITS = 10, //12
    parameter ROWS = 512, //3840
    parameter COLS = 512 // 2160

    )
    
    (

    );

// internal for input
reg clk, reset;
// test for RGB
reg [WIDTH-1:0] r_data_in;
reg [WIDTH-1:0] g_data_in;
reg [WIDTH-1:0] b_data_in;
reg data_in_done; // __________________________|clk|____________________ data is finished

// internal for output
wire [WIDTH-1:0] r_data_out;
wire [WIDTH-1:0] g_data_out;
wire [WIDTH-1:0] b_data_out;
wire data_out_done; // __________________________|clk|____________________ data is finished

localparam RESULT_DATA_ARRAY_LENGTH = 1024*1024; // 500kByte
reg [WIDTH-1:0] result [0: RESULT_DATA_ARRAY_LENGTH-1];
localparam BMP_DATA_ARRAY_LENGTH = 1024*1024; // 500kByte
reg [WIDTH-1:0] bmp_data [0: BMP_DATA_ARRAY_LENGTH-1];

// Save BMP file size 
// https://en.wikipedia.org/wiki/BMP_file_format
integer bmp_size; 

//an offset from the beginning of the file to pixels array
integer bmp_start_pos;

integer bmp_width;
integer bmp_height;
integer bmp_BitCount;

initial clk =1;

always #(`clk_period/2) clk =~clk;


initial 
begin : reset_signal
    integer i;
	reset = 1'b1;
	r_data_in = 8'd0;
	g_data_in = 8'd0;
	b_data_in = 8'd0;
	data_in_done = 1'b0;
	read_bmp; 
	#100;
	@(posedge clk);
	reset = 1'b0;
	#100;
	
	
	// parse all RGB and split it in R G B
	// Read process
	for (i=bmp_start_pos; i<bmp_size;i=i+3) 
	begin
        r_data_in = bmp_data[i+2];
        g_data_in = bmp_data[i+1];
        b_data_in = bmp_data[i+0];
	    @(posedge clk);
	    data_in_done = 1'b1;
	end
	
    @(posedge clk);
    data_in_done = 1'b0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
    
   write_bmp_after_processings;
    
    @(posedge clk);
   $stop;
end


/////////////////READ BMP TASK//////////////////////////////////////

task read_bmp;
    integer file_id;
    integer i;
    begin
        file_id = $fopen(`soursed_image_name, "rb");
        if (file_id ==0) begin 
            $display("Open BMP error \n");
            $finish;
        end
        else begin  
            $fread(bmp_data, file_id);
            $fclose(file_id);
            // read bmp size combine 4 bytes into one integer
            bmp_size = {bmp_data[5], bmp_data[4], bmp_data[3], bmp_data[2]};
            $display("bmp_size = %d\n", bmp_size);
            // read start pointe for pixels array
            bmp_start_pos = {bmp_data[13], bmp_data[12], bmp_data[11], bmp_data[10]};
            $display("bmp_start_pos = %d\n", bmp_start_pos);
            // raed width
            bmp_width = {bmp_data[21], bmp_data[20], bmp_data[19], bmp_data[18]};
            $display("bmp_width = %d\n", bmp_width);
            
            bmp_height = {bmp_data[25], bmp_data[24], bmp_data[23], bmp_data[22]};
            $display("bmp_height = %d\n", bmp_height);

            bmp_BitCount = {bmp_data[29], bmp_data[28]};
            $display("bmp_BitCount = %d\n", bmp_BitCount);
            if (bmp_BitCount!=24) 
            begin
                $display("Attention Bit depth is wrong");
                $finish;
            end
        end
    end
endtask
/////////////////Write BMP TASK//////////////////////////////////////
task write_bmp_after_processings;
    integer file_id;
    integer i;
    begin
        file_id = $fopen(`processed_image_name, "wb");
        for(i=0;i<bmp_start_pos;i=i+1)
        begin 
            $fwrite(file_id, "%c", bmp_data[i]);
        end 
        for(i=bmp_start_pos;i<bmp_size;i=i+1)
        begin 
            $fwrite(file_id, "%c", result[i-bmp_start_pos]);
        end 
        $fclose(file_id);
        $display("Write bmp done");
    end 
endtask     
    
/////////////////Write BMP TASK//////////////////////////////////////

integer i, j;
always @(posedge clk) begin
    if (reset) begin
        j <=8'd0;
    end else begin
        if (data_out_done) begin
            result[j] <= r_data_out;  
            result[j+1] <= g_data_out;
            result[j+2] <= b_data_out;
            j <= j+3;
        end 
    end  
end 



    
filter_mod #( 
    .WIDTH(WIDTH), 
    .DEPTH(DEPTH),
    .LINE_BITS(LINE_BITS),
    .ROWS(ROWS),
    .COLS(COLS)
)
inst0
(
    .clk(clk),    //System clock
    .reset(reset),  //System reset
    
    .r_data_in(r_data_in),
    .g_data_in(g_data_in),
    .b_data_in(b_data_in),
    .data_in_done(data_in_done),
     

    .r_data_out(r_data_out),
    .g_data_out(g_data_out),
    .b_data_out(b_data_out),
    
    .data_out_done(data_out_done)

    );
    
endmodule
