module FSM(clock, reset, instruction);
	
	// Inputs
	input clock, reset;
	
	// Outputs
	output reg [8:0] instruction;
	
	// Variables: none. Except the output "instruction".
	
	// States
	parameter s0 = 4'b0000;
	parameter s1 = 4'b0001;
	parameter s2 = 4'b0010;
	parameter s3 = 4'b0011;
	parameter s4 = 4'b0100;
	parameter s5 = 4'b0101;
	parameter s6 = 4'b0110;
	parameter s7 = 4'b0111;
	parameter s8 = 4'b1000;
	parameter s9 = 4'b1001;
	
	reg [3:0] current_state, next_state;
	
	// Current state progression
	always@(posedge clock)
		current_state <= next_state;
	/*
		NOTE: MAKING THE FIRST TWO CONCERNS SENSITIVE TO THE NEGEDGE OF THE CLOCK DOESN'T DO ANYTHING.
		IT DOESN'T MATTER WHAT EDGE THEY'RE SENSITIVE TO.
	*/
	
	// Next state prediction
	always@(posedge clock, posedge reset) begin
		if(reset)
			next_state <= s0;
		else
			case(current_state)
				s0: next_state <= s1;
				s1: next_state <= s2;
				s2: next_state <= s3;
				s3: next_state <= s4;
				s4: next_state <= s5;
				s5: next_state <= s6;
				s6: next_state <= s7;
				s7: next_state <= s8;
				s8: next_state <= s9;
				s9: next_state <= s9;
				default: next_state <= s0; // point of entry
			endcase 
	end
	
	// Output driving
	always@(current_state) begin // x_xxx_xxx_xx: done_buffers_registers_opcode
		case(current_state)
		/*
		
		
		NOTICE THAT IF YOU EVER LEAVE FLOATING WIRES, THE WIRE WILL MESS UP YOUR CALCULATIONS!
			For example, the following code doesn't work:
		
			s0: instruction = 9'b0_000_000_11; // Set all values to zero
			s1: instruction = 9'b0_001_001_11; // Load the FPGA input into R1
			s2: instruction = 9'b0_100_010_11; // Load 4'b0011 into R2
			*s3: instruction = 9'b0_000_100_00; // Rout = R1 + R2
			s4: instruction = 9'b0_010_010_11; // R2 = Rout
			*s5: instruction = 9'b0_000_100_01; // Rout = R1 | R2
			s6: instruction = 9'b0_010_001_11; // R1 = value in Rout
			*s7: instruction = 9'b0_000_100_11; // Rout = ~R1
			s8: instruction = 9'b0_010_001_11; // R1 = value in Rout
			s9: instruction = 9'b1_010_100_10; // Rout = R1 ^ R2
			default: instruction = 9'b0_000_000_11;
		*/
		
		///* CORRECT IMPLEMENTATION:
		// 						   x_xxx_xxx_xx: done_buffers_registers_opcode
			s0: instruction = 9'b0_000_000_00; // Set all values to zero
			s1: instruction = 9'b0_001_001_00; // Load the FPGA input into R1
			s2: instruction = 9'b0_100_010_00; // Load 4'b0011 into R2
			s3: instruction = 9'b0_010_100_00; // Rout = R1 + R2
			s4: instruction = 9'b0_010_010_00; // R2 = Rout
			s5: instruction = 9'b0_010_100_01; // Rout = R1 | R2
			s6: instruction = 9'b0_010_001_01; // R1 = value in Rout
			s7: instruction = 9'b0_010_100_11; // Rout = ~R1
			s8: instruction = 9'b0_010_001_11; // R1 = value in Rout
			s9: instruction = 9'b1_010_100_10; // Rout = R1 ^ R2
			default: instruction = 9'b0_000_000_10; // point of entry
		//*/
		
		/*
			TEST TO SEE IF I HAVE TO SET THE ALU OPERATION EARLY.
			This version defaults to NOT
			
			CONCLUSION: YES, IT DOES MAKE A DIFFERENCE.
			
			
			s0: instruction = 9'b0_000_000_11; // Set all values to zero
			s1: instruction = 9'b0_001_001_11; // Load the FPGA input into R1
			s2: instruction = 9'b0_100_010_11; // Load 4'b0011 into R2
			s3: instruction = 9'b0_010_100_00; // Rout = R1 + R2
			s4: instruction = 9'b0_010_010_11; // R2 = Rout
			s5: instruction = 9'b0_010_100_01; // Rout = R1 | R2
			s6: instruction = 9'b0_010_001_11; // R1 = value in Rout
			s7: instruction = 9'b0_010_100_11; // Rout = ~R1
			s8: instruction = 9'b0_010_001_11; // R1 = value in Rout
			s9: instruction = 9'b1_010_100_10; // Rout = R1 ^ R2
			default: instruction = 9'b0_000_000_11; // point of entry
		*/
		
		endcase
	end
	
endmodule 