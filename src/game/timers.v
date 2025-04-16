`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Kasra
// Create Date: 04/12/2025
// File Name: timer.v
// Description: timer modules
//////////////////////////////////////////////////////////////////////////////////

module timer_fraction_second(
    input clk,        // Clock signal
    input reset,      // Reset signal
    input start,      // Start signal
    input [3:0] fraction, // Fraction denominator (e.g., 4 for quarter second)
    output reg done,  // Timer done signal
    output reg running,  // Active high while timer is running
    output reg halfway   // Active high at halfway point
);
    parameter CLOCK_FREQ = 100_000_000; // 100 MHz clock

    reg [31:0] counter; // 32-bit counter
    reg [31:0] timer_count; // Dynamic timer count
    
    // Calculate timer_count based on fraction input
    always @(*) begin
        if (fraction == 0)
            timer_count = CLOCK_FREQ; // Default to 1 second if fraction is 0
        else
            timer_count = CLOCK_FREQ / fraction;
    end
    
    // Reset logic
    always @(negedge reset) begin
        counter <= 0;
        done <= 0;
        running <= 0;
        halfway <= 0;
    end
    
    // Timer logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            done <= 0;
            running <= 0;
            halfway <= 0;
        end
        else begin
            // Default state for done signal
            done <= 0;
            halfway <= 0;
            
            // Start the timer when start signal is asserted
            if (start && !running) begin
                running <= 1;
                counter <= 0;
            end
            
            // Timer counting logic
            if (running) begin
                if (counter < timer_count - 1) begin
                    counter <= counter + 1;
                    
                    // Set halfway flag when counter reaches halfway point
                    if (counter == (timer_count / 2) - 1)
                        halfway <= 1;
                end
                else begin
                    // Timer finished
                    done <= 1;
                    running <= 0;
                    counter <= 0;
                end
            end
        end
    end
endmodule
