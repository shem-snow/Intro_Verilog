module tb_HalfAdder;

// Inputs
reg X;
reg Y;

// Outputs
wire sum;
wire cOut;

// loop counters
integer i, j;

// Instantiate the unit under test.
HalfAdder uut(
	.a(X),
	.b(Y),
	.sum(sum),
	.cout(cOut)
);

initial begin

	for(i = 0; i < 2; i = i + 1) begin
		for(j = 0; j < 2; j = j + 1) begin
			X = i;
			Y = j;
			#5;
			$display("%b + %b = %b with carry %b", X, Y, sum, cOut);
		end
	end
end

endmodule