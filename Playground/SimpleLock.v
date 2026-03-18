module SimpleLock(input [3:0] password, input clock, input enter, input reset, output reg lock);
	
	parameter locked = 1'b0;
	parameter unlocked = 1'b1;
	
	// Functional code used to determine if the currently entered password is correct.
	wire correct_password;
	assign correct_password = (password == 4'b0110); 

	// Structural code to convert the active-low reset into an active high 'true reset' variable. 
	wire true_reset;
	not(true_reset, reset); 

	// The Finite state machine broken into three processes: state progression, next state predition, and output driving:
	reg [1:0] current_state, next_state;

	always@(posedge clock)
		current_state = next_state;
	
	always@(posedge enter, posedge true_reset) begin
		if(true_reset)
			next_state <= locked;
		else if(current_state == locked)
			next_state <= (correct_password)? unlocked: locked;
		else 
			next_state <= current_state;
	end

	always@(current_state)
		lock <= (current_state == unlocked)? 1'b0 : 1'b1;
	
endmodule 