set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 5.000 -name sys_clk_pin -waveform {0.000 2.500} [get_ports clk]

set_false_path -from [get_ports data_in] -to [get_ports data_out]
