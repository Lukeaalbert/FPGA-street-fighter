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
    input p1_left_btn, p1_right_btn, p1_up_btn, p1_down_btn, p1_attack_btn, p1_shield_btn,
    input p2_left_btn, p2_right_btn, p2_up_btn, p2_down_btn, p2_attack_btn, p2_shield_btn,
    
    //Player data
    output [7:0] p1_health, p1_shield, //for vga_top to render health/shield bars
    output [7:0] p2_health, p2_shield, //for vga_top to render health/shield bars

    output [9:0] p1_x, p1_y, //holds top-left pixel of p1
    output [9:0] p2_x, p2_y, //holds top-left pixel of p2


);

parameter ground_height = 128;
parameter character_width = 128;
parameter character_height = 128;


//Player 1
wire p1_attack_request, p1_left_request, p1_right_request, p1_jump_request;
player p1(
    .clk(clk),
    .reset(reset),
    .player(1'b0),
    .left_btn(p1_left_btn), .right_btn(p1_right_btn), .up_btn(p1_up_btn), .down_btn(p1_down_btn), .attack_btn(p1_attack_btn), .shield_btn(p1_shield_btn),
    .health(p1_health), .shield(p1_shield),
    .attack_request(p1_attack_request), .left_request(p1_left_request), .right_request(.p1_right_request), .jump_request(p1_jump_request)
);

//Player 2
wire p2_attack_request, p2_left_request, p2_right_request, p2_jump_request;
player p2(
    .clk(clk),
    .reset(reset),
    .player(1'b1),
    .left_btn(p2_left_btn), .right_btn(p2_right_btn), .up_btn(p2_up_btn), .down_btn(p2_down_btn), .attack_btn(p2_attack_btn), .shield_btn(p2_shield_btn),
    .health(p2_health), .shield(p2_shield),
    .attack_request(p2_attack_request), .left_request(p2_left_request), .right_request(p2_right_request), .jump_request(p2_jump_request)
);



always@(negedge reset) begin
    p1_health <= 8'd0;
    p1_shield <= 8'd0;
    p2_health <= 8'd100;
    p2_shield <= 8'd100;
    p1_x      <= (357 - (character_width / 2 )); //Left Third
    p2_x      <= (570 - (character_width / 2 )); //Right Third
    p1_y      <= ground_height + character_height; //Above Ground
    p2_y      <= ground_height + character_height; //Above Ground;
end

wire slowed_walk_clk;
main_clk_to_slowed_clk walk_clk(
    .clk_in(clock),
    rst_l(reset),
    clk_out(slowed_walk_clk)
    max_count(800_000) //is this right? for 80hz
);

//Positioning
always@(posedge slowed_walk_clk) begin

end


endmodule