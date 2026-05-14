/*
	Applies the input stream: 0010_0101_0011_1101_0111_0111 where the first input is the LSB.
*/
module tb_PatternMatch;


// Inputs
reg the_input, reset, clock;

// Outputs
wire E, Z;

// Loop iteration variables
integer i;
integer input_stream;
integer pattern_so_far;


// Instantiate the unit under test
PatternMatch uut(.the_input(the_input), .reset(reset), .clock(clock), .E(E), .Z(Z));


// Clock generation
initial begin
	clock = 0;
	forever #5 clock = ~clock;

end


// Simulation
initial begin
	
	// Force the machine into a stable state
	repeat(1)@(posedge clock);
	reset = 1;
	
	// And set initial values
	input_stream = 24'b0010_0101_0011_1101_0111_0111;
	pattern_so_far = 24'bx;
	repeat(1)@(posedge clock);
	
	// Release the reset signal. Everything you've done up to this point enforces the 'point of entry'.
	reset = 0;
	@(posedge clock); // Wait for the next clock cycle and now the machine will begin to run
	
	// The input stream has 24 bits so we will loop 24 times.
	for(i = 0; i < 24; i = i + 1) begin
		the_input = input_stream[i];
		pattern_so_far[i] = input_stream[i];
		repeat(1)@(posedge clock); // Delay for signal stabilization after the rising clock edge.
		$display("At pattern: %b, EZ = %b %b", pattern_so_far[23:0], E, Z);
	end
end


endmodule