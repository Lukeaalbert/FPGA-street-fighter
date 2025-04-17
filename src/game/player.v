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

    input [7:0] health, shield, //game decides when player is hurt, when shield needs to recharge, etc.


    output reg attack_request, left_request, right_request, jump_request


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
    wire punch_cooldown_en;
    reg punch_cooldown_active;
    timer_fraction_second punch_cooldown_timer (
        .clk(clk),
        .reset(reset),
        .start(punch_cooldown_en),
        .fraction(4'd3), // quarter second
        .done(),
        .running(punch_cooldown_active),
        .halfway()
    );



    // Initialization logic
    always @(negedge reset) begin
        action <= {player, STANDING}; 
        jump_en <= 0;
        punch_en <= 0;
        left_request <= 0;
        right_request <= 0;
        attack_request <= 0;
        jump_request <= 0;
    end

    //Next Sprite Logic (action)
    wire dir; //Direction of sprite combinational logic
    assign dir = right_btn ? 0 : left_btn ? 1 : action[6];
    //*//
    always @(posedge clk) begin
        if (!jump_active) begin // Not punching or jumping
            if (down_btn) 
                action <= {dir, CROUCHING};
            else if (left_btn || right_btn) 
                action <= {dir, WALKING};
            else if (shield_btn) 
                action <= {dir, SHIELDING};
            else if (up_btn) begin
                jump_en <= 1; 
                action <= {dir, JUMPING};
            end else if (attack_btn) begin //
                if (!punch_cooldown_active) begin
                    attack_request <= 1; //Active for 1 clock
                    punch_cooldown_en <= 1;
                    punch_cooldown_active <= 1;
                end
                action <= {dir, PUNCHING};
            end else 
                action <= {dir, STANDING};
        end else begin //else is jumping
            action <= {dir, JUMPING};
            jump_en <= 0; 
        end

        //Overwrite any punching on punch cooldown
        if (punch_cooldown_active) begin
            punch_cooldown_en <= 0;
            attack_request <= 0;
        end
    end




endmodule