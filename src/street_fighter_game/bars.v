`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert & Kasra Farsoudi
// Create Date: 04/71/2025
// File Name: vga_bitchange.v 
// Description: communicates with bitchange for health/shield display
//////////////////////////////////////////////////////////////////////////////////

module bars(
    input wire [9:0] hCount,
    input wire [9:0] vCount,
    
    input wire [3:0] p1_health,
    input wire [3:0] p1_shield,
    input wire [3:0] p2_health,
    input wire [3:0] p2_shield,

    output reg [11:0] bar_pixel,
    output reg bar_draw //for transparency; e.g. if a bar is half full then just render half
);


    parameter GREEN = 12'b0000_1111_0000; //high health
    parameter RED = 12'b1111_0000_0000; //low health.. maybe like health <= 5
    parameter PURPLE = 12'b1111_0000_1111; //shield color


    //TODO:
    /*
        * Convert the 15 levels of health to how much of the bar region it should take for all 4 bars
        * Logic for green (high health), red (medium health) (if u have time, not super important)
        * Logic to discern which bar we are in based on h_count && v_count
            -> ex. line 48 on vga_bitchange for sprites. u can do this on the bitchange file if u want for consistency but the
                logic is probably needed here too?
            -> set bar_draw to 1 if we are in that region
        * and if u really really have time .. some sort of border around the health bars, not that important though

        feel free to add/remove, this is just an initial blueprint. i just think its a good idea to not add to much code to the bitchange file.
    */




endmodule