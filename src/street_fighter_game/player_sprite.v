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
    // active for only 1 clock when user should do attack animation
    input wire attack_grant,
    // is finished or not
    input wire [1:0] finish,
    // RGB 4:4:4 format
    output reg [11:0] pixel_data,
    // 1 -> enemy flashes red to displays taking damage
    output reg enemy_damage_animation
);

//Action Data
parameter WALKING =   6'b000001;
parameter CROUCHING = 6'b000010;
parameter STANDING =  6'b100000;
wire [5:0] input_action    = action[5:0];
wire input_direction = action[6];

// wires containing different sprite pixel info at current clk
wire [11:0] standing_pixel_data;
wire [11:0] walking1_pixel_data;
wire [11:0] walking2_pixel_data;
wire [11:0] attack_frame1_pixel_data;
wire [11:0] attack_frame2_pixel_data;
wire [11:0] crouching_pixel_data;

// state for attack animation
// 0 = idle, 1 = frame1, 2 = frame2
reg [1:0] attack_state;

// Counter for attack animation timing
// 24 bits ~0.25s at 100MHz
reg [23:0] attack_counter;

// constants
parameter ATTACK_IDLE = 2'd0;
parameter ATTACK_FRAME1 = 2'd1;
parameter ATTACK_FRAME2 = 2'd2;

// 0.1665s delay at 100MHz clock = 16_650_000 cycles
parameter ATTACK_FRAME_DURATION = 24'd16_650_000;

wire is_finished;
assign is_finished = finish[0];

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
    case (attack_state)
        ATTACK_IDLE: begin
            if (attack_grant) begin
                attack_state <= ATTACK_FRAME1;
                attack_counter <= 0;
            end
        end

        ATTACK_FRAME1: begin
            attack_counter <= attack_counter + 1;
            if (attack_counter >= ATTACK_FRAME_DURATION) begin
                attack_state <= ATTACK_FRAME2;
                attack_counter <= 0;
            end
        end

        ATTACK_FRAME2: begin
            attack_counter <= attack_counter + 1;
            enemy_damage_animation <= 1;
            if (attack_counter >= ATTACK_FRAME_DURATION) begin
                attack_state <= ATTACK_IDLE;
                attack_counter <= 0;
            end
        end
    endcase

    // output pixel based on action and attack animation state
    if (is_finished) begin // standing if finished
        pixel_data <= standing_pixel_data;
    end 
    else if (attack_state == ATTACK_FRAME1)
        pixel_data <= attack_frame1_pixel_data;
    else if (attack_state == ATTACK_FRAME2)
        pixel_data <= attack_frame2_pixel_data;
    else begin
        enemy_damage_animation <= 0;
        case (input_action) 
            WALKING: begin
                if (switch_animation) pixel_data <= walking1_pixel_data;
                else pixel_data <= walking2_pixel_data;
            end
            CROUCHING: pixel_data <= crouching_pixel_data;
            default: pixel_data <= standing_pixel_data;
        endcase
    end
end



endmodule