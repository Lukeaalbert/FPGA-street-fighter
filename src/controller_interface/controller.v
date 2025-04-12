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
    input shield,
    output reg [6:0] led_outputs
);

parameter DEFAULT = 7'b0000000;
parameter ON = 7'b1;

reg [6:0] state;

always@ (posedge clk)
    begin
        // default (none on)
        state <= DEFAULT;

        // position. only 1 position signal can be active at a time.
        if (left_l == 0) state[1] <= ON; // left signal
        else if (right_l == 0) state[2] <= ON; // right signal
        else if (up_l == 0) state[3] <= ON; // up signal
        else if (down_l == 0) state[4] <= ON; // down signal
        else state[0] <= ON; // no position signal (so center signal activated)

        // buttons
        if (attack) state[5] <= ON;
        if (shield) state[6] <= ON;

        led_outputs <= state;
    end

endmodule