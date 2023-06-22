# About

This code was written for an image processing module that accepts RGB888 image with different resolution. 

To do so, an image is parsing into the filtee_mod.v (Verilog file - top level). 
RGB is spliting into 3 channel. All three chanels are parsing though sharpening filter kernel.
Then it saves in BMP format with the same resolution.

# Requirements

Verilog files were tested in Vivado and Modelsim. 

# Quick Start 


to run simulation 

    vsim -c -do run_sim.do



Soursed Image
<img src="test/source_rgb_512.bmp" width="900">

Processed Image using FPGA

<img src="test/sharpened_fpga_rgb_512.bmp" width="900">