`timescale 1ns / 1ps


`define soursed_image_name  "1920/source_rgb_1920_1080.bmp"
`define processed_image_name  "1920/d_source_rgb_1920_1080.bmp"

module tb #(
parameter WIDTH =8

    );
    


//internal signal 
reg clk;
reg resetN;

// bmp reader
localparam BMP_DATA_ARRAY_LENGTH = 1920*1920*3; // 500kByte

localparam RESULT_DATA_ARRAY_LENGTH = 1920*1920*3; // 500kByte


reg [WIDTH-1:0] bmp_data [0: BMP_DATA_ARRAY_LENGTH-1];
// result from image processing

reg [WIDTH-1:0] result [0: RESULT_DATA_ARRAY_LENGTH-1];

// Save BMP file size 
// https://en.wikipedia.org/wiki/BMP_file_format
integer bmp_size; 

//an offset from the beginning of the file to pixels array
integer bmp_start_pos;

integer bmp_width;
integer bmp_height;
integer bmp_BitCount;


// test for RGB

reg [WIDTH-1:0] r_data_in;
reg [WIDTH-1:0] g_data_in;
reg [WIDTH-1:0] b_data_in;
reg data_in_done; // __________________________|clk|____________________ data is finished

wire [WIDTH-1:0] r_channel_i;
wire [WIDTH-1:0] g_channel_i;     
wire [WIDTH-1:0] b_channel_i;     

     
wire [WIDTH-1:0] r_data_out;
wire [WIDTH-1:0] g_data_out;     
wire [WIDTH-1:0] b_data_out;  

wire r_channel_i_done;
wire b_channel_i_done;
wire g_channel_i_done;

integer i, j;


wire [WIDTH-1:0] data_out;
wire data_out_done;

initial 
 begin :clock
    clk = 1'b0;
    while (1) begin
        #5 clk = 1'b1;
        #5 clk = 1'b0;
    end
end    
/*
initial 
begin
    resetN = 1'b1;
    data_in_done = 1'b0;
	r_data_in = 8'd0;
	g_data_in = 8'd0;
	b_data_in = 8'd0;
    #100;
	resetN = 1'b0;
	#100;
	@(posedge clk);
	r_data_in = 8'b0000_0100;
	g_data_in = 8'b0000_0010;
	b_data_in = 8'b0001_0000;
    
    data_in_done  = 1'b1;      
    @(posedge clk);
    
    data_in_done = 1'b0;
    
    @(posedge clk);
    $stop;
end

*/

initial 
begin : reset_signal
    integer i;
    integer k;
	resetN = 1'b1;
	r_data_in = 8'd0;
	g_data_in = 8'd0;
	b_data_in = 8'd0;
	data_in_done = 1'b0;
	read_bmp; 
	#100;
	@(posedge clk);
	resetN = 1'b0;
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
    write_bmp_after_processings;
    
    @(posedge clk);
   $stop;
end
    
    
    
/*initial 
begin : test_read_write_bmp
    read_bmp;
    write_bmp;
end
*/    
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

// write bmp as a sourcsed image 
// This is for tests only  
/////////////////WRITE BMP TASK//////////////////////////////////////
/*
task write_bmp;
    integer file_id;
    integer i;
    begin
        file_id = $fopen(`processed_image_name_test, "wb");
        for(i=0;i<bmp_size;i=i+1)
        begin 
            $fwrite(file_id, "%c", bmp_data[i]);
        end 
        $fclose(file_id);
        $display("Write bmp done");
    end 
endtask        */
    
 

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
        
        //saving image processings array
        
        begin 
            $fwrite(file_id, "%c", result[i-bmp_start_pos]);
        end 


        
        $fclose(file_id);
        $display("Write bmp done");
    end 
endtask        

always @(posedge clk) begin
    if (resetN) begin
        j <=8'd0;
    end else begin
        if (data_out_done) begin
            result[j] <= b_data_out ;  
            result[j+1] <= g_data_out;
            result[j+2] <= r_data_out;
            j <= j+3;
        end 
    end  
end 


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
    
channels2RGB #(
    .WIDTH(WIDTH)
)
inst6
(

    .clk(clk),
    .reset(reset),
    .r_data_in(r_channel_i),
    .g_data_in(g_channel_i),
    .b_data_in(b_channel_i),
    .data_in_done(r_channel_i_done),

    .r_data_out(r_data_out),
    .g_data_out(g_data_out),
    .b_data_out(b_data_out),
    .data_out_done(data_out_done)

    
     
    );
//rgb2gray #(
//    .WIDTH(WIDTH)
//)
//inst0
//(
 //   .clk(clk),
  //  .reset(resetN),
   // .r_data_in(r_data_in),
   // .g_data_in(g_data_in),
   // .b_data_in(b_data_in),
   // .data_in_done(data_in_done),
   // .mode(2'b11),    
   // .data_out(data_out),
   // .data_out_done(data_out_done)

//    );
        
endmodule
