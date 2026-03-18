module tb_FSM;
	
	// inputs
	reg clk;
	reg rst;
	reg rsm; // active low
	reg stp; // active low
	
	// outputs
	wire [3:0] count_plusplus;
	wire running;
	
	// instantiate uut
	FSM fsm(.clock(clk), .reset(rst), .start(rsm), .stop(stp), .running(running));
	Counter cntr(.enable(running), .reset(rst), .clock(clk), .count_in(bcd), .count_out(count_plusplus));
	
	// Clock generation
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	// Simulate
	initial begin
		
		// The board starts like this.
		rst = 1;
		rsm = 1;
		stp = 1;
		#15;
		
		// Release the reset and the output should remain at zero.
		rst = 0;
		#15;
		
		// Start counting by pressing the resume button.
		rsm = 0;
		#5; // The timer should now start counting.
		rsm = 1;
		
		# 15; // Watch the numbers go up.
		
		// Stop counting
		stp = 0;
		# 15; // The timer should remain stopped no matter how much time elapses.
		stp = 1;
		
		// Until resume is pressed again.
		rsm = 0;
		#5; // The timer should resume counting.
		rsm = 1;
		#15;
		
		// The count should reset to zero when the reset is pressed.
		rst = 0;
		#15; // and not count.
		
	end

endmodule 