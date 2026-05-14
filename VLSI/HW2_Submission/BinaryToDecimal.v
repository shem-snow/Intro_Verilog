	/* 
		
			
	*/
	module BinaryToDecimal(
		input enable,
		input [7:0] binary,
		input clk,
		output reg [11:0] BDC,
		output reg done
);

	parameter start = 2'b00;
	parameter check = 2'b01;
	parameter shift = 2'b10;
	parameter complete = 2'b11;
	
	reg [1:0] current_state;
	reg [1:0] next_state;
	
	reg [19:0] scratchpad;
	
	// Flags
	reg [3:0] times_shifted;
	
	reg ones;
	reg tens;
	reg hundys;
	always@(scratchpad) begin
		ones <= 						(scratchpad[11:8] > 4'b0100);
		tens <= 						(scratchpad[15:12] > 4'b0100);
		hundys <= 					(scratchpad[19:16] > 4'b0100);
	end
	
	
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
				if(times_shifted == 8)
					next_state <= complete;
				else
					next_state <= shift;
			
			shift:
				next_state <= check;
			
			complete:
				next_state <= start;
			
			default:
				next_state <= start;
				
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
				times_shifted <= 0;
			end
			
			check: begin
				if(ones && times_shifted < 8)
					scratchpad[11:8] <= scratchpad[11:8] + 4'b0011; // ones
				else ;
				if(tens && times_shifted < 8)
					scratchpad[15:12] <= scratchpad[15:12] + 4'b0011; // tens
				else ;
				if(hundys && times_shifted < 8)
					scratchpad[19:16] <= scratchpad[19:16] + 4'b0011; // hundreds
				else ;
			end
			
			shift: begin
				scratchpad <= scratchpad << 1;
				times_shifted <= times_shifted + 1;
			end
			
			complete: begin
				BDC <= scratchpad[19:8];
				done <= 1;
			end
			
			
			default:
				BDC <= 0000_0000_0000;
			
		endcase
	
	end




endmodule