`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/14/2025
// File Name: main_clk_to_slowed_clk.v 
// Description: slows 100mhz clock to desired frequency.
// max_count is the result of half of 100MHz (100 000 000) divided
// by the desired frequency.
// ie, say we want a 2hz clock:
// 100mhz to 2hz:
// 100 000 000
// -----------   = 50 000 000
//       2
// 
// 50 000 000 / 2 = 25 000 000
//
// thus, max_count = 25 000 000
//////////////////////////////////////////////////////////////////////////////////
module main_clk_to_slowed_clk #(
    parameter integer max_count = 1_000_000 // default value producing 50hz clk
)(
    // 100 MHz clock
    input wire clk_in,
    input wire rst_l,
    output reg clk_out
);

    integer counter = 0;

    always @(posedge clk_in or negedge rst_l) begin
        if (rst_l == 0) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == max_count - 1) begin
                // toggle output clock
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
