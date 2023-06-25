file mkdir out
file mkdir work
vlib work

vlog filter_mod.v

vlog buffer_controller.v

vlog channels2RGB.v

vlog data_modulate.v

vlog filter_data_buffer.v

vlog filter_kernel.v

vlog rgb2gray.v

vlog line_buffer.v

vlog mult_addition2.v

vlog tb.v

vsim -gui work.tb

run -all

exit