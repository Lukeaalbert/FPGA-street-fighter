`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: controller_top.v 
// Description: top-level module for interfacing with joystick and buttons on nexys A7
//////////////////////////////////////////////////////////////////////////////////
module controller_top(
    input clk, // Main clock
    input jx1_left,
    input jx2_right,
    input jx3_up,
    input jx4_down,
    input jx9_attack,
    input jx10_shield,
    output [6:0] led
);

// controller instanciation
controller p1_controller (
    .clk(clk),
    .left_l(jx1_left),
    .right_l(jx2_right),
    .up_l(jx3_up),
    .down_l(jx4_down),
    .attack(jx9_attack),
    .shield(jx10_shield),
    .led_outputs(led)
);

endmodule
