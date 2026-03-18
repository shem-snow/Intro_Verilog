module Control(
	input reset,
	input resume,
	input stop,
	output reg enable
);
	always@(reset, resume, stop) begin
		if(reset | ~stop) // stop is active low
			enable <= 0;
		else if(~resume) // resume is active low
			enable <= 1;
		else
			; // latch
	end
endmodule 