#===============================================================================
# CLOCK
#===============================================================================
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

#===============================================================================
# BUTTONS
#===============================================================================
# Center button
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Up button
set_property PACKAGE_PIN T18 [get_ports btn_start]
set_property IOSTANDARD LVCMOS33 [get_ports btn_start]

#===============================================================================
# SWITCHES
#===============================================================================

# Collision input (SW0)
set_property PACKAGE_PIN V17 [get_ports collision]
set_property IOSTANDARD LVCMOS33 [get_ports collision]

# ball_y[15:8] on SW15-SW8
set_property PACKAGE_PIN R2 [get_ports {ball_y[15]}]
set_property PACKAGE_PIN T1 [get_ports {ball_y[14]}]
set_property PACKAGE_PIN U1 [get_ports {ball_y[13]}]
set_property PACKAGE_PIN W2 [get_ports {ball_y[12]}]
set_property PACKAGE_PIN R3 [get_ports {ball_y[11]}]
set_property PACKAGE_PIN T2 [get_ports {ball_y[10]}]
set_property PACKAGE_PIN T3 [get_ports {ball_y[9]}]
set_property PACKAGE_PIN V2 [get_ports {ball_y[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ball_y[8]}]
#===============================================================================
# LEDs
#===============================================================================
set_property PACKAGE_PIN U14 [get_ports {game_state_led[0]}]
set_property PACKAGE_PIN U15 [get_ports {game_state_led[1]}]
set_property PACKAGE_PIN W18 [get_ports {game_state_led[2]}]
set_property PACKAGE_PIN U16 [get_ports game_reset_led]
set_property IOSTANDARD LVCMOS33 [get_ports {game_state_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {game_state_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {game_state_led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports game_reset_led]

#===============================================================================
# 7-SEGMENT DISPLAY
#===============================================================================

# Segments
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

# Anodes
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
