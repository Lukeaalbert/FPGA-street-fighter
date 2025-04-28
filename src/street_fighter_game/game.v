`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Kasra Farsoudi
// Create Date: 04/12/2025
// File Name: game.v 
// Description: core game code that handles collisions, health, shields, movement
//////////////////////////////////////////////////////////////////////////////////

module game(
    input clk,        // Clock signal
    input reset,      // Reset signal

    //Player controls
    input [6:0] p1_inputs,
    input [6:0] p2_inputs,
    
    //Player data
    output reg [3:0] p1_health, p2_health,//for vga_top to render health/shield bars
    output wire [3:0] p1_shield, p2_shield, //for vga_top to render health/shield bars

    output reg [9:0] p1_x, p1_y, //holds top-left pixel of p1
    output reg [9:0] p2_x, p2_y, //holds top-left pixel of p2

    output wire [6:0] p1_action, // Changed from wire to reg
    output wire [6:0] p2_action,  // Changed from wire to reg

    output wire p1_attack_grant,
    output wire p2_attack_grant,

    output reg [1:0] finish
);

parameter character_width = 80; //skinner to match the actual portion of sprite that is displayed

//inout to invidiual wires
wire p1_left_btn   = p1_inputs[1];
wire p1_right_btn  = p1_inputs[2];
wire p1_up_btn     = p1_inputs[3];
wire p1_down_btn   = p1_inputs[4];
wire p1_shield_btn = p1_inputs[6];
wire p1_center_btn = p1_inputs[0];
wire p1_attack_btn;
input_debouncer p1_attack_debouncer(
    .CLK(clk),
    .RESET(reset),
    .PB(p1_inputs[5]),
    .DPB(p1_attack_btn));

wire p2_left_btn   = p2_inputs[1];
wire p2_right_btn  = p2_inputs[2];
wire p2_up_btn     = p2_inputs[3];
wire p2_down_btn   = p2_inputs[4];
wire p2_shield_btn = p2_inputs[6];
wire p2_center_btn = p2_inputs[0];
wire p2_attack_btn;
input_debouncer p2_attack_debouncer(
    .CLK(clk),
    .RESET(reset),
    .PB(p2_inputs[5]),
    .DPB(p2_attack_btn));

//Player 1
wire p1_attack_request, p1_jump_active, p1_jump_active_last_half;
wire p1_shielding = (p1_action[5:0] == 6'b000100) ? 1 : 0;
player p1(
    .clk(clk),
    .reset(reset),
    .player(1'b0),
    .left_btn(p1_left_btn), .right_btn(p1_right_btn), .up_btn(p1_up_btn), .down_btn(p1_down_btn), .attack_btn(p1_attack_btn), .shield_btn(p1_shield_btn),
    .health(p1_health), .shield(p1_shield),
    .attack_request(p1_attack_request), 
    .jump_active(p1_jump_active), .jump_active_last_half(p2_jump_active_last_half),
    .action(p1_action)
);
assign p1_attack_grant = (!finish[0]) ? p1_attack_request : 1'b0;

//Player 2
wire p2_attack_request, p2_jump_active, p2_jump_active_last_half;
wire p2_shielding = (p2_action[5:0] == 6'b000100) ? 1 : 0;
player p2(
    .clk(clk),
    .reset(reset),
    .player(1'b1),
    .left_btn(p2_left_btn), .right_btn(p2_right_btn), .up_btn(p2_up_btn), .down_btn(p2_down_btn), .attack_btn(p2_attack_btn), .shield_btn(p2_shield_btn),
    .health(p2_health), .shield(p2_shield),
    .attack_request(p2_attack_request), 
    .jump_active(p2_jump_active), .jump_active_last_half(p2_jump_active_last_half),
    .action(p2_action) 
);

assign p2_attack_grant = (!finish[0]) ? p2_attack_request : 1'b0;

// Track which direction players are facing
reg p1_direction;
reg p2_direction;
parameter LEFT = 1;
parameter RIGHT = 0;
always @(posedge clk) begin
    p1_direction <= p1_action[6];
    p2_direction <= p2_action[6];
end
assign p1_facing_p2 = (p1_x < p2_x && p1_direction == RIGHT) || (p1_x > p2_x && p1_direction == LEFT);
assign p2_facing_p1 = (p2_x < p1_x && p2_direction == RIGHT) || (p2_x > p1_x && p2_direction == LEFT);

// AABB Collision Detection
wire collision_x, collision_y, collision;
assign collision_x = (p1_x < p2_x + character_width) && (p1_x + character_width > p2_x);
assign collision_y = (p1_y == p2_y); // Players must be on the same vertical level
assign collision = collision_x && collision_y;

//Attack logic
reg p1_attack_prev = 0;
reg p2_attack_prev = 0;
always @(posedge clk) begin
    if (!reset) begin
        p1_health <= 4'd15;
        p2_health <= 4'd15;
        p1_attack_prev <= 0;
        p2_attack_prev <= 0;
    end else if (!finish[0]) begin
        if (p1_attack_request && !p1_attack_prev && collision_x && !p2_shielding && p1_facing_p2 && p2_health != 0) begin
            p2_health <= p2_health - 4'd1;
        end
        if (p2_attack_request && !p2_attack_prev && collision_x && !p1_shielding && p2_facing_p1 && p1_health != 0) begin
            p1_health <= p1_health - 4'd1;
        end

        // Update previous states
        p1_attack_prev <= p1_attack_request;
        p2_attack_prev <= p2_attack_request;
    end
end

wire slowed_walk_clk;
main_clk_to_slowed_clk #(.max_count(800_000)) walk_clk(
    .clk_in(clk),
    .rst_l(1'b1),
    .clk_out(slowed_walk_clk)
);

//Positioning
always @(posedge slowed_walk_clk) begin
    if (!reset) begin
        p1_x      <= 200; //Left Third
        p2_x      <= 600; //Right Third
        p1_y      <= 300; //Above Ground
        p2_y      <= 300; //Above Ground;
    end
    else if (finish[0]) begin end // Game over 
    else begin
        // Player 1 movement horizontal axis
        if (p1_left_btn && p1_x > 143 && !(collision && p1_x - 1 + character_width > p2_x))
            p1_x <= p1_x - 1;
        else if (p1_right_btn && p1_x < 784 - character_width && !(collision && p1_x + 1 < p2_x + character_width))
            p1_x <= p1_x + 1;

        // Player 2 movement horizontal axis
        if (p2_left_btn && p2_x > 143 && !(collision && p2_x - 1 + character_width > p1_x))
            p2_x <= p2_x - 1;
        else if (p2_right_btn && p2_x < 784 - character_width && !(collision && p2_x + 1 < p1_x + character_width))
            p2_x <= p2_x + 1;
        
        /*
        //Player 1 movement vertical axis
        if (p1_jump_active) begin
            if (p1_jump_active_last_half) begin
                p1_y <= p1_y - 1;
            end else begin
                p1_y <= p1_y + 1;
            end
        end else begin 
            p1_y <= 300; //ground level
        end

        //Player 2 movement vertical axis
        if (p2_jump_active) begin
            if (p1_jump_active_last_half) begin
                p2_y <= p2_y - 1;
            end else begin
                p2_y <= p2_y + 1;
            end
        end else begin 
            p2_y <= 300; //ground level
        end
        */
    end
end

//Game Over Logic
always@(posedge clk) begin
    if (!reset) begin
        finish <= 2'b00;
    end 
    else if (!finish[0]) begin
        //p1 wins
        if (p2_health == 4'b0) begin
            finish <= 2'b01;
        end
        //p2 wins
        if (p1_health == 4'b0) begin
            finish <= 2'b11;
        end
    end
end

endmodule