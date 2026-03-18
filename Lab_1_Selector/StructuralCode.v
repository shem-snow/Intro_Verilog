module StructuralCode(
	input a0,
	input a1,
	input b0,
	input b1,
	input s0,
	input s1,
	output f0,
	output f1

);
	not(_s1, s1);
	not(_s0, s0);
	not(_b1, b1);
	not(_b0, b0);
	not(_a1, a1);
	not(_a0, a0);
	
	and(i, s1, _b0, _a0);
	and(j, _s1, s0, a0);
	and(k, _s0, b0, a0);
	and(l, s0, b0, _a0);
	
	and(w, s1, _b1, _a1);
	and(x, _s1, s0, a1);
	and(y, _s0, b1, a1);
	and(z, s0, b1, _a1);
	

	or(f0, i, j, k, l);
	or(f1, w, x, y, z);
	
endmodule
