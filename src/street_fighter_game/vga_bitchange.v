`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: vga_bitchange.v 
// Description: basically, just generates the RGB values 
// once every posedge for EACH pixle in the VGA while scanning.
//
// tl;dr: generates the RGB "graphics" values for VGA screen.
//
// attempting to draw background http://i.imgur.com/Te9mt.png
//////////////////////////////////////////////////////////////////////////////////

module vga_bitchange(
    input wire clk,
    input wire bright,
    input wire rst_l,
    input wire [9:0] hCount,
    input wire [9:0] vCount,
    input wire [9:0] player_x,
    input wire [9:0] player_y,
    input wire [11:0] sprite_pixel,
    output reg [11:0] rgb,
    output reg [11:0] sprite_addr
);

    // colors
    parameter BLACK = 12'b0000_0000_0000;

    // sprite dimensions (change later)
    parameter SPRITE_WIDTH = 32;
    parameter SPRITE_HEIGHT = 32;

    // calculate the sprite region (true/false if its is currently
    // on the VGA display at hCount x vCount)
    wire sprite_region;
    assign sprite_region = (hCount >= player_x && hCount < player_x + SPRITE_WIDTH &&
                            vCount >= player_y && vCount < player_y + SPRITE_HEIGHT);
    
    // generate sprite x and y vals used to calculate the sprite_addr
    wire [4:0] sprite_x = hCount - player_x;
    wire [4:0] sprite_y = vCount - player_y;

    sprite_rom sprite_memory (
    .clk(clk),
    .addr(sprite_addr),
    .pixel_data(sprite_pixel)
    );

    always @(*) begin
        if (!bright) begin
            rgb = BLACK;
        end
        else if (sprite_region) begin
            sprite_addr = sprite_y * SPRITE_WIDTH + sprite_x;
            rgb = sprite_pixel;
        end
        else if (vCount < 394) begin
            rgb[11:8] = 4'd0;
            rgb[7:4]  = 4'd0;
            rgb[3:0]  = (vCount >> 4 > 15) ? 4'd15 : vCount[7:4];
        end
        else begin
            rgb[11:8] = 4'd0;
            rgb[7:4]  = 4'd8 + ((hCount[4] ^ vCount[3]) ? 4'd4 : 4'd0);
            rgb[3:0]  = 4'd1;
        end
    end

endmodule
