`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Luke Albert & Kasra Farsoudi
// Create Date: 04/13/2025
// File Name: player_sprite.v 
// Description: controls all the other sprites and returns the pixel data bits
// to display
//
//////////////////////////////////////////////////////////////////////////////////
module player_sprite #(
    // 1 -> player 1 sprite
    // 2 -> player 2 sprite
    parameter integer player_num = 1 // player 1
)(
    input wire clk,
    // 14 bits to cover 0 - 16383
    input wire [13:0] addr,
    //Action Input
    input wire [6:0] action,
    // RGB 4:4:4 format
    output reg [11:0] pixel_data
);

//Action Data
parameter WALKING =   6'b000001;
parameter CROUCHING = 6'b000010;
parameter SHIELDING = 6'b000100;
parameter JUMPING =   6'b001000;
parameter PUNCHING =  6'b010000;
parameter STANDING =  6'b100000;
wire [5:0] input_action    = action[5:0];
wire input_direction = action[6];

// wires containing different sprite pixel info at current clk
wire [11:0] standing_pixel_data;
wire [11:0] walking1_pixel_data;
wire [11:0] walking2_pixel_data;
wire [11:0] attack_frame1_pixel_data;
wire [11:0] attack_frame2_pixel_data;
wire [11:0] shield_pixel_data;
wire [11:0] crouching_pixel_data;

generate
    if (player_num == 1) begin : gen_p1
        // standing
        sprite_map  #(.FILENAME("p1_standing.mem")) p1_standing_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(standing_pixel_data)
        );

        // walking frame 1
        sprite_map  #(.FILENAME("p1_walking1.mem")) p1_walking1_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(walking1_pixel_data)
        );

        // walking frame 2
        sprite_map  #(.FILENAME("p1_walking2.mem")) p1_walking2_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(walking2_pixel_data)
        );

        // attack frame 1
        sprite_map  #(.FILENAME("p1_attack_frame1.mem")) p1_attack_frame1_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(attack_frame1_pixel_data)
        );

        // attack frame 2
        sprite_map  #(.FILENAME("p1_attack_frame2.mem")) p1_attack_frame2_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(attack_frame2_pixel_data)
        );

        // shield
        sprite_map  #(.FILENAME("p1_shield.mem")) p1_shield_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(shield_pixel_data)
        );

        // crouching
        sprite_map  #(.FILENAME("p1_crouching.mem")) p1_crouching_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(crouching_pixel_data)
        );
    end else if (player_num == 2) begin : gen_p2
        // standing
        sprite_map  #(.FILENAME("p2_standing.mem")) p2_standing_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(standing_pixel_data)
        );

        // walking frame 1
        sprite_map  #(.FILENAME("p2_walking1.mem")) p2_walking1_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(walking1_pixel_data)
        );

        // walking frame 2
        sprite_map  #(.FILENAME("p2_walking2.mem")) p2_walking2_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(walking2_pixel_data)
        );

        // attack frame 1
        sprite_map  #(.FILENAME("p2_attack_frame1.mem")) p2_attack_frame1_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(attack_frame1_pixel_data)
        );

        // attack frame 2
        sprite_map  #(.FILENAME("p2_attack_frame2.mem")) p2_attack_frame2_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(attack_frame2_pixel_data)
        );

        // shield
        sprite_map  #(.FILENAME("p2_shield.mem")) p2_shield_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(shield_pixel_data)
        );

        // crouching
        sprite_map  #(.FILENAME("p2_crouching.mem")) p2_crouching_sprite (
            .clk(clk),
            .addr(addr),
            .reverse(input_direction),
            .pixel_data(crouching_pixel_data)
        );
    end
endgenerate

// clock for toggleing sprite animation
wire sprite_animation_clk;
// always high signal
wire high = 1'b1;

// clock for walking animation logic
main_clk_to_slowed_clk #(
    .max_count(15_000_000)
) p1_animation_clock (
    .clk_in(clk),
    .rst_l(high),
    .clk_out(sprite_animation_clk)
);

// basically a bool
// t/f implies different frames in a 2 frame animation
reg switch_animation;

initial begin
    switch_animation = 0;
end

// toggle animation every sprite_animation_clk pulse
always @ (posedge sprite_animation_clk)
begin
    switch_animation <= ~switch_animation;
end

always @(posedge clk) begin
    case (input_action) 
        WALKING: begin
            if (switch_animation) pixel_data <= walking1_pixel_data;
            else pixel_data <= walking2_pixel_data;
        end
        CROUCHING: begin
            pixel_data <= crouching_pixel_data;
        end
        SHIELDING: begin
            pixel_data <= shield_pixel_data;
        end
        PUNCHING: begin
            if (switch_animation) pixel_data <= attack_frame1_pixel_data;
            else pixel_data <= attack_frame2_pixel_data;
        end
        default: begin
            pixel_data <= standing_pixel_data;
        end
    endcase
end


endmodule