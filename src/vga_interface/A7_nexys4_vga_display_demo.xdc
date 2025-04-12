## https://github.com/Digilent/digilent-xdc/blob/master/Nexys-4-Master.xdc    
## This file is a general .xdc for the Nexys4 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Revised test_nexys4_verilog.xdc to suit ee354_detour_top.xdc 
## Basically commented out the unused 15 switches Sw15-Sw1 
##           and also commented out the four buttons BtnL, BtnU, BtnR, and BtnD
## Gandhi 1/21/2020

# Clock signal
#Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports ClkPort]							
	set_property IOSTANDARD LVCMOS33 [get_ports ClkPort]
	create_clock -add -name ClkPort -period 10.00 [get_ports ClkPort]

#7 segment display
#Bank = 34, Pin name = IO_L2N_T0_34,						Sch name = Ca
set_property PACKAGE_PIN L3 [get_ports {Ca}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Ca}]
#Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = Cb
set_property PACKAGE_PIN N1 [get_ports {Cb}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Cb}]
#Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = Cc
set_property PACKAGE_PIN L5 [get_ports {Cc}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Cc}]
#Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = Cd
set_property PACKAGE_PIN L4 [get_ports {Cd}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Cd}]
#Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = Ce
set_property PACKAGE_PIN K3 [get_ports {Ce}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Ce}]
#Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = Cf
set_property PACKAGE_PIN M2 [get_ports {Cf}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Cf}]
#Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = Cg
set_property PACKAGE_PIN L6 [get_ports {Cg}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Cg}]

#Bank = 34, Pin name = IO_L16P_T2_34,						Sch name = Dp
set_property PACKAGE_PIN M4 [get_ports Dp]							
	set_property IOSTANDARD LVCMOS33 [get_ports Dp]

#Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = An0
set_property PACKAGE_PIN N6 [get_ports {An0}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An0}]
#Bank = 34, Pin name = IO_L18P_T2_34,						Sch name = An1
set_property PACKAGE_PIN M6 [get_ports {An1}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An1}]
#Bank = 34, Pin name = IO_L4P_T0_34,						Sch name = An2
set_property PACKAGE_PIN M3 [get_ports {An2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An2}]
#Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name = An3
set_property PACKAGE_PIN N5 [get_ports {An3}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An3}]
#Bank = 34, Pin name = IO_L3P_T0_DQS_34,					Sch name = An4
set_property PACKAGE_PIN N2 [get_ports {An4}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An4}]
#Bank = 34, Pin name = IO_L16N_T2_34,						Sch name = An5
set_property PACKAGE_PIN N4 [get_ports {An5}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An5}]
#Bank = 34, Pin name = IO_L1P_T0_34,						Sch name = An6
set_property PACKAGE_PIN L1 [get_ports {An6}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An6}]
#Bank = 34, Pin name = IO_L1N_T034,							Sch name = An7
set_property PACKAGE_PIN M1 [get_ports {An7}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {An7}]



#Buttons
##Bank = 15, Pin name = IO_L3P_T0_DQS_AD1P_15,				Sch name = CPU_RESET
#set_property PACKAGE_PIN C12 [get_ports btnCpuReset]				
#	set_property IOSTANDARD LVCMOS33 [get_ports btnCpuReset]
# Bank = 15, Pin name = IO_L11N_T1_SRCC_15,					Sch name = BTNC
set_property PACKAGE_PIN E16 [get_ports BtnC]						
	set_property IOSTANDARD LVCMOS33 [get_ports BtnC]
#Bank = 15, Pin name = IO_L14P_T2_SRCC_15,					Sch name = BTNU
set_property PACKAGE_PIN F15 [get_ports BtnU]						
	set_property IOSTANDARD LVCMOS33 [get_ports BtnU]

##VGA Connector
##Bank = 35, Pin name = IO_L8N_T1_AD14N_35,					Sch name = VGA_R0
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
##Bank = 15, Pin name = IO_L4P_T0_15,						Sch name = VGA_HS
set_property PACKAGE_PIN B11 [get_ports hSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports hSync]
##Bank = 15, Pin name = IO_L3N_T0_DQS_AD1N_15,				Sch name = VGA_VS
set_property PACKAGE_PIN B12 [get_ports vSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports vSync]

set_property PACKAGE_PIN L13 [get_ports QuadSpiFlashCS]					
	set_property IOSTANDARD LVCMOS33 [get_ports QuadSpiFlashCS]

#Bank = 14, Pin name = IO_L4P_T0_D04_14,					Sch name = CRAM_CEN
set_property PACKAGE_PIN L18 [get_ports RamCS]					
	set_property IOSTANDARD LVCMOS33 [get_ports RamCS]
##Bank = 15, Pin name = IO_L19P_T3_A22_15,					Sch name = CRAM_CRE
#set_property PACKAGE_PIN J14 [get_ports RamCRE]					
	#set_property IOSTANDARD LVCMOS33 [get_ports RamCRE]
#Bank = 15, Pin name = IO_L15P_T2_DQS_15,					Sch name = CRAM_OEN
set_property PACKAGE_PIN H14 [get_ports MemOE]					
	set_property IOSTANDARD LVCMOS33 [get_ports MemOE]
#Bank = 14, Pin name = IO_0_14,								Sch name = CRAM_WEN
set_property PACKAGE_PIN R11 [get_ports MemWR]					
	set_property IOSTANDARD LVCMOS33 [get_ports MemWR]