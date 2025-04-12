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
    input left,
    input right,
    input up,
    input down,
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
reg state [6:0];

always@ (posedge clk)
    begin
        // default
        state <= 7'b0000000;

        // position
        if (left) state <= LEFT;
        else if (right) state <= RIGHT;
        else if (up) state <= UP;
        else if (down) state <= DOWN;

        // buttons
        if (attack) state[5] <= 1'b1;
        if (pery) state[6] <= 1'b1;

        led_outputs <= state;
    end

endmodule