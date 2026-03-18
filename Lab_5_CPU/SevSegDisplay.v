module SevSegDisplay(
	input [3:0] hex_input,
	output reg [6:0] segment_display
);
	always@(hex_input) begin
		case (hex_input)
			4'h0: segment_display = ~7'b0111111; // 0
			4'h1: segment_display = ~7'b0000110; // 1
			4'h2: segment_display = ~7'b1011011; // 2
			4'h3: segment_display = ~7'b1001111; // 3
			4'h4: segment_display = ~7'b1100110; // 4
			4'h5: segment_display = ~7'b1101101; // 5
			4'h6: segment_display = ~7'b1111101; // 6
			4'h7: segment_display = ~7'b0000111; // 7
			4'h8: segment_display = ~7'b1111111; // 8
			4'h9: segment_display = ~7'b1101111; // 9
			4'hA: segment_display = ~7'b1110111; // A
			4'hB: segment_display = ~7'b1111100; // b
			4'hC: segment_display = ~7'b1011000; // c
			4'hD: segment_display = ~7'b1011110; // d
			4'hE: segment_display = ~7'b1111001; // E
			4'hF: segment_display = ~7'b1110001; // F
			default: segment_display = ~7'b0000000; // all lights off
		endcase
	end
endmodule