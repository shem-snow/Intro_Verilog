/* 
	The following module implements a selctor circuit (multiplexor) that determines the value of the output "result".
		
		- When the control input "c" is high, then "result" is equal to the total number of 1s between both the inputs (A and B).
		    for example, if A = 010 and B = 111, then there are 4 1s. 
		
		- When "c" is low, "result" is equal to the output of a "Mystery_Function".
		
	However, the circuit has five errors (that we know of) that will prevent compilation.
	Please identify and briefly explain these errors.
*/

module Selector([2:0] A, [2:0] B, c, result);

	integer i = 0;
	
	// Work to be done
	if(c) begin
		result = 0;
		for(count_A = 0; count_A < 3; count_A = count_A + 1) begin
			if(A[i] == 1)
				result = result + 1;
			if(B[i] == 1)
				result = result + 1;
		end
	end
	
	else begin
		Mystery_Function inst(.A(x), .B(y), .result(z)); // Assume "x" and "y" are inputs and "z" is the output of the module "Mystery_Function".
	end																 // and "A", "B", and "result" are the connections in the current module "Selector".

	

endmodule

/* Solution:
	
	1. Input and output connections are not in the module declaration.
	     It is not enough that they be declared input/output inside the module.
		  
		  The declaration should be changed to either:
		     module Selector(A, B, c, result);
		  or the input/output declarations inside can be removed and the declaration be changed to:
		     module Selector([2:0] A, [2:0] B, c, [2:0] result);
			  
	2. A for-loop cannot exist as a hardware description because it performs step-by-step 'instructions' (undefined behavior for hardware).
	   It must exist within a Verilog construct (such as initial) that can handle instruction-like behavior.
	
	3. the "result" is a wire so 
	   data cannot be written to it unless the "assign" keyword is used or the wire is placed at the output of a submodule.
		
	
	4. The syntax for instantiating the submodule "Mystery_Function" is incorrect.
	   
		It should be switched to "Mystery_Function inst(.x(A), .y(B), .z(result));
		The proper way to write parameters is: .name_of_io_pin_in_the_submodule(name_of_variable_in_the_current_module_to_connect_it_to) 
	
	5. The result is being is being assigned twice. A wire cannot be driven by multiple values because it causes undeterministic behavior.
			1. It's connected to the output of the Mystery_Function module.
			2. It is being assigned (improperly) in the conditional statement. 
		  
*/



/* Here is a list of objectives we might cover:
		
		1. The difference between wire and register.

		2. That hardware has no concept of time so 'instructions' like for-loops and assignments without the "assign" keyword must exist within special blocks (like "initial").

		3. How to write a testbench and know what a testbench does.

		4. The difference between structural and functional code.

		5. How to instantiate one module inside another.

		6. Know how to write a module declaration so each input and output is specified.
	
	This question covers objectives: 1, 2, 4, 5, 6
	Objective 3 is still somewhat covered because testbenches use most these conceps
*/