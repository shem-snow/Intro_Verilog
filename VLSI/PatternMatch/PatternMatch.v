/*
	The following module implements a Finite State Machine for a system that recieves a one-bit input that is measured at every clock cycle.
	The machine watches for certain 3-bit patterns of interest and sets the two outputs (E and Z) to signify that the patterns have occured.

	Specifications:
		- The machine outputs "Z" when '110' pattern is detected.
		- If '001' is detected, the machine outputs "E" until the machine is reset.
		- Once "E" is asserted, "Z" should not be asserted again.
*/
module PatternMatch(the_input, reset, clock, E, Z);

// Inputs
input the_input;
input reset;
input clock;
	
// Outputs
output reg E;
output reg Z;

// Variables (memory)
// We could have used a 3-bit register to hold the most recent pattern but instead, this machine uses multiple states so we don't need to use memory.
// As a general rule, you can remember that there is a trade-off between the number of states your machine uses and how much memory it has.
// Also as a general rule, the less states your machine has, the more complicated those states are. Think of our counter for example.
//  Using only two states (counting and not-counting) requires you to think. Using a state for every digit (0-9) makes the machine simple
//   where each state only needs to check for the three inputs and decide which of only three options to take. 

// States (These names specify the pattern so far)
parameter S = 3'b000; // No inputs received yet. This state is our point of entry.
parameter S1 = 3'b001;
parameter S11 = 3'b010;
parameter S110 = 3'b011;
parameter S0 = 3'b100;
parameter S00 = 3'b101;
parameter S001 = 3'b110;
parameter broken_state = 3'b111;


// _______________________________________________________________ Building the FSM ____________________________________________________________


// Save two registers to keep track of the current and next state the machine should be in.
reg [2:0] current_state, next_state;



// Concern #1 of the three process method: STATE PROGRESSION
// After every clock cycle, the machine will progress forward
always@(posedge clock)
	current_state = next_state; 



// Concern #2 of the three process method: NEXT STATE PREDICTION
// Observe the current condition of the machine and predict what to do next.
// We should not transition yet because we need to leave enough time for the current state to do its work.
// This is where I personally like to insert my "point of entry" for the machine. You can also do it in the State Progression block if you want.
always@(posedge clock, posedge reset) begin
// Note the sensitivity list here. Ideally, we should be sensitive to the current state but Verilog gives an error when you mix 'double edges' with 'single edges'.
// Therefore we often use an alternative strategy which is to be sensitive to the clock instead and assume (hope) the clock is fast enough to catch all changes. 

	// Point of entry into the machine
	if(reset)
		next_state = S;
		
	// Machine is already running
	else
		case(current_state)
		
			S: begin
				if(the_input == 1)
					next_state = S1;
				else if(the_input == 0)
					next_state = S0;
				else // Cover the case of unknown inputs at the start.
				     // Before your 'point of entry' is reached, every piece of data in your circuit is filled with 'x' (unknown value).
				     // Not accounting for this WILL OFTEN BREAK YOUR MACHINE!
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
				next_state = broken_state; // This state should never be reached. I just like to add it so I have 8 states total which matches up with the 3-bits I used to represent the state.
							   // Rather than having a useless and unreachable state, some people like to default into a state that enforces their 'point of entry'.
		
		endcase
end




// Concern #3 of the three process method: OUTPUT DRIVING
// This is the work that your machine should be doing in the current state.
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