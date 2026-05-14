module FSM_UART(
	input clk,
	input reset,
	input byte_ready,
	input transfer_byte, 
	input status_reg, 
	output reg clear_signal,
	output reg shift_signal,
	output reg start_signal,
	output reg load_shift_register
);

parameter idle = 3'b000;
parameter load = 3'b001;
parameter waiting = 3'b010;
parameter start = 3'b011;
parameter send = 3'b100;
parameter shift = 3'b101;
parameter clear = 3'b110;
parameter broken = 3'b111;


reg [2:0] current_state, next_state;

// State progression
always@(posedge clk) begin
	current_state = next_state;
end

// Next state prediction and entry point of the machine (via the reset signal).
always@(posedge clk, posedge reset) begin
	
	if(reset)
		next_state <= idle;
		
	else
		case(current_state)
		
			idle: begin
				if(byte_ready == 1)
					next_state <= load;
				else if(byte_ready == 0)
					next_state <= load;
				else // Handle the point-of-entry case when "byte_ready" is unknown.
					;
			end
			
			load: 
				next_state <= waiting;
			
			waiting: 
				next_state <= (transfer_byte)? start: waiting;
				
			start:
				next_state <= send;
			
			send:
				next_state <= (status_reg == 9)? clear: shift;
				
			shift:
				next_state <= send;
				
			clear:
				next_state <= idle;
			
			default:
				next_state <= (reset)? idle: broken; // Prevent being stuck in the broken state.
			
		endcase
end


// Output driving
always@(current_state) begin

	case(current_state)
	
		idle: begin
			clear_signal <= 1;
			shift_signal <= 0;
			start_signal <= 0;
			load_shift_register <= 0;
			
		end
		
		load: begin
			clear_signal <= 0;
			shift_signal <= 0;
			start_signal <= 0;
			load_shift_register <= 1;
		end
		
		
		waiting: begin
			clear_signal <= 0;
			shift_signal <= 0;
			start_signal <= 0;
			load_shift_register <= 0;
		
		end
		
		start: begin
			clear_signal <= 0;
			shift_signal <= 0;
			start_signal <= 1;
			load_shift_register <= 0;
		end
		
		send: begin
			clear_signal <= 0;
			shift_signal <= 0;
			start_signal <= 0;
			load_shift_register <= 0;
		end
		
		
		shift: begin
			clear_signal <= 0;
			shift_signal <= 1;
			start_signal <= 0;
			load_shift_register <= 0;
		end
		
		clear: begin
			clear_signal <= 1;
			shift_signal <= 0;
			start_signal <= 0;
			load_shift_register <= 0;
		end
		
		default: begin
			clear_signal <= 0;
			shift_signal <= 0;
			start_signal <= 0;
			load_shift_register <= 0;
		end
	endcase
end

endmodule