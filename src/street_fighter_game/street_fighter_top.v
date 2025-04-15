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
    //VGA signals
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
);

// player 1 input signals
wire [6:0] player1_inputs;
// VGA wiring
wire bright;
wire [9:0] hc, vc;
wire [11:0] rgb;
// player state
reg [9:0] player_x = 300;
reg [9:0] player_y = 300;

// wayyyy slowed clock (50hz) for player left and right movement logic
wire clk_fifty_hz;
parameter integer fifty_hz_clk_max_count = 1_000_000;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ---------------------- Create Player 1 Controller Module --------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

// controller instanciation.
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

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ---------------------- Create Player 1 Movement Logic -----------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

// generating 50hz clock for player left and right movement updates. (START)
	
main_clk_to_slowed_clk #(
    .max_count(fifty_hz_clk_max_count)
) p1_l_r_clk (
    .clk_in(clk),
    .rst_l(rst_l),
    .clk_out(clk_fifty_hz)
);
    
// generating 50hz clock for player left and right movement updates. (END)

// movement logic
always @(posedge clk_fifty_hz) begin 
    if (rst_l == 0) begin // reset is active low
        player_x <= 300;
        player_y <= 300;
    end else begin
        if (player1_inputs[1]) player_y <= player_y + 1; // down
        else if (player1_inputs[2]) player_x <= player_x + 1; // right
        else if (player1_inputs[3]) player_y <= player_y - 1; // up
        else if (player1_inputs[4]) player_x <= player_x - 1; // left
    end
end

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
    .player_x(player_x),
    .player_y(player_y),
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
