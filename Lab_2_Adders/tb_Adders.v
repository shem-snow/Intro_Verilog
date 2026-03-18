module tb_Adders;

// Inputs
reg cIn;
reg [7:0] X;
reg [7:0] Y;

// Outputs
wire [7:0] sum;
wire cOut;

// Instantiate the unit under test.
Adders uut(
	.cin(cIn),
	.x(X),
	.y(Y),
	.result(sum),
	.cout(cOut)
);

initial begin
	#10;
	X = 8'b1111_1111; // 255
	Y = 8'b1111_1111; // 255
	cIn = 0; // 0
	#1;
	$display("cIn:%b, x: %8b, y:%8b, sum %8b, Cout:%b", cIn, X, Y, sum, cOut);
	
	#10;
	X = 8'b1111_1111; // 255
	Y = 8'b0000_0000; // 0
	cIn = 1; // 1
	#1;
	$display("cIn:%b, x: %8b, y:%8b, sum %8b, Cout:%b", cIn, X, Y, sum, cOut);
	
	#10;
	X = 8'b0111_1111; // 127
	Y = 8'b0111_1111; // 127
	cIn = 1; // 1
	#1;
	$display("cIn:%b, x: %8b, y:%8b, sum %8b, Cout:%b", cIn, X, Y, sum, cOut);
	
	#10;
	X = 8'b1000_1100; // 140
	Y = 8'b1100_0001; // 193
	cIn = 1; // 1
	#1;
	$display("cIn:%b, x: %8b, y:%8b, sum %8b, Cout:%b", cIn, X, Y, sum, cOut);
end

endmodule