module Lock(password, clock, enter, reset, lock, warning, alarm);

// inputs
input wire [3:0] password;
input wire clock;
input wire enter;
input wire reset;

// outputs
output reg lock;
output reg warning;
output reg alarm;

// variables
wire correct_password;
assign correct_password = (password == 4'b0110); // Functional code used to determine if the currently entered password is correct.

wire true_reset;
not(true_reset, reset); // Structural code to convert the active-low reset into an active high 'true reset' variable. 

// states
parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;
parameter s3 = 2'b11;


// ________________________________ The Finite state machine: ________________________________


reg [1:0] current_state, next_state;


// State progression
always@(posedge clock)
	current_state = next_state;
	
// Next state prediction
always@(posedge enter, posedge true_reset) begin

	if(true_reset)
		next_state <= s0; // Point of entry into the machine
	else
		case(current_state)
			s0:
				next_state <= (correct_password)? s0: s1;
			s1:
				next_state <= (correct_password)? s0: s2;
			s2:
				next_state <= (correct_password)? s0: s3;
			s3: 
				next_state <= s3;		
			default: 
				next_state <= s3;
		endcase
end


// Output driving
always@(current_state) begin

	case(current_state)
		s0: begin
			lock = correct_password? 0 : 1;
			warning = 0;
			alarm = 0;
		end

		s1: begin
			lock = 1;
			warning = 0;
			alarm = 0;
		end
		
		s2: begin
			lock = 1;
			warning = 1;
			alarm = 0;
		end
		
		s3: begin
			lock = 1;
			warning = 0;
			alarm = 1;
		end
			
		default: begin
			lock = 1;
			warning = 1;
			alarm = 1;
		end
	endcase
			
end


endmodule 