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

    input wire [9:0] p1_x, p1_y, //holds top-left pixel of p1
    input wire [9:0] p2_x, p2_y, //holds top-left pixel of p2

    input wire [11:0] p1_action, //rgb for p1
    input wire [11:0] p2_action, //rgb for p2


    output reg [11:0] rgb

);

    // colors
    parameter BLACK = 12'b0000_0000_0000;

    // sprite dimensions
    // note: unique to 128 x 128 sized sprite
    parameter SPRITE_WIDTH = 128;
    parameter SPRITE_HEIGHT = 128;

    // calculate the sprite region (true/false if its is currently
    // on the VGA display at hCount x vCount)
    wire p1_sprite_region;
    wire p2_sprite_region;
    assign p1_sprite_region = (hCount >= p1_x && hCount < p1_x + SPRITE_WIDTH &&
                            vCount >= p1_y && vCount < p1_y + SPRITE_HEIGHT);
    assign p2_sprite_region = (hCount >= p2_x && hCount < p2_x + SPRITE_WIDTH &&
                        vCount >= p2_y && vCount < p2_y + SPRITE_HEIGHT);
    
    // generate sprite x and y vals used to calculate the sprite_addr
    // note: [6:0] size is unique to 128 x 128 sprites
    wire [6:0] p1_sprite_x = hCount - p1_x;
    wire [6:0] p1_sprite_y = vCount - p1_y;
    wire [6:0] p2_sprite_x = hCount - p2_x;
    wire [6:0] p2_sprite_y = vCount - p2_y;
    
    // always updated with most recent sprite region
    assign p1_sprite_addr = (p1_sprite_region) ? p1_sprite_y * SPRITE_WIDTH + p1_sprite_x : 14'd0;
    assign p2_sprite_addr = (p2_sprite_region) ? p2_sprite_y * SPRITE_WIDTH + p2_sprite_x : 14'd0;

    wire p1_sprite_pixel;
    player_sprite p1_sprite (
        .clk(clk),
        .addr(p1_sprite_addr),
        .action(p1_action),
        .pixel_data(p1_sprite_pixel)
    );

    wire p2_sprite_pixel;
    player_sprite p2_sprite (
        .clk(clk),
        .addr(p2_sprite_addr),
        .action(p2_action),
        .pixel_data(p2_sprite_pixel)
    );

    always @(*) begin
        if (!bright) begin
            rgb = BLACK;
        end
        // note: 12 bit hex colors are unique to p1 download background
        else if (p1_sprite_region
        && p1_sprite_pixel != 12'h00D
        && p1_sprite_pixel != 12'h00E
        && p1_sprite_pixel != 12'h00F) begin
            rgb = p1_sprite_pixel;
        end
        else if (p2_sprite_region
        && p2_sprite_pixel != 12'h00D
        && p2_sprite_pixel != 12'h00E
        && p2_sprite_pixel != 12'h00F) begin
            rgb = p2_sprite_pixel;
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