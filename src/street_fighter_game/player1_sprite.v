`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Luke Albert
// Create Date: 04/13/2025
// File Name: player1_sprite.v 
// Description: controls all the other sprites and returns the pixel data bits
// to display
//
//////////////////////////////////////////////////////////////////////////////////
module player1_sprite (
    input wire clk,
    // 14 bits to cover 0 - 16383
    input wire [13:0] addr,
    input wire [6:0] player1_inputs,
    // RGB 4:4:4 format
    output reg [11:0] pixel_data
);

// wires containing different sprite pixel info at current clk
wire [11:0] standing_pixel_data;
wire [11:0] walking1_pixel_data;
wire [11:0] walking2_pixel_data;
wire [11:0] crouching_pixel_data;

// standing
p1_standing p1_standing_sprite (
    .clk(clk),
    .addr(addr),
    .pixel_data(standing_pixel_data)
);

// walking frame 1
p1_walking1 p1_walking1_sprite (
    .clk(clk),
    .addr(addr),
    .pixel_data(walking1_pixel_data)
);

// walking frame 2
p1_walking2 p1_walking2_sprite (
    .clk(clk),
    .addr(addr),
    .pixel_data(walking2_pixel_data)
);

// crouching
p1_crouching p1_crouching_sprite (
    .clk(clk),
    .addr(addr),
    .pixel_data(crouching_pixel_data)
);

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
    if (player1_inputs[1] || player1_inputs[2]) begin // walking left or right
        if (switch_animation == 1) pixel_data <= walking1_pixel_data;
        else pixel_data <= walking2_pixel_data;
    end // standing
    else if (player1_inputs[4]) pixel_data <= crouching_pixel_data; // crouching
    else pixel_data <= standing_pixel_data;
end


endmodule