module tb_RippleCarry;

// Inputs
reg cIn;
reg [3:0] X;
reg [3:0] Y;

// Outputs
wire [3:0] sum;
wire cOut;

// Instantiate the unit under test.
RippleCarry uut(
	.carryin(cIn),
	.x(X),
	.y(Y),
	.result(sum),
	.cout(cOut)
);

initial begin
	#10;
	X = 4'b1101; // 13
	Y = 4'b1001; // 9
	cIn = 1; // 1
	#1;
	$display("cIn:%b, x: %b, Y:%b, sum %4b, Cout:%b", cIn, X, Y, sum, cOut);
end

endmodule
