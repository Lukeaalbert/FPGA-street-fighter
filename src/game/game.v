`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Kasra Farsoudi
// Create Date: 04/12/2025
// File Name: game.v 
// Description: core game code that handles collisions, health, shields, movement
//////////////////////////////////////////////////////////////////////////////////

module game(
    input clk,        // Clock signal
    input reset,      // Reset signal

    //Player controls
    input [6:0] p1_inputs,
    input [6:0] p2_inputs,
    
    //Player data
    output reg [7:0] p1_health, p1_shield, //for vga_top to render health/shield bars
    output reg [7:0] p2_health, p2_shield, //for vga_top to render health/shield bars

    output reg [9:0] p1_x, p1_y, //holds top-left pixel of p1
    output reg [9:0] p2_x, p2_y, //holds top-left pixel of p2

    output wire [6:0] p1_action, // Changed from wire to reg
    output wire [6:0] p2_action  // Changed from wire to reg
);

parameter ground_height = 128;
parameter character_width = 128;
parameter character_height = 128;

//inout to invidiual wires
wire p1_left_btn   = p1_inputs[1];
wire p1_right_btn  = p1_inputs[2];
wire p1_up_btn     = p1_inputs[3];
wire p1_down_btn   = p1_inputs[4];
wire p1_attack_btn = p1_inputs[5];
wire p1_shield_btn = p1_inputs[6];
wire p1_center_btn = p1_inputs[0];

wire p2_left_btn   = p1_inputs[1];
wire p2_right_btn  = p1_inputs[2];
wire p2_up_btn     = p1_inputs[3];
wire p2_down_btn   = p1_inputs[4];
wire p2_attack_btn = p1_inputs[5];
wire p2_shield_btn = p1_inputs[6];
wire p2_center_btn = p1_inputs[0];



//Player 1
wire p1_attack_request, p1_left_request, p1_right_request, p1_jump_request;
player p1(
    .clk(clk),
    .reset(reset),
    .player(1'b0),
    .left_btn(p1_left_btn), .right_btn(p1_right_btn), .up_btn(p1_up_btn), .down_btn(p1_down_btn), .attack_btn(p1_attack_btn), .shield_btn(p1_shield_btn),
    .health(p1_health), .shield(p1_shield),
    .attack_request(p1_attack_request), .left_request(p1_left_request), .right_request(p1_right_request), .jump_request(p1_jump_request),
    .action(p1_action)
);

//Player 2
wire p2_attack_request, p2_left_request, p2_right_request, p2_jump_request;
player p2(
    .clk(clk),
    .reset(reset),
    .player(1'b1),
    .left_btn(p2_left_btn), .right_btn(p2_right_btn), .up_btn(p2_up_btn), .down_btn(p2_down_btn), .attack_btn(p2_attack_btn), .shield_btn(p2_shield_btn),
    .health(p2_health), .shield(p2_shield),
    .attack_request(p2_attack_request), .left_request(p2_left_request), .right_request(p2_right_request), .jump_request(p2_jump_request),
    .action(p2_action) 
);


// AABB Collision Detection
wire collision_x, collision_y, collision;
assign collision_x = (p1_x < p2_x + character_width) && (p1_x + character_width > p2_x);
assign collision_y = (p1_y == p2_y); // Players must be on the same vertical level
assign collision = collision_x && collision_y;

always @(posedge clk) begin
    if (!reset) begin // Active low reset
        p1_health <= 8'd15;
        p1_shield <= 8'd15;
        p2_health <= 8'd15;
        p2_shield <= 8'd15;
        p1_x      <= (357 - (character_width / 2 )); //Left Third
        p2_x      <= (570 - (character_width / 2 )); //Right Third
        p1_y      <= ground_height + character_height; //Above Ground
        p2_y      <= ground_height + character_height; //Above Ground;
    end
end

wire slowed_walk_clk;
main_clk_to_slowed_clk #(.max_count(800_000)) walk_clk(
    .clk_in(clk),
    .rst_l(reset),
    .clk_out(slowed_walk_clk)
);

//Positioning
always @(posedge slowed_walk_clk) begin
        // Player 1 movement
        if (p1_left_request && p1_x > 0 && !(collision && p1_x - 1 + character_width > p2_x))
            p1_x <= p1_x - 1;
        else if (p1_right_request && p1_x < 1024 - character_width && !(collision && p1_x + 1 < p2_x + character_width))
            p1_x <= p1_x + 1;

        // Player 2 movement
        if (p2_left_request && p2_x > 0 && !(collision && p2_x - 1 + character_width > p1_x))
            p2_x <= p2_x - 1;
        else if (p2_right_request && p2_x < 1024 - character_width && !(collision && p2_x + 1 < p1_x + character_width))
            p2_x <= p2_x + 1;
end

endmodule