// `timescale 1ns / 1ps
module tb_selector;

	// Inputs
	reg a0;
	reg a1;
	reg b0;
	reg b1;
	reg s0;
	reg s1;

	// Outputs
	wire f0;
	wire f1;
	
	wire g0;
	wire g1;
	
	wire h0;
	wire h1;

	// All the variables have to be declared before the uut is instantiated.
	integer i, j, k, l, m, n;

	// Instantiate the uut
	TwoBitSelector uut_bdf( .a0(a0), .a1(a0), .b0(b0), .b1(b1), .s0(s0), .s1(s1), .f0(h0), .f1(h1) );
	StructuralCode uut_str( .a0(a0), .a1(a0), .b0(b0), .b1(b1), .s0(s0), .s1(s1), .f0(f0), .f1(f1) );
	FunctionalCode uut_fun( .a0(a0), .a1(a0), .b0(b0), .b1(b1), .s0(s0), .s1(s1), .f0(g0), .f1(g1) );
		
		// Initialize input values
		initial begin
		a0 = 0;
		a1 = 0;
		b0 = 0;
		b1 = 0;
		s0 = 0;
		s1 = 0;
	
		// Run through all the tests and observe the outputs at each value.
		#1;
		for(i = 0; i < 2; i = i + 1) begin
			for(j = 0; j < 2; j = j + 1) begin
				for(k = 0; k < 2; k = k + 1) begin
					for(l = 0; l < 2; l = l + 1) begin
						for(m = 0; m < 2; m = m + 1) begin
							for(n = 0; n < 2; n = n + 1) begin
								a0 = i; a1 = j; b0 = k; b1 = l; s0 = m; s1 = n;
								#1;
								if( (h1 != f1) | (h1 != g1) | (h0 != f0) | (h0 != g0) )
									$display("error at inputs: %b %b %b %b %b %b", s1, s0, b1, b0, a1, a0);
								else
									$display("%b %b", h1, h0);
							end
						end
					end
				end
			end
		end
	end

endmodule




