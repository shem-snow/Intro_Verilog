module ALU(
	input [3:0] A,
	input [3:0] B,
	input [1:0] opcode,
	output reg [3:0] result
);

	always@(A, B, opcode) begin
		case(opcode)
			2'b00: result = A + B;
			2'b01: result = A | B;
			2'b10: result = A ^ B;
			2'b11: result = ~A;
		endcase
	end
endmodule 