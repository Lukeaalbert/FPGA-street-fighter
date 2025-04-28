`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Kasra Farsoudi
// Create Date: 04/27/2025
// File Name: finish.v 
// Description: module to hold game over pixel data
//////////////////////////////////////////////////////////////////////////////////
module finish(
    input wire clk,
    input wire rst_l,
    input wire [14:0] addr,
    input wire [1:0] finish,
    output reg [11:0] pixel_data
);

    //320x67=21,440 pixels
    reg [11:0] win_p1_mem [0:21440];
    reg [11:0] win_p2_mem [0:21440];


    initial begin
        $readmemh("win_p1.mem", win_p1_mem);
        $readmemh("win_p2.mem", win_p2_mem);
    end

    always @(posedge clk) begin
        pixel_data <= finish[1] ? win_p2_mem[addr] : win_p1_mem[addr];
    end


endmodule