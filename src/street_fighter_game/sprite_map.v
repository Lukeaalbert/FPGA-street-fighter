`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Luke Albert & Kasra Farsoudi
// Create Date: 04/15/2025
// File Name: sprite_maps.v
// Description: Loads sprite ROM from .mem file and generates
// the relevant pixel ("pixel_data") at address "addr" for all sprite maps
//
//////////////////////////////////////////////////////////////////////////////////
module sprite_map #(
    parameter string FILENAME = "p1_walking1.mem" //Defaults to walking, must pass in paramater
    )(
    input wire clk,
    // 14 bits to cover 0 - 16383
    input wire [13:0] addr,
    // Reverse (for direction)
    input wire reverse,
    // RGB 4:4:4 format
    output reg [11:0] pixel_data
);
    /*
        Calculates the reverse pixel in a row (for looking left)
        Original Formula: (addr - addr%128) + (127 - addr%128)
        EXPLANATION:
        addr%128 -> This is the current column index in A row
        (addr - addr%128) -> Takes us to the beginning of THE row
        (127 - addr%128) -> The mirror column index of addr on A row
        So..
        (addr - addr%128) + (127 - addr%128)
            -> Beginning of THE row + Mirrored Col index of address on A row
            -> Works both ways
    */
    wire r_addr = (addr + 127) - 2*(addr % 128)

    // 128 x 128 = 16,384 pixels
    reg [11:0] memory [0:16383];

    initial begin
        $readmemh(FILENAME, memory);
    end

    always @(posedge clk) begin
        pixel_data <= memory[reverse ? r_addr : addr];
    end

endmodule