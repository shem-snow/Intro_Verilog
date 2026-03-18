/*
	My strategy uses the result of subtraction to compare A and B to each other.
	The circuit specifications are that the output F[3:1] is a one-hot encoding of the following statements:
		- A > B => F = 001
		- A < B => F = 100
		- A == B => F = 010
		- The input "c" is a control signal that specifies if the operands are treated as two's complement numbers.
		
	In summary, my approach uses the difference between A-B to evaluate the ternary expression:
		(A > B)? (F1 = 1, F2 = 0, F3 = 0) : [ (A == B)? (F1 = 0, F2 = 1, F3 = 0):(F1 = 0, F2 = 0, F3 = 1)];
*/
module Comparator(
	input [3:0] A,
	input [3:0] B,
	input c,
	output reg [3:1] F
);

wire [3:0] difference;
assign difference = A - B;

always@(A, B, c) begin
	
	// Initialize all F values to zero then change the F values according to the assignment instructions.
	F = 3'b000;

	if(c == 1'b1) begin // Then the inputs are Two's complement.
		
		// Check the signs of A and B. If they're not equal, the positive one is bigger.
		if(A[3] == B[3]) begin // The two input are the same sign
			
			// Compute the difference and check if they're equal.
			if(difference == 4'b0000) // The two inputs are equal
				F[2] = 1'b1;
			// If the difference is negative A<B
			else if(difference[3] == 1'b1)
				F[3] = 1'b1;
			else // the result is positive => A > B
				F[1] = 1'b1;
		end
		else begin
			if(A[3] == 1'b1) // A is negative => A < B
				F[3] = 1'b1;
			else // A is positve => A > B
				F[1] = 1'b1;
		end
	end

	else begin // The inputs are signed.
		if(A>B)
			F[1] = 1'b1;
		else if(A==B)
			F[2] = 1'b1;
		else
			F[3] = 1'b1;
	end

end

endmodule