## Clock
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

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

set_property PACKAGE_PIN G18 [get_ports jx10_pery]
set_property IOSTANDARD LVCMOS33 [get_ports jx10_pery]

## LEDs (onboard, mapped to output[6:0])
set_property PACKAGE_PIN H17 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN K15 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN J13 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN N14 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

set_property PACKAGE_PIN R18 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]

set_property PACKAGE_PIN V17 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]

set_property PACKAGE_PIN U17 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
