module Old_FSM(clock, reset, instruction);
	
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
	always@(negedge clock, posedge reset)
		if(reset)
			current_state = s0;
		else
			current_state = next_state;
	
	// Output driving
	always@(current_state) begin // x_xxx_xxx_xx: done_buffers_registers_opcode
		case(current_state)
			
			s0: begin
				instruction = 9'b0_000_000_00; // Set all values to zero
				next_state = s1;
			end
			
			s1: begin
				instruction = 9'b0_001_001_00; // Load the FPGA input into R1
				next_state = s2;
			end
			
			s2: begin
				instruction = 9'b0_100_010_00; // Load 4'b0011 into R2
				next_state = s3;
			end
			
			s3: begin
				instruction = 9'b0_010_100_00; // Rout = R1 + R2
				next_state = s4;
			end
			
			s4: begin
				instruction = 9'b0_010_010_00; // R2 = Rout
				next_state = s5;
			end
			
			s5: begin
				instruction = 9'b0_010_100_01; // Rout = R1 | R2
				next_state = s6;
			end
			
			s6: begin
				instruction = 9'b0_010_001_01; // R1 = value in Rout
				next_state = s7;
			end
			
			s7: begin
				instruction = 9'b0_010_100_11; // Rout = ~R1
				next_state = s8;
			end
			
			s8: begin
				instruction = 9'b0_010_001_11; // R1 = value in Rout
				next_state = s9;
			end
			
			s9: begin
				instruction = 9'b1_010_100_10; // Rout = R1 ^ R2
				next_state = s9;
			end
			
			default: begin
				instruction = 9'b0_000_000_10;
				next_state = s0; // point of entry
			end
			
		endcase
	end
	
endmodule 