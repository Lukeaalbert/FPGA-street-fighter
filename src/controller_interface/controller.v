`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: controller.v 
// Description: processes signals from custom controller.
//////////////////////////////////////////////////////////////////////////////////
module controller(
    // start: inputs from custom controller,
    // see https://www.notion.so/Breadboard-Controller-1cf7f312731e809eb9aac275158c04ea
    input clk,
    input left_l,
    input right_l,
    input up_l,
    input down_l,
    // end: inputs from custom controller
    input attack,
    input pery,
    output reg [6:0] led_outputs
);

parameter CENTER = 7'b0000001;
parameter LEFT = 7'b0000010;
parameter RIGHT = 7'b0000100;
parameter UP = 7'b0001000;
parameter DOWN = 7'b0010000;
reg [6:0] state;

always@ (posedge clk)
    begin
        // default
        state <= 7'b0000000;

        // position
        if (left_l == 0) state <= LEFT;
        else if (right_l == 0) state <= RIGHT;
        else if (up_l == 0) state <= UP;
        else if (down_l == 0) state <= DOWN;

        // buttons
        if (attack == 0) state[5] <= 1'b1;
        if (pery == 0) state[6] <= 1'b1;

        led_outputs <= state;
    end

endmodule