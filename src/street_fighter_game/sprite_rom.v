`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Luke Albert
// Create Date:   04/13/2025
// File Name:	sprite_rom.v 
// Description: load sprite rom from .mem file and generates
// relevant pixel ("pixel_data") at address "addr"
//////////////////////////////////////////////////////////////////////////////////
module sprite_rom (
    input wire clk,
    // 12-bit address: 32x32 = 1024 entries
    input wire [11:0] addr,
    // 12-bit RGB output
    output reg [11:0] pixel_data
);
    // 32 x 32 sprite
    reg [11:0] memory [0:1023];

    initial begin
        $readmemh("sprite.mem", memory);
    end

    always @(posedge clk) begin
        pixel_data <= memory[addr];
    end

endmodule
