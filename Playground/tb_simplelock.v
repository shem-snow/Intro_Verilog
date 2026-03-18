module tb_simplelock;


// inputs
reg [3:0] pass;
reg enter;
reg clk;
reg rst;

// outputs
wire lock;


// Instantiate the unit under test
SimpleLock dut(.password(pass), .clock(clk), .enter(enter), .reset(rst), .lock(lock));


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
	
	#30;

end

endmodule 