# 100 MHz clock
set_property PACKAGE_PIN E3 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name clk -period 10.00 [get_ports clk]

# Rst
set_property PACKAGE_PIN C12 [get_ports rst_l]
set_property IOSTANDARD LVCMOS33 [get_ports rst_l]

# VGA Synch signals
set_property PACKAGE_PIN B11 [get_ports hSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports hSync]
set_property PACKAGE_PIN B12 [get_ports vSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports vSync]

# Strange but maybe necessary other signals for VGA?
set_property PACKAGE_PIN H14 [get_ports MemOE]					
	set_property IOSTANDARD LVCMOS33 [get_ports MemOE]
set_property PACKAGE_PIN R11 [get_ports MemWR]					
	set_property IOSTANDARD LVCMOS33 [get_ports MemWR]
set_property PACKAGE_PIN L13 [get_ports QuadSpiFlashCS]					
	set_property IOSTANDARD LVCMOS33 [get_ports QuadSpiFlashCS]
set_property PACKAGE_PIN L18 [get_ports RamCS]					
	set_property IOSTANDARD LVCMOS33 [get_ports RamCS]

# VGA RGB Signals
set_property PACKAGE_PIN A3 [get_ports {vgaR[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[0]}]
##Bank = 35, Pin name = IO_L7N_T1_AD6N_35,					Sch name = VGA_R1
set_property PACKAGE_PIN B4 [get_ports {vgaR[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[1]}]
##Bank = 35, Pin name = IO_L1N_T0_AD4N_35,					Sch name = VGA_R2
set_property PACKAGE_PIN C5 [get_ports {vgaR[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[2]}]
##Bank = 35, Pin name = IO_L8P_T1_AD14P_35,					Sch name = VGA_R3
set_property PACKAGE_PIN A4 [get_ports {vgaR[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[3]}]
##Bank = 35, Pin name = IO_L2P_T0_AD12P_35,					Sch name = VGA_B0
set_property PACKAGE_PIN B7 [get_ports {vgaB[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[0]}]
##Bank = 35, Pin name = IO_L4N_T0_35,						Sch name = VGA_B1
set_property PACKAGE_PIN C7 [get_ports {vgaB[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[1]}]
##Bank = 35, Pin name = IO_L6N_T0_VREF_35,					Sch name = VGA_B2
set_property PACKAGE_PIN D7 [get_ports {vgaB[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[2]}]
##Bank = 35, Pin name = IO_L4P_T0_35,						Sch name = VGA_B3
set_property PACKAGE_PIN D8 [get_ports {vgaB[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[3]}]
##Bank = 35, Pin name = IO_L1P_T0_AD4P_35,					Sch name = VGA_G0
set_property PACKAGE_PIN C6 [get_ports {vgaG[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[0]}]
##Bank = 35, Pin name = IO_L3N_T0_DQS_AD5N_35,				Sch name = VGA_G1
set_property PACKAGE_PIN A5 [get_ports {vgaG[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[1]}]
##Bank = 35, Pin name = IO_L2N_T0_AD12N_35,					Sch name = VGA_G2
set_property PACKAGE_PIN B6 [get_ports {vgaG[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[2]}]
##Bank = 35, Pin name = IO_L3P_T0_DQS_AD5P_35,				Sch name = VGA_G3
set_property PACKAGE_PIN A6 [get_ports {vgaG[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[3]}]

## stuff for player 1:

## Joystick Inputs
set_property PACKAGE_PIN C17 [get_ports jx1_left]
set_property IOSTANDARD LVCMOS33 [get_ports jx1_left]

set_property PACKAGE_PIN D18 [get_ports jx2_right]
set_property IOSTANDARD LVCMOS33 [get_ports jx2_right]

set_property PACKAGE_PIN E18 [get_ports jx3_up]
set_property IOSTANDARD LVCMOS33 [get_ports jx3_up]

set_property PACKAGE_PIN G17 [get_ports jx4_down]
set_property IOSTANDARD LVCMOS33 [get_ports jx4_down]

## Buttons
set_property PACKAGE_PIN F18 [get_ports jx9_attack]
set_property IOSTANDARD LVCMOS33 [get_ports jx9_attack]

set_property PACKAGE_PIN G18 [get_ports jx10_shield]
set_property IOSTANDARD LVCMOS33 [get_ports jx10_shield]