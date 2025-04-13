`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/13/2025
// File Name: background_rom.v 
// Description: loads the .mem file of the background and
// provides the rbg value "data" at address "addr".
//////////////////////////////////////////////////////////////////////////////////
module background_rom (
    // enough for 640*480 = 307200
    input wire [18:0] addr,
    // 4 bits for each red, green, and blue
    output reg [11:0] data
);
    // big fat chunk of rom
    reg [11:0] rom [0:307199];

    // hold all pixels from .mem background file
    initial begin
        $readmemh("background.mem", rom);
    end

    // always have the correct rbg value in data
    always @(*) begin
        data = rom[addr];
    end
endmodule
