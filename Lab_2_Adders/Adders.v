// This is the 8-bit adder.
module Adders(
	input [7:0] x, y,
    input cin,
    output [7:0] result,
    output cout
);
	
	wire middle_carry;
	
	LookAhead lsb (.x(x[3:0]), .y(y[3:0]), .cin(cin), .result(result[3:0]), .cOut(middle_carry) );
	LookAhead msb (.x(x[7:4]), .y(y[7:4]), .cin(middle_carry), .result(result[7:4]), .cOut(cout) );
	
endmodule