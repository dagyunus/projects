set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 5.000 -name sys_clk_pin -waveform {0.000 2.500} [get_ports clk]
set_false_path -from [get_cells XILINX_GEN.sync_regs_reg[*]] -to [get_ports rst_out]
