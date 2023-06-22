`timescale 1ns / 1ps


module data_modulate#(
    parameter WIDTH = 8,
    parameter ROWS = 512, // Y 2160
    parameter COLS = 512, //X 3840
    parameter LINE_BITS = 10 // 512 - 10 bit
)    
(
    input clk,
    input reset,
    // from buffer controller
    input  [WIDTH-1 :0] data_in_0,
    input  [WIDTH-1 :0] data_in_1,
    input  [WIDTH-1 :0] data_in_2,
    input data_in_valid,
    
    output  [WIDTH-1 :0] data_out_0,
    output  [WIDTH-1 :0] data_out_1,
    output  [WIDTH-1 :0] data_out_2,
    output  [WIDTH-1 :0] data_out_3,
    output  [WIDTH-1 :0] data_out_4,
    output  [WIDTH-1 :0] data_out_5,
    output  [WIDTH-1 :0] data_out_6,
    output  [WIDTH-1 :0] data_out_7,
    output  [WIDTH-1 :0] data_out_8,
    output  data_out_done
    );
    
    

reg [WIDTH-1 :0] data_0;
reg [WIDTH-1 :0] data_1;
reg [WIDTH-1 :0] data_2;
reg [WIDTH-1 :0] data_3;
reg [WIDTH-1 :0] data_4;
reg [WIDTH-1 :0] data_5;
reg [WIDTH-1 :0] data_6;
reg [WIDTH-1 :0] data_7;
reg [WIDTH-1 :0] data_8;

reg [WIDTH-1 :0] cnt;
reg [LINE_BITS-1:0] iRows, iCols;


reg [WIDTH-1 :0] data_out0;
reg [WIDTH-1 :0] data_out1;
reg [WIDTH-1 :0] data_out2;
reg [WIDTH-1 :0] data_out3;
reg [WIDTH-1 :0] data_out4;
reg [WIDTH-1 :0] data_out5;
reg [WIDTH-1 :0] data_out6;
reg [WIDTH-1 :0] data_out7;
reg [WIDTH-1 :0] data_out8;

assign data_out_0 = data_out0;  
assign data_out_1 = data_out1;
assign data_out_2 = data_out2;
assign data_out_3 = data_out3;
assign data_out_4 = data_out4;
assign data_out_5 = data_out5;
assign data_out_6 = data_out6;
assign data_out_7 = data_out7;
assign data_out_8 = data_out8;






// Handle with Rows and Columns
//Get a curent position of the pixel
always @(posedge clk) begin
    if (reset) begin
        iRows <= 0;
        iCols <= 0;
        
    end else begin
        if (data_out_done ==1) begin
            iCols <= (iCols ==COLS-1) ? 0:iCols+1;
            if (iCols ==COLS-1) begin
                iRows <= (iRows==ROWS-1) ? 0:iRows + 1;
            end 
        end 
    end  
end

// Handle with 9 out[ut data




assign data_out_done = (cnt ==2) ? 1:0;

always @(posedge clk) begin
    if (reset) begin
        cnt <= 0;
    end else begin
        if (data_in_valid ==1) begin
            cnt <= (cnt ==2)? cnt: cnt+1;
        end 
        
    end         

end

always @(*) begin
    if (reset) begin
        data_out0<=0;
        data_out1<=0;
        data_out2<=0;
        data_out3<=0;
        data_out4<=0;
        data_out5<=0;
        data_out6<=0;
        data_out7<=0;
        data_out8<=0;
    end  else begin
        if (data_out_done==1) begin
            // Position 1           
            if (iRows ==0 && iCols ==0) 
            begin  
                // 0  0  0  0    1st row is zero  
                // 0 d4 d5  0    1st col is zero
                // 0 d7 d8  0
                
                data_out0<=0;
                data_out1<=0;
                data_out2<=0;
                data_out3<=0;
                data_out4<=data_4;
                data_out5<=data_5;
                data_out6<=0;
                data_out7<=data_7;
                data_out8<=data_8;
            
            end 
            else if (iRows ==0 && iCols >0 && iCols < COLS-1) 
            begin  //Position2  
            // 0  0  0  0    1st row is zero  
            // d3 d4 d5  0    1st col is zero
            // d6 d7 d8  0
            
                data_out0<=0;
                data_out1<=0;
                data_out2<=0;
                data_out3<=data_3;
                data_out4<=data_4;
                data_out5<=data_5;
                data_out6<=data_6;
                data_out7<=data_7;
                data_out8<=data_8;

            end 
            else if (iRows ==0 && iCols == COLS-1) 
            begin  //Position3
                  
                // 0 0  0  0  0    1st row is zero  
                //     d3 d4  0    1st col is zero
                //     d6 d7  0  
                
                data_out0<=0;
                data_out1<=0;
                data_out2<=0;
                data_out3<=data_3;
                data_out4<=data_4;
                data_out5<=0;
                data_out6<=data_6;
                data_out7<=data_7;
                data_out8<=0;
            end 
            else if (iRows >0 && iRows < ROWS-1 && iCols ==0) 
            begin  //Position 4
                //0  d1 d2      1st row is zero  
                // 0  d4 d5      1st col is zero
                // 0  d7 8    
            
                data_out0<=0;
                data_out1<=data_1;
                data_out2<=data_2;
                data_out3<=0;
                data_out4<=data_4;
                data_out5<=data_5;
                data_out6<=0;
                data_out7<=data_7;
                data_out8<=data_8;
            end
            else if (iRows >0 && iRows < ROWS-1 && iCols >0 && iCols < COLS-1) 
            begin  //Position 5
                data_out0<=data_0;
                data_out1<=data_1;
                data_out2<=data_2;
                data_out3<=data_3;
                data_out4<=data_4;
                data_out5<=data_5;
                data_out6<=data_6;
                data_out7<=data_7;
                data_out8<=data_8;
            end                        
            else if (iRows > 0 && iRows < ROWS-1 &&  iCols == COLS-1) 
            begin  //Position 6
                data_out0<=data_0;
                data_out1<=data_1;
                data_out2<=0;
                data_out3<=data_3;
                data_out4<=data_4;
                data_out5<=0;
                data_out6<=data_6;
                data_out7<=data_7;
                data_out8<=0;
            end                        

            else if (iRows ==ROWS-1 && iCols ==0) 
            begin  //Position 7
                data_out0<=0;
                data_out1<=data_1;
                data_out2<=data_2;
                data_out3<=0;
                data_out4<=data_4;
                data_out5<=data_5;
                data_out6<=0;
                data_out7<=0;
                data_out8<=0;
            end                        
            else if (iRows == ROWS-1  && iCols >0 && iCols < COLS-1) 
            begin  //Position 8
                data_out0<=data_0;
                data_out1<=data_1;
                data_out2<=data_2;
                data_out3<=data_3;
                data_out4<=data_4;
                data_out5<=data_5;
                data_out6<=0;
                data_out7<=0;
                data_out8<=0;
            end                        
            else if (iRows ==ROWS-1  && iCols == COLS-1)
            begin  //Position 9
                data_out0<=data_0;
                data_out1<=data_1;
                data_out2<=0;
                data_out3<=data_3;
                data_out4<=data_4;
                data_out5<=0;
                data_out6<=0;
                data_out7<=0;
                data_out8<=0;
            end                        
                        
        end 
 
    end 

end 

// This is a shift data 
always @(posedge clk) begin
    if (reset) begin
        data_0 <= 0;
        data_1 <= 0;
        data_2 <= 0;
        data_3 <= 0;
        data_4 <= 0;
        data_5 <= 0;
        data_6 <= 0;
        data_7 <= 0;
        data_8 <= 0;
    end else begin
        // begin to shift look in to the picture
        if (data_in_valid==1) begin
            data_0<= data_1;
            data_1<= data_2;
            data_2<= data_in_2;
            
            data_3<= data_4;
            data_4<= data_5;
            data_5<= data_in_1;

            data_6<= data_7;
            data_7<= data_8;
            data_8<= data_in_0;

            
            
            
        end  
    end
    
    
     
end 


endmodule
