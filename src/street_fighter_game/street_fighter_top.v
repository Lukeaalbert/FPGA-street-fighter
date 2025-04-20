`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: street_fighter_top.v 
// Description: THE GAME!
//////////////////////////////////////////////////////////////////////////////////
module street_fighter_top(
    input clk, // Main clock
    input rst_l, // Main reset
    // input controller naming convention:
    // "inputpin_controlsignal".
    // Player 1 signals
    input jx1_left,
    input jx2_right,
    input jx3_up,
    input jx4_down,
    input jx9_attack,
    input jx10_shield,
    // Player 2 signals
    input jd1_left,
    input jd2_right,
    input jd3_up,
    input jd4_down,
    input jd9_attack,
    input jd10_shield,
    //VGA signals
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
);

// player 1 input signals
wire [6:0] player1_inputs;
// player 2 input signals
wire [6:0] player2_inputs;
// VGA wiring
wire bright;
wire [9:0] hc, vc;
wire [11:0] rgb;

// wayyyy slowed clock (about 70hz) for player left and right movement logic
wire clk_player_movement;
parameter integer player_movement_clk_max_count = 714_285;

//player data (game core -> vga core)
wire [7:0] p1_health, p1_shield, p2_health, p2_shield;
wire [9:0] p1_x, p1_y, p2_x, p2_y;
wire [6:0] p1_action, p2_action;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ---------------------- Create Player 1 Controller Module --------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

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

controller p2_controller(
    .clk(clk),
    .left_l(jd1_left),
    .right_l(jd2_right),
    .up_l(jd3_up),
    .down_l(jd4_down),
    .attack(jd9_attack),
    .shield(jd10_shield),
    .controller_inputs(player2_inputs)
);

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ---------------------- Game Module for Next Frame Logic ---------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

game core_game(
    .clk(clk),
    .reset(rst_l),
    .p1_inputs(player1_inputs),
    .p2_inputs(player2_inputs),
    .p1_health(p1_health),
    .p1_shield(p1_shield),
    .p2_health(p2_health),
    .p2_shield(p2_shield),
    .p1_x(p1_x),
    .p1_y(p1_y),
    .p2_x(p2_x),
    .p2_y(p2_y),
    .p1_action(p1_action),
    .p2_action(p2_action)
);


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ---------------------- Generate stuff for the module that -------------------
// ---------------------- (1) scans through the display ------------------------
// ---------------------- (2) renders the display using rbg vals ---------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
display_controller dc(
    .clk(clk),
    .hSync(hSync),
    .vSync(vSync),
    .bright(bright),
    .hCount(hc),
    .vCount(vc)
);
vga_bitchange vbc(
    .clk(clk),
    .bright(bright),
    .rst_l(rst_l),
    .hCount(hc),
    .vCount(vc),
    .p1_x(p1_x),
    .p1_y(p1_y),
    .p2_x(p2_x),
    .p2_y(p2_y),
    .p1_action(p1_action),
    .p2_action(p2_action),
    .rgb(rgb)
);

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ----- Finally, assign the VGA's pixels the correct rgb values generated -----
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
assign vgaR = rgb[11 : 8];
assign vgaG = rgb[7  : 4];
assign vgaB = rgb[3  : 0];

assign MemOE = 1;
assign MemWR = 1;
assign RamCS = 1;
assign QuadSpiFlashCS = 1;

endmodule
