`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert & Kasra Farsoudi
// Create Date: 04/71/2025
// File Name: vga_bitchange.v 
// Description: communicates with bitchange for health/shield display
//////////////////////////////////////////////////////////////////////////////////

module bars(
    input wire clk,
    input wire [9:0] hCount,
    input wire [9:0] vCount,
    
    input wire [3:0] p1_health,
    input wire [3:0] p1_shield,
    input wire [3:0] p2_health,
    input wire [3:0] p2_shield,

    output reg [11:0] bar_pixel
);

    parameter GREEN = 12'b0000_1100_0000; //high health
    parameter BLACK = 12'b0000_0000_0000; // lost health region
    parameter WHITE = 12'b1111_1111_1111; // health bar border
    parameter RED = 12'b1111_0000_0000; //low health.. maybe like health <= 5
    parameter PURPLE = 12'b1111_0000_1111; //shield color

    // t/f for when to return bar indicating health status
    wire p1_remaining_health_region;
    assign p1_remaining_health_region = (hCount < 188 + (10 * p1_health)) && vCount <= 75; // p1 health remaining

    wire p2_remaining_health_region;
    assign p2_remaining_health_region = (hCount > 588 && ((hCount < 588 + (10 * p2_health)))) && vCount <= 75; // p2 health remaining

    // t/f for when to return bar indicating shield
    wire p1_remaining_shield_region;
    assign p1_remaining_shield_region = (hCount < 188 + (10 * p1_shield)) && vCount >= 75; // p1 shield remaining

    wire p2_remaining_shield_region;
    assign p2_remaining_shield_region = (hCount > 588 && ((hCount < 588 + (10 * p2_shield)))) && vCount >= 75; // p2 shield remaining

    // t/f for when to return white border for bars
    wire bars_border_region;
    assign bars_border_region = (
        (vCount <= 53 && vCount >= 50) // top health bars
        || (vCount >= 72 && vCount <= 75) // bottom health bars
        || vCount == 80 // top shield bars
        || vCount == 95 // bottom shield bars
        || hCount <= 191
        || hCount >= 735
        || (hCount >= 335 && hCount <= 338)
        || (hCount <= 591 && hCount >= 588)
        );
    
    always @(posedge clk) begin
        if (bars_border_region) bar_pixel <= WHITE; // border of health bar
        else if (p1_remaining_health_region || p2_remaining_health_region) begin
            if (p1_remaining_health_region && p1_health < 5) bar_pixel <= RED; // p1 low health
            else if (p2_remaining_health_region && p2_health < 5) bar_pixel <= RED; // p2 low health
            else bar_pixel <= GREEN; // remaining health region
        end
        else if (p1_remaining_shield_region || p2_remaining_shield_region) begin
            bar_pixel <= PURPLE; // shield color
        end
        else bar_pixel <= BLACK; // lost health region
    end
    
endmodule