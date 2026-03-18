module tb_Comparator;

// inputs
reg [3:0] A, B;
reg sign;

// output
wire [3:1] F;

// Loop counters.
integer i, j, k;

Comparator uut(.A(A), .B(B), .c(sign), .F(F));

initial begin
	
	A = 4'b0000;
	B = 4'b0000;
	
	for(k = 0; k < 2; k = k + 1) begin
		sign = k;
		$display("C=%b", sign);
		for(i = 0; i < 16; i = i + 1) begin
			A = i;
			for(j = 0; j < 16; j = j + 1) begin
				B = j;
				#5;
				$display("A=%4b, B=%4b, F=%3b", A, B, F);
			end
		end
	end

end

endmodule