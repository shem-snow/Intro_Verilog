module tb_lock;


// inputs
reg [3:0] pass;
reg enter;
reg clk;
reg rst;

// outputs
wire lock, warn, alarm;


// Instantiate the unit under test
Lock dut(.password(pass), .clock(clk), .enter(enter), .reset(rst), .lock(lock), .warning(warn), .alarm(alarm));


// Clock generation
initial begin
	clk = 0;
	forever #5 clk = ~clk;
end


// Simulate
initial begin
	
	
	// Test 1: Correct password on the first attempt.
	
	rst = 0;
	enter = 0;
	
	pass = 4'b0110;
	#5
	rst = 1;
	#5
	enter = 1;
	
	#30
		
	// Test 2: Correct password on the second attempt
	
	// first attempt
	rst = 0;
	enter = 0;
	
	pass = 4'b0000;
	#5
	rst = 1;
	#5
	enter = 1;
	
	#30
	
	// second attempt
	enter = 0;
	
	pass = 4'b0110;
	#5
	enter = 1;
	
	#30
	
	
	// Test 3: Correct password on the third attempt
	
	// first attempt
	rst = 0;
	enter = 0;
	
	pass = 4'b0000;
	#5
	rst = 1;
	#5
	enter = 1;
	
	#30
	
	// second attempt
	enter = 0;
	
	pass = 4'b1001;
	#5
	enter = 1;
	
	// third attempt
	enter = 0;
	
	pass = 4'b0110;
	#5
	enter = 1;
	
	#30
	
	
	// Test 4: Correct password on the fourth attempt (should not unlock the machine)
		
	// first attempt
	rst = 0;
	enter = 0;
	
	pass = 4'b0000;
	#5
	rst = 1;
	#5
	enter = 1;
	
	#30
	
	// second attempt
	enter = 0;
	
	pass = 4'b1001;
	#5
	enter = 1;
	#30
	
	// third attempt
	enter = 0;
	
	pass = 4'b1011;
	#5
	enter = 1;
	#30
	
	
	// fourth attempt
	enter = 0;
	
	pass = 4'b0110;
	#5
	enter = 1;

end

endmodule 