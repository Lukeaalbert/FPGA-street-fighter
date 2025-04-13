`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: vga_bitchange.v 
// Description: generates the background by using background_rom module
// which generates the RBG values for each pixel, and assigning it
// to the actual rgb output reg.
//
// tl;dr: generates the RGB "graphics" values for VGA screen.
//////////////////////////////////////////////////////////////////////////////////

module vga_bitchange(
    input wire clk,
    input wire bright,
    input wire reset,
    input wire [9:0] hCount,
    input wire [9:0] vCount,
    output reg [11:0] rgb
);

    // this input wire is used to address the background
    // rom and get the RBG pixel from it. the formula is 
    // enough to address all 640*480 = 307200 pixels for
    // the VGA screen.
    wire [18:0] pixel_addr = vCount * 640 + hCount;
    // output of background_rom. the actual 12 bit,
    // rbg value of the current pixel.
    wire [11:0] bg_pixel;

    background_rom bg(.addr(pixel_addr), .data(bg_pixel));

    always @(*) begin
        if (!bright) begin
            // black
            rgb = 12'b0000_0000_0000;
        end else begin
            // assign rbg value
            rgb = bg_pixel;
        end
    end
endmodule
