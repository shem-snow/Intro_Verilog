module tb_CPU;

	// In
	reg clock, reset;
	reg [3:0] switches;
	
	// Out
	wire done;
	wire [6:0] display;
	
	// Memory
	integer i;
	
	// Instantiate uut
	CPU uut(.clock(clock), .reset(reset), .FPGA_switches(switches), .segment_display(display), .done(done));

	// Generate a clock
	initial begin
		clock = 0;
		forever #1 clock = ~clock;
	end
	
	
	// Do the simulation
	initial begin
	
		// Initialize and wait for global reset
		reset = 1;
		#5; 
		
		// Run the program:
		for(i = 4'b0000; i < 4'b1010; i = i + 1) begin
			switches = i;
			reset = 0;
			wait(done);
			reset = 1;
		end
	end

endmodule