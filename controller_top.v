`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: top_controller.v 
// Description: top-level module for interfacing with joystick and buttons on nexys A7
//////////////////////////////////////////////////////////////////////////////////
module top_controller(
    input clk, // Main clock
    input jx1_left,
    input jx2_right,
    input jx3_up,
    input jx4_down,
    input jx9_attack,
    input jx10_pery,
    output [6:0] led
);

// controller instanciation
controller u_controller (
    .clk(clk),
    .left(jx1_left),
    .right(jx2_right),
    .up(jx3_up),
    .down(jx4_down),
    .attack(jx9_attack),
    .pery(jx10_pery),
    .led_outputs(led)
);

endmodule
