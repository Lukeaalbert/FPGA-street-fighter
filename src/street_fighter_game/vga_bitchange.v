`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Luke Albert
// Create Date: 04/11/2025
// File Name: vga_bitchange.v 
// Description: basically, just generates the RGB values 
// once every posedge for EACH pixle in the VGA while scanning.
//
// tl;dr: generates the RGB "graphics" values for VGA screen.
//
// attempting to draw background http://i.imgur.com/Te9mt.png
//////////////////////////////////////////////////////////////////////////////////

module vga_bitchange(
    input wire clk,
    input wire bright,
    input wire rst_l,
    input wire [9:0] hCount,
    input wire [9:0] vCount,

    input wire [9:0] p1_x, p1_y, //holds top-left pixel of p1
    input wire [9:0] p2_x, p2_y, //holds top-left pixel of p2

    input wire [3:0] p1_health, p1_shield,
    input wire [3:0] p2_health, p2_shield,

    input wire [6:0] p1_action, //rgb for p1
    input wire [6:0] p2_action, //rgb for p2

    input wire p1_attack_grant,
    input wire p2_attack_grant,

    input wire [1:0] finish,

    output reg [11:0] rgb

);
    
    // used for player taking damage animation. detects weather or not players are
    // close enough to be considered a "collision" 
    parameter character_width = 80; //skinner to match the actual portion of sprite that is displayed
    wire player_collision;
    assign player_collision = (p1_x < p2_x + character_width) && (p1_x + character_width > p2_x);

    // used for player taking damage animation.
    // detects weather or not (1) p1 is facing p2 and (2) p2 is facing p1
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

    // colors
    parameter BLACK = 12'b0000_0000_0000;
    parameter WHITE = 12'b1111_1111_1111;
    parameter PURPLE = 12'b1111_0000_1111; //shield color
    parameter RED = 12'b1111_0000_0000;

    // used for grass rendering
    reg [3:0] green_base;
    reg [3:0] blue_shade;

    // sprite dimensions
    // note: unique to 128 x 128 sized sprite
    parameter SPRITE_WIDTH = 128;
    parameter SPRITE_HEIGHT = 128;

    // calculate the sprite region (true/false if its is currently
    // on the VGA display at hCount x vCount)
    wire p1_sprite_region;
    wire p2_sprite_region;
    assign p1_sprite_region = (hCount >= p1_x && hCount < p1_x + SPRITE_WIDTH &&
                            vCount >= p1_y && vCount < p1_y + SPRITE_HEIGHT);
    assign p2_sprite_region = (hCount >= p2_x && hCount < p2_x + SPRITE_WIDTH &&
                        vCount >= p2_y && vCount < p2_y + SPRITE_HEIGHT);
    
    // generate sprite x and y vals used to calculate the sprite_addr
    // note: [6:0] size is unique to 128 x 128 sprites
    wire [6:0] p1_sprite_x = hCount - p1_x;
    wire [6:0] p1_sprite_y = vCount - p1_y;
    wire [6:0] p2_sprite_x = hCount - p2_x;
    wire [6:0] p2_sprite_y = vCount - p2_y;

    wire [13:0] p1_sprite_addr;
    wire [13:0] p2_sprite_addr;
    // always updated with most recent sprite region
    assign p1_sprite_addr = (p1_sprite_region) ? p1_sprite_y * SPRITE_WIDTH + p1_sprite_x : 14'd0;
    assign p2_sprite_addr = (p2_sprite_region) ? p2_sprite_y * SPRITE_WIDTH + p2_sprite_x : 14'd0;

    wire [11:0] p1_sprite_pixel;
    wire p2_taking_damage;
    wire p1_shielding;
    assign p1_shielding = p1_action[2];
    player_sprite #(
    .player_num(1)
        ) p1_sprite (
        .clk(clk),
        .addr(p1_sprite_addr),
        .action(p1_action),
        .attack_grant(p1_attack_grant),
        .pixel_data(p1_sprite_pixel),
        .enemy_damage_animation(p2_taking_damage)
    );

    wire [11:0] p2_sprite_pixel;
    wire p1_taking_damage;
    wire p2_shielding;
    assign p2_shielding = p2_action[2];
    player_sprite #(
    .player_num(2)
    )  p2_sprite (
        .clk(clk),
        .addr(p2_sprite_addr),
        .action(p2_action),
        .attack_grant(p2_attack_grant),
        .pixel_data(p2_sprite_pixel),
        .enemy_damage_animation(p1_taking_damage)
    );

    // t/f if current sprite pixel == background color (to ignore)
    wire p1_sprite_background_color = (p1_sprite_pixel == 12'h00D
        || p1_sprite_pixel == 12'h00C
        || p1_sprite_pixel == 12'h00F);
    wire p2_sprite_background_color = (p2_sprite_pixel == 12'h00D
        || p2_sprite_pixel == 12'h00C
        || p2_sprite_pixel == 12'h00F);


    // calculate the health bar region (true/false if its is currently
    // on the VGA display at hCount x vCount)
    wire bars_region;
    assign bars_region = 
        (((hCount >= 188 && hCount <= 338) // 150 px horizontal for p1
        || (hCount >= 588 && hCount <= 738)) // 150 px horizontal for p2
        && ((vCount >= 50 && vCount <= 75) // 25 px vertical for health bars
        || vCount >= 80 && vCount <= 95)); // 15 px vertical for shield bars

    //will be moved out of this file to game eventually
    wire [11:0] bar_pixel;
    bars bars_info(
        .clk(clk),
        .hCount(hCount),
        .vCount(vCount),
        .p1_health(p1_health),
        .p1_shield(p1_shield),
        .p2_health(p2_health),
        .p2_shield(p2_shield),
        .bar_pixel(bar_pixel)
    );

    // calculate the game over image region (true/false if its is currently
    // on the VGA display at hCount x vCount)
    wire game_over_region;
    assign game_over_region =
        ((hCount >= 144+160 && hCount < 144+160+320) &&
        (vCount >= 34+93 && vCount < 34+93+67));

    wire [14:0] game_over_addr;
    assign game_over_addr = (game_over_region) ? 
        ((vCount - (34 + 93)) * 320 + (hCount - (144 + 160))) : 14'd0;

    wire [11:0] game_over_pixel_data;
    wire [11:0] game_over_background_color;
    assign game_over_background_color = 
        (game_over_pixel_data == 12'h0AF);
    
    finish game_over(
        .clk(clk),
        .rst_l(rst_l),
        .addr(game_over_addr),
        .finish(finish),
        .pixel_data(game_over_pixel_data)
    );


    always @(*) begin
        if (!bright) begin
            rgb = BLACK;
        end
        else if (bars_region)
        begin
            rgb = bar_pixel;
        end
        else if (game_over_region && !game_over_background_color && finish[0]) begin
            rgb <= game_over_pixel_data;
        end
        else if (p1_sprite_region && !p1_sprite_background_color) begin
            // game is over
            if (finish[0]) begin
                if (finish[1]) rgb <= RED; // player lost
                // player won implicitly satasfied, as none of the other 
                // conditions execute
            end
            else if (p1_shielding) rgb <= PURPLE; // shield -> purple
            else if (p1_taking_damage && player_collision && p2_facing_p1) // taking damage
                rgb <= RED;
            else rgb = p1_sprite_pixel; // actual player pixels
        end else if (p2_sprite_region && !p2_sprite_background_color) begin
            // game is over
            if (finish[0]) begin
                if (!finish[1]) rgb <= RED; // player lost
                // player won implicitly satasfied, as none of the other 
                // conditions execute
            end
            else if (p2_shielding) rgb <= PURPLE; // shield -> purple
            else if (p2_taking_damage && player_collision && p1_facing_p2) // taking damage
                rgb <= RED;
            else rgb = p2_sprite_pixel; // actual player pixels
        end
        else if (vCount < 394) begin
            rgb[11:8] = 4'd0;
            rgb[7:4]  = 4'd0;
            rgb[3:0]  = (vCount >> 4 > 15) ? 4'd15 : vCount[7:4];
        end
        else begin
            green_base = 4'd10 + (vCount[6:5]);
            if ((hCount[3:1] == 3'b010) || (hCount[3:1] == 3'b101))
                green_base = green_base + 1;
            blue_shade = (vCount[4] ^ hCount[2]) ? 4'd2 : 4'd1;
            rgb[11:8] = 4'd0;
            rgb[7:4]  = (green_base > 4'd15) ? 4'd15 : green_base;
            rgb[3:0]  = blue_shade;
        end
    end

    

endmodule