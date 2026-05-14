	/* 
		Lesson learned: if you have to keep adding flags to cover cases, you should probably re-design your FSM.
			
	*/
	module old_code(
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
	reg need_shift; // Sometimes the complete state is entered (instead of the shift state) before the final shift is completed. This flag indicates that situation so the shift state can be entered again before completing.
	reg must_shift; // sometimes the 'final' shift did complete but a final check-and-add causes another shift to be required. The real final shift. This flag indicates that.
	reg done_shifting; // Stoppes the double_dabble scenario from repeating forever.
	reg need_check; // Sometimes the complete state is entered when another add is needed
	reg evaluated; // Indicates the algorithm is complete. However, directly changes the "done" output will cause the waiting testbench to print early. So this flag is used to know when to transition to the complete state.
	reg double_dabble; // Whenever the algorithm shifts left, another check for items > 4 must be completed. Sometimes this requires a state to perform its tasks twice sequentially which presents a problem for always blocks that are sensitive to CHANGES. This flag indicates the situation. The always blocks should be sensitive to it. I made one posedge and the other negedge to ensure state work is done before state prediction.
	
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
				if(scratchpad[7:0] == 0 && evaluated) // TODO: being entered and entering the complete state when it should enter check.
					if(need_shift && !must_shift && !done_shifting) begin // This indicates the double_dabble scenario. Check this condition first because multiple may be true.
						double_dabble <= 1; 
						next_state <= shift; // TODO: I only want to double dabble once. To stop it from happening repeatedly, I check done_shifting.
					end
					else if(done_shifting)
						next_state <= complete;
					else
						next_state <= shift;
						
				else
					next_state <= shift;
			
			shift: begin
				next_state <= check;
				double_dabble <= 0; // TODO: "shift" will occur after "check" every time there is a double_dabble so the flag reset is performed here.
			end
			
			complete:
				if(need_shift)
					next_state <= shift;
				else if(scratchpad[7:0] == 0 && evaluated)
					next_state <= start;
				else
					next_state <= complete;
			
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
				done <= 0;
				evaluated <= 0;
				BDC <= 12'b0000_0000_0000;
				need_shift <= 0;
				must_shift <= 0;
				need_check <= 0;
				done_shifting <= 0;
			end
			
			check: begin
				// Indicates this is a sequential "check" and therefore the next state should be "shift".
				if(double_dabble)
					must_shift <= 1;
				else
					must_shift <= 0;
			
				if(scratchpad[11:8] > 4'b0100) begin
					need_shift <= 1;
					scratchpad[11:8] <= scratchpad[11:8] + 4'b0011; // ones
					if(scratchpad[14:11] > 4'b0100) begin
						scratchpad <= scratchpad << 1;
						scratchpad[15:12] <= scratchpad[15:12] + 4'b0011; // tens
						if(scratchpad[18:15] > 4'b0100) begin
							scratchpad <= scratchpad << 1;
							scratchpad[19:16] <= scratchpad[19:16] + 4'b0011; // hundreds
						end
					end
				end
				else if(scratchpad[15:12] > 4'b0100) begin
					need_shift <= 1;
					scratchpad[15:12] <= scratchpad[15:12] + 4'b0011; // tens
					if(scratchpad[18:15] > 4'b0100) begin
						scratchpad <= scratchpad << 1;
							scratchpad[19:16] <= scratchpad[19:16] + 4'b0011; // hundreds
					end
				end
				else if(scratchpad[19:16] > 4'b0100) begin
					need_shift <= 1;
					scratchpad[19:16] <= scratchpad[19:16] + 4'b0011; // hundreds
				end
				else
					need_shift <= 0;
				
				if(scratchpad[7:0] == 0)
					evaluated <= 1;
			end
			
			shift: begin
				if(double_dabble)
					;
				else begin
					scratchpad <= scratchpad << 1;
					done_shifting <= 1;
				end
			end
			
			complete: begin
				if(need_shift)
					; // do nothing. The shift state will be entered.
				else begin
				
				
					
				
					BDC <= scratchpad[19:8];
					done <= 1;
				end
			end
				
			default:
				BDC <= 0000_0000_0000;
			
		endcase
	
	end




endmodule