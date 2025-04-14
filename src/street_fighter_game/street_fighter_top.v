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

reg pulse; // TODO: delete me when done testing
reg clk25; // TODO: delete me when done testing

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

// TODO: Delete Me Later!!! Quick and dirty div clock for p1 movement. (START)

	initial begin // Set all of them initially to 0
		clk25 = 0;
		pulse = 0;
	end
	
	always @(posedge clk) // clk is 100MHZ
		pulse = ~pulse; // pulse is 50MHz (clock divider)
	always @(posedge pulse)
		clk25 = ~clk25; // thus, clk 25 is 25MHz (clock divider)
    
// TODO: Delete Me Later!!! Quick and dirty div clock for p1 movement. (END)

// movement logic
always @(posedge clk25) begin // TODO: change back to regular clk
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
