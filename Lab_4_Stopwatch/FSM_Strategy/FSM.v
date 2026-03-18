module FSM(board_clock, reset, start, stop, segment_display);

// Inputs
input board_clock;
input reset;
input start; // active low
input stop; // active low

// Outputs
output [6:0] segment_display;

// Variables
reg [3:0] count;
	
// States
reg current_state, next_state;

// Internal connections
wire reference_clock;

// Instantiate helper modules
ClockDivider clkdiv(.fast_clock(board_clock), .slow_clock(reference_clock));
BinToSevSeg(.binary_input(count), .segment_display(segment_display));



/*_________________________Finite State Machine management_________________________*/

// Current state progression
// Making this block sensitive to the inputs reduces response delay.
always@(posedge reference_clock, posedge reset, negedge start, negedge stop) begin
	current_state <= next_state;
end

// Next state prediction
always@(posedge reference_clock, posedge reset, negedge start, negedge stop) begin
	if(reset | ~stop)
		next_state <= 0;
	else if(~start)
		next_state = 1;
	else
		next_state <= next_state;
end

// Output driving and current state work
always@(posedge reference_clock) begin
	case(current_state)
		1:
			if(count > 4'b1000)
				count = 4'b0000;
			else
				count = count + 1;
		
		default:
			if(reset)
				count <= 4'b0000;
			else
				count <= count;
	endcase
end

endmodule 