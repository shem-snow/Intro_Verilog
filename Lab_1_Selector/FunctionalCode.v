module FunctionalCode(
	input a0,
	input a1,
	input b0,
	input b1,
	input s0,
	input s1,
	output f0,
	output f1
);
	
	assign f0 = ( (s1 & ~b0 & ~a0) | (~s1 & s0 & a0) | (~s0 & b0 & a0) | (s0 & b0 & ~a0) );
	assign f1 = ( (s1 & ~b1 & ~a1) | (~s1 & s0 & a1) | (~s0 & b1 & a1) | (s0 & b1 & ~a1)) ;
	
	
	
endmodule