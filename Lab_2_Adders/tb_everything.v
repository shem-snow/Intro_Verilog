module tb_everything;


// Inputs
reg cIn;
reg [7:0] X;
reg [7:0] Y;

// Outputs
wire [7:0] sum_8;
wire cOut_8;

wire [3:0] sum_ripple;
wire cOut_ripple;

wire [3:0] sum_look;
wire cOut_look;


RippleCarry uut_ripple(
	.carryin(cIn),
	.x(X[3:0]),
	.y(Y[3:0]),
	.result(sum_ripple),
	.cout(cOut_ripple)
);

LookAhead uut_look(
	.cin(cIn),
	.x(X[3:0]),
	.y(Y[3:0]),
	.result(sum_look),
	.cOut(cOut_look)
);

// 8-bit
Adders uut_8(
	.cin(cIn),
	.x(X),
	.y(Y),
	.result(sum_8),
	.cout(cOut_8)
);

initial begin
	#10;
	X = 8'b1111_1111; // 255
	Y = 8'b1111_1111; // 255
	cIn = 0; // 0
	#1;
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X, Y, sum_8, cOut_8);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_ripple, cOut_ripple);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_look, cOut_look);
	
	#10;
	X = 8'b1111_1111; // 255
	Y = 8'b0000_0000; // 0
	cIn = 1; // 1
	#1;
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X, Y, sum_8, cOut_8);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_ripple, cOut_ripple);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_look, cOut_look);
	
	#10;
	X = 8'b0111_1111; // 127
	Y = 8'b0111_1111; // 127
	cIn = 1; // 1
	#1;
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X, Y, sum_8, cOut_8);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_ripple, cOut_ripple);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_look, cOut_look);
	
	#10;
	X = 8'b1000_1100; // 140
	Y = 8'b1100_0001; // 193
	cIn = 1; // 1
	#1;
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X, Y, sum_8, cOut_8);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_ripple, cOut_ripple);
	$display("cIn:%b, x: %8b, y:%4b, sum %4b, Cout:%b", cIn, X[3:0], Y[3:0], sum_look, cOut_look);
end

endmodule 