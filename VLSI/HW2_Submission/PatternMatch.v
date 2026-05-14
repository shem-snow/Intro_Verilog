/*
	Specifications:
		- The machine outputs "Z" when '110' pattern is detected.
		- If '001' is detected, output "E" until the machine is reset.
		- Once "E" is asserted, "Z" should not be asserted again.
*/
module PatternMatch(
	input the_input,
	input reset,
	input clock,
	output reg E,
	output reg Z
);


// Define the states (These are the same names as the instructions. They specify the pattern so far).
parameter S = 3'b000;
parameter S1 = 3'b001;
parameter S11 = 3'b010;
parameter S110 = 3'b011;
parameter S0 = 3'b100;
parameter S00 = 3'b101;
parameter S001 = 3'b110;
parameter broken_state = 3'b111;


// Instantiate memories
reg [2:0] current_state, next_state;



// State progression
always@(posedge clock)
	current_state = next_state;



// Next state prediction (This will also act as the point of entry to my machine).
always@(posedge clock, posedge reset) begin
	
	// Point of entry into the machine
	if(reset)
		next_state = S;
		
	// Machine is already running
	else
		case(current_state)
		
			S: begin
				if(the_input == 1)
					next_state = S11;
				else if(the_input == 0)
					next_state = S0;
				else // Cover the case of unknown inputs at the start.
					;
			end
			
			S1:
				next_state = (the_input)? S11: S0;

			
			S11:
				next_state = (the_input)? S11: S110;
			
			S110:
				next_state = (the_input)? S1: S00;
			
			S0:
				next_state = (the_input)? S1: S00;
			
			S00:
				next_state = (the_input)? S001: S00;
			
			S001:
				next_state = S001;
			
			broken_state:
				next_state = broken_state;
		
		endcase
end




// Output driving
always@(current_state) begin
	case(current_state)
		S: begin
			E = 0;
			Z = 0;
		end
		
		S1: begin
			E = 0;
			Z = 0;
		end
		
		S11: begin
			E = 0;
			Z = 0;
		end
		
		S110: begin
			E = 0;
			Z = 1;
		end
		
		S0: begin
			E = 0;
			Z = 0;
		end
		
		S00: begin
			E = 0;
			Z = 0;
		end
		
		S001: begin
			E = 1;
			Z = 0;
		end
		
		default: begin
			E = 1'bx;
			Z = 1'bx;
		end
	endcase
end

endmodule 