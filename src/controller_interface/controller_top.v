`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: controller_top.v 
// Description: top-level module for interfacing with joystick and buttons on nexys A7
//////////////////////////////////////////////////////////////////////////////////
module controller_top(
    input clk, // Main clock
    // input controller naming convention:
    // "inputpin_controlsignal"
    input jx1_left,
    input jx2_right,
    input jx3_up,
    input jx4_down,
    input jx9_attack,
    input jx10_shield
);

wire [6:0] player1_inputs;

// controller instanciation.
// note: at the moment, player 1 remote
// must be connected to JA port.
controller p1_controller (
    .clk(clk),
    .left_l(jx1_left),
    .right_l(jx2_right),
    .up_l(jx3_up),
    .down_l(jx4_down),
    .attack(jx9_attack),
    .shield(jx10_shield),
    .controller_inputs(player1_inputs)
);

endmodule
