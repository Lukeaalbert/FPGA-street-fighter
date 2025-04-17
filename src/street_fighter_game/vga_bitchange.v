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

    input wire [3:0] p1_health,
    input wire [3:0] p1_shield,
    input wire [3:0] p2_health,
    input wire [3:0] p2_shield,

    input wire [9:0] player_x,
    input wire [9:0] player_y,
    input wire [11:0] sprite_pixel,

    //This is going to be removed soon, can keep for now for debugging purposes until game.v merged
    input wire [6:0] player1_inputs,
    
    output reg [11:0] rgb,
    output wire [13:0] sprite_addr
);

    // colors
    parameter BLACK = 12'b0000_0000_0000;

    // sprite dimensions
    // note: unique to 128 x 128 sized sprite
    parameter SPRITE_WIDTH = 128;
    parameter SPRITE_HEIGHT = 128;

    // calculate the sprite region (true/false if its is currently
    // on the VGA display at hCount x vCount)
    wire sprite_region;
    assign sprite_region = (hCount >= player_x && hCount < player_x + SPRITE_WIDTH &&
                            vCount >= player_y && vCount < player_y + SPRITE_HEIGHT);
    
    // generate sprite x and y vals used to calculate the sprite_addr
    // note: [6:0] size is unique to 128 x 128 sprites
    wire [6:0] sprite_x = hCount - player_x;
    wire [6:0] sprite_y = vCount - player_y;
    
    // always updated with most recent sprite region
    assign sprite_addr = (sprite_region) ? sprite_y * SPRITE_WIDTH + sprite_x : 14'd0;

    // p1 sprite
    player1_sprite p1_sprite (
        .clk(clk),
        .addr(sprite_addr),
        .player1_inputs(player1_inputs),
        .pixel_data(sprite_pixel)
    );

    always @(*) begin
        if (!bright) begin
            rgb = BLACK;
        end
        // note: 12 bit hex colors are unique to p1 download background
        else if (sprite_region
        && sprite_pixel != 12'h00D
        && sprite_pixel != 12'h00E
        && sprite_pixel != 12'h00F) begin
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