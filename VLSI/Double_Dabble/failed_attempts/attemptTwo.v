	/* 
		
			
	*/
	module attemptTwo(
		input enable,
		input [7:0] binary,
		input clk,
		output reg [11:0] BDC,
		output reg done
);

	parameter start = 3'b000;
	parameter check = 3'b001;
	parameter add_ones = 3'b010;
	parameter add_tens = 3'b011;
	parameter add_hundys = 3'b100;
	parameter shift = 3'b101;
	parameter complete = 3'b110;
	parameter you_broke_it = 3'b111;
	
	reg [5:0] current_state;
	reg [5:0] next_state;
	
	reg [19:0] scratchpad;
	
	// Flags
	wire ones;
	wire tens;
	wire hundys;
	assign ones = scratchpad[11:8] > 4'b0100;
	assign tens = scratchpad[15:12] > 4'b0100;
	assign hundys = scratchpad[19:16] > 4'b0100;
	wire bottom_bits_cleared;
	assign bottom_bits_cleared = scratchpad[7:0] == 0;
	
	
	/* -----------------------------------------		FSM Start	------------------------------------------------------- */

	// State progression
	always@(posedge clk) begin
		if(enable)
			current_state <= next_state;
		else
			;
	end
	
	// Next state prediction
	always@(current_state, enable) begin
		
		case(current_state)
			
			start: 
				next_state <= check;
	
			check: 
				if(bottom_bits_cleared) begin
					if(ones)
						next_state <= add_ones;
					else if(tens)
						next_state <= add_tens;
					else if(hundys)
						next_state <= add_hundys;
					else
						next_state <= complete;
				end	
				else
					next_state <= shift;
			
			shift: begin
				next_state <= check;
			end
			
			add_ones:
				next_state <= check;
			
			add_tens:
				next_state <= check;
			
			add_hundys:
				next_state <= check;
			
			complete:
				next_state <= start;
			
			you_broke_it:
				next_state <= start;
			
			default:
				next_state <= you_broke_it;
				
			endcase
	
	end
	
	// State work
	always@(current_state) begin : state_work
		
		case(current_state)
			
			start: begin
				// Create a 20-bit register whose first 12 bits are zero and least significant 8 bits are the binary number.
				scratchpad <= {12'b0000_0000_0000, binary};
				
				// Initialize all variables
				done <= 0;
				BDC <= 12'b0000_0000_0000;
			end
			
			check:
				; // Do nothing. Check only ensures the NEXT state will do the proper work.
				
			
			shift:
				scratchpad <= scratchpad << 1;
				
			add_ones:
				scratchpad[11:8] <= scratchpad[11:8] + 4'b0100;
			
			add_tens:
				scratchpad[15:12] <= scratchpad[15:12] + 4'b0100;
			
			add_hundys:
				scratchpad[19:16] <= scratchpad[19:6] + 4'b0100;
			
			complete: begin
				BDC <= scratchpad[19:8];
				done <= 1;
			end
			
			
			you_broke_it:
				BDC <= 0000_0000_0000;
			default:
				BDC <= 0000_0000_0000;
			
		endcase
	
	end




endmodule