/*
	Objectives I think students should know:
	
		1. The difference between wire and register.
		2. That hardware has no concept of time so 'instructions' like for-loops and assignments without the "assign" keyword must exist within special blocks (like "initial").
		3. How to write a testbench and know what a testbench does.
		4. The difference between structural and functional code. 
		5. How to instantiate one module inside another.
		6. Know how to write a module declaration so each input and output is specified. 


*/


/* Three practice problems */

/* ------------------------------------------------------- #1: Covers objectives: 1, 2, 5, 6 -------------------------------------------------------
* 
* The following module has five errors in it that will prevent compilation.
* Identify and briefly explain these errors.
*/
module garbage_module();
	
	// inputs and outputs
	input a;
	input b;

	output [15:0] c;
	
	// internal data
	wire d;
	integer i;
	
	// Instatiation of another module
	submodule inst(.c(a), .b(d)); // Assume "a" is the input and "b" is the output of this module.
	
	
	// Work to be performed:
	c = 0;
	for(i = 0; i < 12; i = i + 1) begin
		c = i;
	end
	

	assign d = 1;

endmodule


/* 
	1. Input and output connections are not in the module declaration.
	     It is not enough that they be declared input/output inside the module.
		  The declaration should be changed to either:
		     module garbage_module(a, b, c);
		  or the input/output declarations inside can be removed and the declaration be changed to:
		     module garbage_module(input a, input b, output reg [15:0] c);
			  
	2. The statements:
	     c = 0;
	     c = i;
		are each storing data into a wire which is undefined behavior for hardware because wires are floating pieces of metal.
		To assign value to a wire, either continuously drive the value using the "assign" keyword or connect the wire to the 
		output of a structural block.
	
	3. A for-loop cannot exist as a hardware description.
	   It must exist within a Verilog construct (such as initial) that can handle instruction-like behavior.
		
	
	4. The syntax for instantiating a "submodule" is incorrect.
	   
		It should be switched to "submodule inst(.a(c), .b(d));"
		The proper way to write parameters is: .name_of_io_pin_in_the_submodule(name_of_variable_in_the_current_module_to_connect_it_to) 
	
	5. The wire "d" is connected to both the output of the submodule and is continuously asigned the value of 1.
	   A wire cannot be driven by multiple values because it causes undeterministic behavior.
		  
*/





/* --------------------------------------- #2: Covers objectives 1, 3, 5 -------------------------------------------------------
* This module implements a storage space that holds 16 bits of data.
*
* The module's function is for the user to input a 4-bit "position" that specifies which of the 16 bits will be read on the output called "target".
* For example: the input 4'b0011 would cause the third least significant bit in 'bits' to be output on 'target'.
*
* For this question, suppose you have been given this module and told the bit at 'bits[8]' holds a logically high value.
*
* Write the entire testbench module that would prove or disprove that.
*/
module status_register (input [3:0] position, output reg target);

   reg [15:0] bits;

   always @(position) begin
      target <= bits[position];
	end
	
	
endmodule




/* Solution */

module tb_register_file;

	// The input should connect to a register.
	reg [3:0] addr;

	// The output should connect to a wire.
	wire [15:0] tgt;
	
	
	// Instantiate the unit under test.
	register_file uut(.address(addr), .target(tgt));


	initial begin
		
		// Set the input that will cause the desired output.
		addr = 4'b1000;
		
		// Wait for the output response.
		#1;
		
		// Observe the output response.
		$display("%d", target);
	end

endmodule 






/* ------------------------------------------------------- #3: Covers objective 4 -------------------------------------------------------
* Write the following circuit in verilog using only structural code.
*
* 
*/

