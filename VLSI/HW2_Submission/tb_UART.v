module tb_UART;

// inputs
reg [7:0] data_bus;
reg byte_ready, t_byte, clock, reset, xmt;

// outputs
wire serial_output, shift;

UART uut(.data_bus(data_bus), .byte_ready(byte_ready), .t_byte(t_byte), .clock(clock), .reset(reset), .xmt(xmt), .serial_output(serial_output), .shifty(shift));

// Display and control variables
reg [7:0] message;
integer position;
integer loop_count;
reg started;

// Clock generation
initial begin
	clock = 0;
	forever #5 clock = ~clock;
end

// Shift counter to ensure all the messages got sent.
always@(posedge shift) begin
	
	if(reset) // Don't reset the message when we're waiting for reset to go inactive.
		;
	else begin
		// Every time a shift occurs, save the current serial output.
		// Every time except the first time because my machine is imperfect.
		if(started) begin 
			message[position] = serial_output;
			position = position + 1;
		end
		else
			started = 1;
	end
end


initial begin
	position = 0;
	
	// Run through all the test cases
	for(loop_count = 0; loop_count < 256; loop_count = loop_count + 1) begin
		started = 0;
		
		data_bus = 8'b00000000;
		xmt = 0;
		reset = 0;
		byte_ready = 0;
		t_byte = 0;
		repeat(1)@(posedge clock);

		//data_bus = 8'b10111010;
		data_bus = loop_count;
		xmt = 0;
		reset = 0;
		byte_ready = 0;
		t_byte = 0;
		repeat(1)@(posedge clock);
	
		xmt = 1;
		repeat(1)@(posedge clock);
		xmt = 0;
		reset = 1;
		repeat(1)@(posedge clock);
		reset = 0;
		byte_ready = 1;
		repeat(1)@(posedge clock);
		t_byte = 1;
		repeat(1)@(posedge clock);
	
		repeat(8)@(posedge shift); // Allow the current message to finish completely. 
	
		$display("Putting %b in the shift register causes serial output of %b", data_bus, message);
		repeat(1)@(posedge clock);
		message = 0;
		position = 0;
	end

end



endmodule

