module Buffer(
	input enable,
	input [3:0] in,
	inout [3:0] out
);
	assign out = enable? in : 4'bzzzz;
endmodule 