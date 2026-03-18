module EdgeTriggeredRegister(
	input clock, // It breaks if it's not sensitive to the clock.
	input enable,
	input [3:0] D_in,
	input reset,
	output reg [3:0] Q_out
);
	always@(posedge clock, posedge reset, posedge enable) begin
		if(reset)
			Q_out = 4'b0000;
		else if(enable)
			Q_out = D_in;
		else
			; // latch
	end
endmodule 