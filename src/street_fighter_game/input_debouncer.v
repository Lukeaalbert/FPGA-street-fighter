//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Luke Albert
// Create Date:   04/11/2025
// File Name:	input_debouncer.v 
// Description: Debouncer module. Produces default debounce signal DPB.
// Additional Comments: Debounces input signal in verilog
//
//////////////////////////////////////////////////////////////////////////////////

module input_debouncer(CLK, RESET, PB, DPB);

input	CLK, RESET;
input PB;
output DPB;

parameter N_dc = 5;

reg [N_dc-1:0] debounce_count;
reg [1:0] state;

assign DPB = (state == 2'b10);

localparam
 INI  = 2'b00,
 WQ   = 2'b01,
 DPB_st = 2'b10,
 WFCR = 2'b11;

always @ (posedge CLK, negedge RESET)
begin
	if (!RESET)
	begin
		state <= INI;
		debounce_count <= 0;
	end
	else
	begin
		case (state)
			INI: begin
				debounce_count <= 0;
				if (PB)
					state <= WQ;
			end
			WQ: begin
				debounce_count <= debounce_count + 1;
				if (!PB)
					state <= INI;
				else if (debounce_count[N_dc-2])
					state <= DPB_st;
			end
			DPB_st: begin
				state <= WFCR;
			end
			WFCR: begin
				debounce_count <= debounce_count + 1;
				if (PB)
					state <= WFCR;
				else if (debounce_count[N_dc-2])
					state <= INI;
			end
		endcase
	end
end

endmodule