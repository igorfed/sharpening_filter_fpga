ATTENTION.

To run simulation it is better to use ModelSim in sharpening_kernel

in the folder 512x512, 1920_1080 and 3840_2160 i did tes for different image with different resolution.

If you want to generate other image, You have to go to tb_filter_mod

and change the following lines:

`define soursed_image_name  "3840/source_rgb_3840_2160.bmp"
`define processed_image_name  "3840/sharpened_fpga_rgb_3840_2160.bmp"
`define processed_image_hex  "3840/sharpened_fpga_rgb_3840_2160.txt"

parameter WIDTH = 8, 
parameter DEPTH = 3840,
parameter ROWS =3840, 
parameter COLS = 2160 


the project is avalable in git@github.com:igorfed/sharpening_filter_fpga.git

