`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: EE 354 Staff
//
// Description: Scans through every pixle in a
// 640x480 VGA display and stores the current
// x, y parameter of which pixel we're at
// in (hCount) x (vCount)
//
// the pixel counters go to 800x525 because of sync
// pulses and blanking intervals (not all pixels are 
// displayed — some are used just for timing)
//////////////////////////////////////////////////////////////////////////////////
module display_controller(
	input clk,
	output hSync, vSync,
	output reg bright,
	output reg[9:0] hCount, 
	// Covers 800, width of the screen, because it's 2^10
	output reg [9:0] vCount
	);
	
	reg pulse;
	reg clk25;
	
	initial begin // Set all of them initially to 0
		clk25 = 0;
		pulse = 0;
	end
	
	always @(posedge clk) // clk is 100MHZ
		pulse = ~pulse; // pulse is 50MHz (clock divider)
	always @(posedge pulse)
		clk25 = ~clk25; // thus, clk 25 is 25MHz (clock divider)
		
	always @ (posedge clk25)
		begin
		if (hCount < 10'd799)
			begin
			hCount <= hCount + 1;
			end
		else if (vCount < 10'd524)
			begin
			hCount <= 0;
			vCount <= vCount + 1;
			end
		else
			begin
			hCount <= 0;
			vCount <= 0;
			end
		end
	
	// tells the VGA display when to start a new line
	// or frame.
	assign hSync = (hCount < 96) ? 1:0;
	assign vSync = (vCount < 2) ? 1:0;

	// this part simply determines if the current 
	// (hCount, vCount) location is in the visible 
	// display area (640x480).
	always @(posedge clk25)
		begin
		if(hCount > 10'd143 && hCount < 10'd784 && vCount > 10'd34 && vCount < 10'd516)
			bright <= 1;
		else
			bright <= 0;
		end	
		
endmodule
