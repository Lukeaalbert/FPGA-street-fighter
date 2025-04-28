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

    input finish, //indicates game over

    input [3:0] health, //game decides when player is hurt
    output reg [3:0] shield, //this module decides shield



    output reg attack_request,
    output wire jump_active, jump_active_last_half,


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
    wire punch_cooldown_active;
    reg punch_cooldown_en;
    timer_fraction_second punch_cooldown_timer (
        .clk(clk),
        .reset(reset),
        .start(punch_cooldown_en),
        .fraction(4'd3), // Gives ~0.333s
        .done(),
        .running(punch_cooldown_active),
        .halfway()
    );

    //2hz Timer to update shield
    wire slowed_shield_clk;
    main_clk_to_slowed_clk #(.max_count(25_000_000)) shield_clk(
        .clk_in(clk),
        .rst_l(1'b1),
        .clk_out(slowed_shield_clk)
    );

    always@(posedge slowed_shield_clk) begin
        if (!reset) begin
            shield <= 4'd15;
        end
        else if (shield_btn && shield > 0 && action[5:0] == SHIELDING) begin
            shield <= shield-1;
        end else if (!shield_btn && shield < 15)begin
            shield <= shield+1; //regen logic for shield
        end

    end


    //Next Sprite Logic (action)
    reg dir; //Direction of sprite combinational logic
    // assign dir = right_btn ? 0 : left_btn ? 1 : action[6];
    always@(*) begin
        if (!finish) begin
            if (right_btn)
                dir = 0;
            else if (left_btn)
                dir = 1;
            else
                dir = action[6];
        end else begin
            dir = action[6];
        end
    end

    always @(posedge clk) begin
        if (!reset) begin // Active low reset
            action <= {player, STANDING}; 
            jump_en <= 0;
            punch_cooldown_en <= 0;
            attack_request <= 0;
        end
        else if (!jump_active) begin // Not punching or jumping
            if (shield_btn && (shield >= 1'b1))  begin
                action <= {dir, SHIELDING};
            end else if (down_btn) begin
                action <= {dir, CROUCHING};
            end else if (left_btn || right_btn) begin
                action <= {dir, WALKING};
            end else if (up_btn) begin
                jump_en <= 1; 
                action <= {dir, JUMPING};
            end else if (attack_btn) begin 
                if (!punch_cooldown_active) begin
                    attack_request <= 1; //Active for 1 clock
                    punch_cooldown_en <= 1;
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