module BinToSevSeg(
	input [3:0] binary_input,
	output reg [6:0] segment_display
);

	always@(binary_input) begin
		case (binary_input)
			4'd0: segment_display = ~7'b0111111; // 0
			4'd1: segment_display = ~7'b0000110; // 1
			4'd2: segment_display = ~7'b1011011; // 2
			4'd3: segment_display = ~7'b1001111; // 3
			4'd4: segment_display = ~7'b1100110; // 4
			4'd5: segment_display = ~7'b1101101; // 5
			4'd6: segment_display = ~7'b1111101; // 6
			4'd7: segment_display = ~7'b0000111; // 7
			4'd8: segment_display = ~7'b1111111; // 8
			4'd9: segment_display = ~7'b1101111; // 9
			default: segment_display = ~7'b0000000; // all lights off
		endcase
	end
endmodule 