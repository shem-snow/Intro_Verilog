module Counter(
	input enable,
	input clock,
	input reset,
	input [3:0] count_in,
	output reg [3:0] count_out
);

	always@(posedge clock, posedge reset) begin
		if(reset)
			count_out = 4'b0000;
		else
			case(enable)
				1'b1:
					if(count_out > 4'b1000)
						count_out = 4'b0000;
					else
						count_out = count_out + 1;
				1'b0:
					; // latch
				default: // Point of entry
					count_out = 4'b0000;
			endcase
	end
endmodule 