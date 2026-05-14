/*
	- Data register holds the original data
	- Shift register shifts the output data serially
	- Status register counte the number of transmitted bits
	- State machine controlls the operation of the circuit (load, clear, shift, remember.
		- after 10 bits are transmitted, the status register is cleared. THe first is start and the last is stop. So messages have 8 bits of content.
		- The output of the transmitter willl be the LSB of the shift register.
*/
module UART(
	input [7:0] data_bus,
	input byte_ready,
	input load_data_reg,
	input t_byte,
	input clock,
	input reset, // Point of entry control signal for the FSM.
	input xmt,
	output reg serial_output,
	output reg shifty
);

// Declar internal wires and registers.
wire [3:0] internal; // load_shift_register[3], start[2], shift[1], clear[0]
reg [9:0] shift_reg; // 10 bits because the first and last bits are start and stop. The middle 8 are the ASCII message.
reg [7:0] data_reg;
reg [3:0] status_reg; // holds the bit count

// FSM instantiation
FSM_UART fsm(.clk(clock), .reset(reset), .byte_ready(byte_ready), .transfer_byte(t_byte), .status_reg(status_reg), .clear_signal(internal[0]), .shift_signal(internal[1]), .start_signal(internal[2]), .load_shift_register(internal[3]) );


always@(internal[1])
	shifty <= internal[1];

// Status register
// Note: The sensitivity items (clear and shift) are one-hot encoded and the clock is not needed here.
always@(posedge internal[1], posedge internal[0], posedge reset) begin
	if(internal[0] | reset)
		status_reg <= 4'b0000;
	else // shift
		status_reg <= status_reg + 1;
end


// Shift register
// note: The sensitivity items are one-hot encoded in the FSM so there is will not be overlapping cases.
always@(posedge internal[3], posedge reset, posedge internal[2], posedge internal[1]) begin
	
	if(reset) begin
		serial_output = 1'b1;
		shift_reg[0] <= 1'b0; // start bit
		shift_reg[9] <= 1'b1; // stop bit
		shift_reg[8:1] <= 8'b0000_0000; // message
	end
	
	else if(internal[3]) begin // load_shift_register
				serial_output = 1'b1;
				shift_reg[0] = 1'b0; // start bit
				shift_reg[9] = 1'b1; // stop bit
				shift_reg[8:1] = data_reg; // message
				shift_reg = shift_reg | 10'b10_0000_0000;
	end
	
	else if(internal[2])  begin // start
				serial_output = 1'b0;
				shift_reg = (shift_reg >> 1);
				shift_reg = shift_reg | 10'b10_0000_0000;
	end
		
	else if(internal[1]) begin // shift
				serial_output = shift_reg[0];
				shift_reg = (shift_reg >> 1);
				shift_reg = shift_reg | 10'b10_0000_0000;
	end
	
	else
		; // inferred latch
			
end



// Data register
always@(posedge xmt)
	data_reg <= data_bus;


endmodule