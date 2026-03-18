/*
	A typical structure of testbenches is:
		- Define registers that can be manually altered to simulate various circuit inputs.
		- Define wires to act like the outputs driven by the circuit.
		- initialize any other variables/memory before you instantiate the uut.
		- Instantiate the module you're testing, called the unit under test (uut), using your register and wire inputs and outputs.
		- Initialize all input values.
		- while(there are still cases to test)
			- Alter the current inputs so they cover a new test case.
			- Wait some amount of time for the changes to be captured before you try observing them.
			- Using the display() function to observe the outputs caused by the new inputs.
			- Wait again for the results to be observed before you allow any inputs to be changed again.
*/
module tb_HexTo7Seg;

	reg [3:0] test_input;
	wire [6:0] test_output;
	
	integer i;
	
	// When instantiating submodules, the format of parameters is ".name_of_inside_variable(name_of_outside_variable)"
	HexTo7Seg uut(.hex_input(test_input), .segment_display(test_output));
	
	initial begin
			for (i = 0; i < 16; i = i + 1) begin
				test_input = i;
				#5; // #x means "delay for 'x' units of time". Here we delay 5 ns.
				$display("The input: %x drives output: %b", test_input, test_output);
			end
	end
	
	
endmodule