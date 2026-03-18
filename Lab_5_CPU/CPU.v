module CPU(
	input clock,
	input reset,
	input [3:0] FPGA_switches,
	output [6:0] segment_display,
	output done // for testing
);
	// Internal connections
	wire [8:0] control_signals;
	wire [3:0] MAIN_BUS, ALU_A, ALU_B, ALU_result, saved_result;

	// Instantiate each submodule
	FSM fsm(.clock(clock), .reset(reset), .instruction(control_signals));
	assign done = control_signals[8];

	EdgeTriggeredRegister R1(.clock(clock), .enable(control_signals[2]), .D_in(MAIN_BUS), .reset(reset), .Q_out(ALU_A));
	EdgeTriggeredRegister R2(.clock(clock), .enable(control_signals[3]), .D_in(MAIN_BUS), .reset(reset), .Q_out(ALU_B));
	EdgeTriggeredRegister Rout(.clock(clock), .enable(control_signals[4]), .D_in(ALU_result), .reset(reset), .Q_out(saved_result));

	/*
	
	I HAVE TESTED USING EVENT TRIGGERED REGISTERS INSTEAD OF CLOCK SENSITIVE ONES. IT DOESN'T WORK.
	
		EventTriggeredRegister R1(.enable(control_signals[2]), .D_in(MAIN_BUS), .reset(reset), .Q_out(ALU_A));
		EventTriggeredRegister R2(.enable(control_signals[3]), .D_in(MAIN_BUS), .reset(reset), .Q_out(ALU_B));
		EventTriggeredRegister Rout(.enable(control_signals[4]), .D_in(ALU_result), .reset(reset), .Q_out(saved_result));
		
	I HAVE ALSO TRIED LEVEL SENSITIVE REGISTERS. THEY ALSO DON'T WORK.
	
		LevelSensitiveRegister R1(.enable(control_signals[2]), .D_in(MAIN_BUS), .reset(reset), .Q_out(ALU_A));
		LevelSensitiveRegister R2(.enable(control_signals[3]), .D_in(MAIN_BUS), .reset(reset), .Q_out(ALU_B));
		LevelSensitiveRegister Rout(.enable(control_signals[4]), .D_in(ALU_result), .reset(reset), .Q_out(saved_result));
	*/
	
	ALU alu(.A(ALU_A), .B(ALU_B), .result(ALU_result), .opcode(control_signals[1:0]));
	
	Buffer fpga_switches(.enable(control_signals[5]), .in(FPGA_switches), .out(MAIN_BUS));
	Buffer writeback(.enable(control_signals[6]), .in(saved_result), .out(MAIN_BUS));
	Buffer immediate_three(.enable(control_signals[7]), .in(4'b0011), .out(MAIN_BUS));
	// BUS_MUX mux(.control(control_signals[]), .switches(FPGA_switches), .rout(saved_result), .the_BUS(MAIN_BUS));
	
	SevSegDisplay display(.hex_input(saved_result), .segment_display(segment_display));
	
endmodule 