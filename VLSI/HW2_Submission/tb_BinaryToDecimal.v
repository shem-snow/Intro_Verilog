module tb_BinaryToDecimal;
	
	// Instantiate a register for the inputs and a wire for the output.
	reg en;
	reg [7:0] test_input;
	reg clk;
	wire done;
	wire [11:0] test_output;
	
	// Initialize loop count variable for testbench cases
	integer i;
	
	// Instantiate the unit under test
	BinaryToDecimal uut(.enable(en), .binary(test_input), .clk(clk), .BDC(test_output), .done(done));

	
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	
	
	// Test all cases
	initial begin
		en = 0;
		repeat(2)@(posedge clk);
			for (i = 100; i < 255; i = i + 1) begin
			 //i = 175; // troublesome input
				if(!en)
					en = 1;
				test_input <= i;
				repeat(2)@(posedge clk);
				wait(done); 
				$display("%d ---> %b ---> %d %d %d", test_input, test_output, test_output[11:8], test_output[7:4], test_output[3:0]);
			end
	end

endmodule
		
	

	
	