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
    input wire reset,
    input wire [9:0] hCount,
    input wire [9:0] vCount,
    output reg [11:0] rgb
);

    wire [18:0] pixel_addr = vCount * 640 + hCount;
    wire [11:0] bg_pixel;

    background_rom bg(.addr(pixel_addr), .data(bg_pixel));

    always @(*) begin
        if (!bright) begin
            rgb = 12'b0000_0000_0000; // black
        end else begin
            rgb = bg_pixel;
        end
    end
endmodule
