`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Kasra Farsoudi
// Create Date: 04/12/2025
// File Name: player.v 
// Description: modules to hold player data and state
//////////////////////////////////////////////////////////////////////////////////
module player(
    input clk,
    input reset,
    input player, //0 or 1
    input left_btn, right_btn, up_btn, down_btn, attack_btn, shield_btn, //we should connect the center button and make that be jump instead of up

    output reg [7:0] health, shield,
    output reg [9:0] x_pos, y_pos,

    /*
        ONE HOT STATE FOR PLAYER ACTION (Useful for sprite rendering)
        -------------------------------------------------------------
        MSB (x) == 0 LOOKING RIGHT
        MSB (x) == 1 LOOKING LEFT
        -------------------------------------------------------------
        x000001 | WALKING
        x000010 | CROUCHING
        x000100 | SHIELDING
        x001000 | JUMPING
        x010000 | PUNCHING
        x100000 | STANDING
    */
    output reg [6:0] action
);

    parameter WALKING =   6'b000001;
    parameter CROUCHING = 6'b000010;
    parameter SHIELDING = 6'b000100;
    parameter JUMPING =   6'b001000;
    parameter PUNCHING =  6'b010000;
    parameter STANDING =  6'b100000;

    //Jumping timer
    wire jump_active, jump_active_last_half;
    reg jump_en;
    timer_fraction_second jump_timer (
        .clk(clk),
        .reset(reset),
        .start(jump_en),
        .fraction(4'd1), // full second
        .done(),
        .running(jump_active),
        .halfway(jump_active_last_half)
    );
    //Punching timer
    wire punch_active;
    reg punch_en;
    timer_fraction_second punch_timer (
        .clk(clk),
        .reset(reset),
        .start(punch_en),
        .fraction(4'd4), // quarter second
        .done(),
        .running(punch_active),
        .halfway()
    );
    //dont do other stuff if we are busy 
    wire busy;
    assign busy = jump_active || punch_active;



    // Initialization logic
    always @(posedge reset) begin
        x_pos <= 10'd320; // Initial X position
        y_pos <= 10'd240; // Initial Y position
        health <= 8'd100; //start 100 health
        shield <= 8'd100; //start 100 shield
        action <= {player, STANDING}; 
        jump_en <= 0;
        punch_en <= 0;
    end

    //Next Sprite Logic (action)
    wire dir; //Direction of sprite combinational logic
    assign dir = right_btn ? 0 : left_btn ? 1 : action[6];
    //*//
    always @(posedge clk) begin
        if (!busy) begin // Not punching or jumping
            if (down_btn) 
                action <= {dir, CROUCHING};
            else if (left_btn || right_btn) 
                action <= {dir, WALKING};
            else if (shield_btn) 
                action <= {dir, SHIELDING};
            else if (up_btn) begin
                jump_en <= 1; 
                action <= {dir, JUMPING};
            end else if (attack_btn) begin
                punch_en <= 1; 
                action <= {dir, PUNCHING};
            end else 
                action <= {dir, STANDING};
        end else if (jump_active) begin
            action <= {dir, JUMPING};
            jump_en <= 0; 
        end else if (punch_active) begin
            action <= {dir, PUNCHING};
            punch_en <= 0; 
        end else 
            action <= {dir, STANDING};
    end




    // // Movement and action logic
    // always @(posedge clk) begin
    //     // Movement logic
    //     if (left_btn) x_pos <= x_pos - 1;
    //     else if (right_btn) x_pos <= x_pos + 1;
    //     else if (up_btn) y_pos <= y_pos - 1;
    //     else if (down_btn) y_pos <= y_pos + 1;

    //     // Punching logic
    //     if (attack_btn) punching <= 1;
    //     else punching <= 0;

    //     // Jumping logic
    //     if (up_btn && !jump_running) begin
    //         jump_en <= 1;
    //         action <= {player, JUMPING};
    //     end else if (!jump_running) begin
    //         jump_en <= 0;
    //         action <= {player, STANDING};
    //     end

    //     // Optional: Use `jump_halfway` for additional logic
    //     if (jump_halfway) begin
    //         // Add any halfway-specific behavior here
    //     end
    // end
endmodule