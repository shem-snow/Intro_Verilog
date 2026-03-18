module ClockDivider(input fast_clock, output reg slow_clock);

reg [31:0] accumulator = 0;
reg started = 1'b0;

always@(posedge fast_clock) begin
	
	if(~started)
		started <= 1'b1;
	else begin
		if(accumulator >= 25_000_000) begin
			accumulator <= 0;
			slow_clock <= ~slow_clock;
		end
		else
			accumulator <= accumulator + 1;
	end
end

endmodule 