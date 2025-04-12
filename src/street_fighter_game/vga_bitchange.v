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

    // colors
    parameter BLACK = 12'b0000_0000_0000;

    always @(*) begin
        if (!bright) begin
            rgb = BLACK;
        end
        else if // blades of grass poking up above horizon
        (((hCount % 5) == 0 || (hCount % 12) == 0  || (hCount % 18) == 0 ) && vCount > 388 && vCount < 394)
        begin
            rgb[11:8] = 4'd0; // red
            rgb[7:4]  = 4'd8 + ((hCount[4] ^ vCount[3]) ? 4'd4 : 4'd0); // green with striping
            rgb[3:0]  = 4'd1; // blue tint
        end
        else if (vCount < 394) // mostly sky
        begin
            // sky, dark blue with vertical gradient
            rgb[11:8] = 4'd0; // red
            rgb[7:4]  = 4'd0; // green
            // smoother gradient: divide vCount by 16, then clamp to max 15
            if ((vCount >> 4) + 2 > 4'd15)
                rgb[3:0] = 4'd15;
            else
                rgb[3:0] = (vCount >> 4) + 4'd2;
        end
        else // the rest is grass
    begin
        // GRASS (green with subtle pattern)
        rgb[11:8] = 4'd0; // red
        rgb[7:4]  = 4'd8 + ((hCount[4] ^ vCount[3]) ? 4'd4 : 4'd0); // green with striping
        rgb[3:0]  = 4'd1; // blue tint
    end

    end

endmodule