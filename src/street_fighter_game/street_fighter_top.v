`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: street_fighter_top.v 
// Description: THE GAME!
//////////////////////////////////////////////////////////////////////////////////
module street_fighter_top(
    input clk, // Main clock
    input rst, // Main reset
    // input controller naming convention:
    // "inputpin_controlsignal".
    // Player 1 signals
    input jx1_left,
    input jx2_right,
    input jx3_up,
    input jx4_down,
    input jx9_attack,
    input jx10_shield,
    //VGA signals
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
);

// player 1 input signals
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

// everything below for VGA display
wire bright;
wire[9:0] hc, vc;
wire [11:0] rgb;
display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
vga_bitchange vbc(.clk(ClkPort), .bright(bright), .reset(rst), .hCount(hc), .vCount(vc), .rgb(rgb));

assign vgaR = rgb[11 : 8];
assign vgaG = rgb[7  : 4];
assign vgaB = rgb[3  : 0];

// disable memory ports
assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;

endmodule
