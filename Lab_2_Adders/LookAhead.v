/*
	NOTICE: ADDITION (+) WILL MESS UP YOUR RESULTS SO USE BITWISE OR (|) instead.
*/
module LookAhead(
	input [3:0] x,
	input [3:0] y,
	input cin,
	output [3:0] result,
	output cOut
);

	// ------------------------------------- The equations are------------------------------------
	
	// c_(i+1) = x_i & y_i | (x_i + y_i) & c_i
	// c_(i+1) = gen_i | (prop_i & c_i)
	
	// ------------------------------------- So it would follow that the verilog implementation is ------------------------------------
	wire [3:0] carr, gen, prop;
	
	assign gen = (x & y);
	assign prop = (x | y);
	
	assign carr[0] = cin;
	assign carr[1] = gen[0] | (prop[0] & carr[0]);
	assign carr[2] = gen[1] | (prop[1] & carr[1]);
	assign carr[3] = gen[2] | (prop[2] & carr[2]);
	assign cOut = gen[3] | (prop[3] & carr[3]);
	
	assign result = x ^ y ^ carr;
	
	
	/* ----------------
	However, the carries still delay the circuit. The intuitive solution is to make so each carry depends ONLY on the circuit inputs and no 
	intermediate logic.
	-------------------*/
	//assign carr[0] = cin;
	//assign carr[1] = (x[0] & y[0]) | ( (x[0] | y[0]) & cin);
	//assign carr[2] = (x[1] & y[1]) | ( (x[1] | y[1]) & ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) ) ) ;
	//assign carr[3] = (x[2] & y[2]) | ( (x[2] | y[2]) & ( (x[1] & y[1]) | ( (x[1] | y[1]) & ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) ) ) ) );
	
	//assign cOut = (x[3] & y[3]) | ( (x[3] | y[3]) & ( (x[2] & y[2]) | ( (x[2] | y[2]) & ( (x[1] & y[1]) | ( (x[1] | y[1]) & ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) ) ) ) ) ) );
	
	//assign result[3] = x[3] ^ y[3] ^ ( (x[2] & y[2]) | ( (x[2] | y[2]) & ( (x[1] & y[1]) | ( (x[1] | y[1]) & ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) ) ) ) ) );
	//assign result[2] = x[2] ^ y[2] ^ ( (x[1] & y[1]) | ( (x[1] | y[1]) & ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) ) ) );
	//assign result[1] = x[1] ^ y[1] ^ ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) );
	//assign result[0] = x[0] ^ y[0] ^ cin;
	
	
	/*-----------
	It didn't matter that the carries only depended on the inputs. Quartus synthesized the circuit differently but the carries still caused delay.
	Probably because gates only have two inputs so complicated logic requires intermediate wires anyways.
	
	In this attempt, I simplify the circuit down to 2-level logic. The largest minterm contains 5 literals. Making the critical path 5 gates.
	----------*/
	
	//wire [3:0] carr;
	//assign carr[0] = cin;
	//assign carr[1] = (x[0] & y[0]) | (x[0] & cin) | (y[0] & cin);
	//assign carr[2] = (x[1] & y[1]) | (x[0] & x[1] & y[0]) | (x[0] & x[1] & cin) | (x[1] & y[0] & cin) | (x[0] & y[0] & y[1]) | (x[0] & y[1] & cin) | (y[0] & y[1] & cin);
	//assign carr[3] = (x[2] & y[2]) | (x[1] & x[2] & y[1]) | (x[0] & x[1] & x[2] & y[0]) | (x[0] & x[1] & x[2] & cin) | (x[1] & x[2] & y[0] & cin) | (x[0] & x[2] & y[0] & y[1]) | (x[0] & x[2] & y[1] & cin) | (x[2] & y[0] & y[1] & cin) | (x[1] & y[1] & y[2]) | (x[0] & x[1] & y[0] & y[2]) | (x[0] & x[1] & y[2] & cin) | (x[1] & y[0] & y[2] & cin) | (x[0] & y[0] & y[1] & y[2]) | (x[0] & y[1] & y[2] & cin) | (y[0] & y[1] & y[2] & cin);
	//assign cOut = (x[3] & y[3])
	//	| (x[2] & y[2] & x[3]) | (x[1] & x[2] & x[3] & y[1]) | (x[0] & x[1] & x[2] & x[3] & y[0]) | (x[0] & x[1] & x[2] & x[3] & cin) | (x[1] & x[2] & x[3] & y[0] & cin) | (x[0] & x[2] & x[3] & y[0] & y[1]) | (x[0] & x[2] & x[3] & y[1] & cin) | (x[2] & x[3] & y[0] & y[1] & cin) | (x[1] & x[3] & y[1] & y[2]) | (x[0] & x[1] & x[3] & y[0] & y[2]) | (x[0] & x[1] & x[3] & y[2] & cin) | (x[1] & x[3] & y[0] & y[2] & cin) | (x[0] & x[3] & y[0] & y[1] & y[2]) | (x[0] & x[3] & y[1] & y[2] & cin) | (x[3] & y[0] & y[1] & y[2] & cin)
	//	| (x[2] & y[2] & y[3]) | (x[1] & x[2] & y[1] & y[3]) | (x[0] & x[1] & x[2] & y[0] & y[3]) | (x[0] & x[1] & x[2] & y[3] & cin) | (x[1] & x[2] & y[0] & y[3] & cin) | (x[0] & x[2] & y[0] & y[1] & y[3]) | (x[0] & x[2] & y[1] & y[3] & cin) | (x[2] & y[0] & y[1] & y[3] & cin) | (x[1] & y[1] & y[2] & y[3]) | (x[0] & x[1] & y[0] & y[2] & y[3]) | (x[0] & x[1] & y[2] & y[3] & cin) | (x[1] & y[0] & y[2] & y[3] & cin) | (x[0] & y[0] & y[1] & y[2] & y[3]) | (x[0] & y[1] & y[2] & y[3] & cin) | (y[0] & y[1] & y[2] & y[3] & cin);
	
	
	
	// not yet simplified:
	//assign result[3] = x[3] ^ y[3] ^ ( (x[2] & y[2]) | ( (x[2] | y[2]) & ( (x[1] & y[1]) | ( (x[1] | y[1]) & ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) ) ) ) ) );
	//assign result[2] = x[2] ^ y[2] ^ ( (x[1] & y[1]) | ( (x[1] | y[1]) & ( (x[0] & y[0]) | ( (x[0] | y[0]) & cin) ) ) );
	
	//assign result[1] = (x[0] & y[0] & x[1] & y[1]) | (x[0] & x[1] & y[1] & cin) | (y[0] & x[1] & y[1] & cin) | (x[0] & y[0] & ~x[1] & ~y[1]) | (x[0] & ~x[1] & ~y[1] & cin) | (y[0] & ~x[1] & ~y[1] & cin)
	//						| (x[1] & ~y[1] & ~x[0] & ~cin) | (x[1] & ~y[1] & ~y[0]) | (~x[1] & y[1] & ~x[0] & ~cin) | (~x[1] & y[1] & ~y[0]);
	//assign result[0] = x[0] ^ y[0] ^ cin;
	
	
	
	
	
	/*
	-----------
	The synthesizer does create two-level logic but it is not a look ahead adder. The solution is to write structural code:
	----------
	
	*/
	
endmodule



