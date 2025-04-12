module background_rom (
    input wire [18:0] addr, // Enough for 640*480 = 307200
    output reg [11:0] data
);
    reg [11:0] rom [0:307199];

    initial begin
        $readmemh("background.mem", rom);
    end

    always @(*) begin
        data = rom[addr];
    end
endmodule
