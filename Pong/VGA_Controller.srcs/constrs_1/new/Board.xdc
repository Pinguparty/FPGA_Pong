set_property CFGBVS Vcco [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property PACKAGE_PIN E3 [get_ports clk100Mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk100Mhz]

set_property PACKAGE_PIN C12 [get_ports nreset]
set_property IOSTANDARD LVCMOS33 [get_ports nreset]

set_property PACKAGE_PIN T8 [get_ports {led[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
##Bank = 34, Pin name = IO_L21N_T3_DQS_34,					Sch name = LED1
set_property PACKAGE_PIN V9 [get_ports {led[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
##Bank = 34, Pin name = IO_L24P_T3_34,						Sch name = LED2
set_property PACKAGE_PIN R8 [get_ports {led[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
##Bank = 34, Pin name = IO_L23N_T3_34,						Sch name = LED3
set_property PACKAGE_PIN T6 [get_ports {led[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
##Bank = 34, Pin name = IO_L12P_T1_MRCC_34,					Sch name = LED4
set_property PACKAGE_PIN T5 [get_ports {led[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]

# Color
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGB[11]}]

set_property PACKAGE_PIN A3 [get_ports {RGB[0]}]
set_property PACKAGE_PIN B4 [get_ports {RGB[1]}]
set_property PACKAGE_PIN C5 [get_ports {RGB[2]}]
set_property PACKAGE_PIN A4 [get_ports {RGB[3]}]
set_property PACKAGE_PIN B7 [get_ports {RGB[4]}]
set_property PACKAGE_PIN C7 [get_ports {RGB[5]}]
set_property PACKAGE_PIN D7 [get_ports {RGB[6]}]
set_property PACKAGE_PIN D8 [get_ports {RGB[7]}]
set_property PACKAGE_PIN C6 [get_ports {RGB[8]}]
set_property PACKAGE_PIN A5 [get_ports {RGB[9]}]
set_property PACKAGE_PIN B6 [get_ports {RGB[10]}]
set_property PACKAGE_PIN A6 [get_ports {RGB[11]}]

# Sync
set_property IOSTANDARD LVCMOS33 [get_ports HSync]
set_property IOSTANDARD LVCMOS33 [get_ports VSync]

set_property PACKAGE_PIN B11 [get_ports HSync]
set_property PACKAGE_PIN R12 [get_ports VSync]


