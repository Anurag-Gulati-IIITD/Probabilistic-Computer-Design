create_clock -period 10 [get_ports CLK]
set_property IOSTANDARD LVCMOS18 [get_ports *]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
