// 4-bit Carry Look-Ahead Adder implemented with structural code.
module Structural(
    input [3:0] A, B,     // Inputs A and B
    input Cin,            // Input carry
    output [3:0] Sum,     // Output sum
    output Cout           // Output carry
);
    wire [3:0] P, G;      // Propagate and Generate signals
    wire [3:0] C;         // Internal carries

    // Generate and Propagate signals
    assign P = A ^ B;
    assign G = A & B;
	 
    // Instantiate Look-Ahead Carry Unit (LCU)
    LookAheadCarryUnit LCU (.P(P), .G(G), .Cin(Cin), .C(C));

    // Instantiate 4 Full Adders for Sum computation
    FullAdder FA0 (.a(A[0]), .b(B[0]), .cin(C[0]), .sum(Sum[0]), .cout());
    FullAdder FA1 (.a(A[1]), .b(B[1]), .cin(C[1]), .sum(Sum[1]), .cout());
    FullAdder FA2 (.a(A[2]), .b(B[2]), .cin(C[2]), .sum(Sum[2]), .cout());
    FullAdder FA3 (.a(A[3]), .b(B[3]), .cin(C[3]), .sum(Sum[3]), .cout());

    // Final Carry Out
    assign Cout = C[3];

endmodule 


// 4-bit Look-Ahead Carry Unit (LCU)
module LookAheadCarryUnit (
    input [3:0] P, G,    // Propagate and Generate signals
    input Cin,
    output [3:0] C       // Carry signals
);
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
endmodule