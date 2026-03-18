module RippleCarry(
	input [3:0] x,
	input [3:0] y,
	input carryin,
	output [3:0] result,
	output cout
);

wire [3:1] carries;

FullAdder stage0 (.a(x[0]), .b(y[0]), .cin(carryin), .sum(result[0]), .cout(carries[1]) );
FullAdder stage1 (.a(x[1]), .b(y[1]), .cin(carries[1]), .sum(result[1]), .cout(carries[2]) );
FullAdder stage2 (.a(x[2]), .b(y[2]), .cin(carries[2]), .sum(result[2]), .cout(carries[3]) );
FullAdder stage3 (.a(x[3]), .b(y[3]), .cin(carries[3]), .sum(result[3]), .cout(cout) );


endmodule