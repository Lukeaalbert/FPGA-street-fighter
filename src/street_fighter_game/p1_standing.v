`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Luke Albert
// Create Date: 04/13/2025
// File Name: p1_standing.v 
// Description: Loads sprite ROM from .mem file and generates
// the relevant pixel ("pixel_data") at address "addr"
//
//////////////////////////////////////////////////////////////////////////////////
module p1_standing (
    input wire clk,
    // 14 bits to cover 0 - 16383
    input wire [13:0] addr,
    // RGB 4:4:4 format
    output reg [11:0] pixel_data
);

    // 128 x 128 = 16,384 pixels
    reg [11:0] memory [0:16383];

    initial begin
        $readmemh("p1_standing.mem", memory);
    end

    always @(posedge clk) begin
        pixel_data <= memory[addr];
    end

endmodule