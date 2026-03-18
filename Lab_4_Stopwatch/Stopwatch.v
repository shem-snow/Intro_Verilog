module Stopwatch(
	input board_clock,
	input reset,
	input resume,
	input stop,
	output [6:0] segment_display
);


// Internal connections
wire running;
wire reference_clock;
wire [3:0] bcd;

Control cntrl(.stop(stop), .resume(resume), .reset(reset), .enable(running));
ClockDivider clkdiv(.fast_clock(board_clock), .slow_clock(reference_clock));
Counter cntr(.enable(running), .reset(reset), .clock(reference_clock), .count_in(bcd), .count_out(bcd));
BinToSevSeg sevseg(.binary_input(bcd), .segment_display(segment_display));
	
endmodule 

/*
PIN ASSIGNMENTS:

	Inputs:
		
	
	Outputs:
		seven_seg[0]	-	PIN_C14
		seven_seg[1]	-	PIN_E15
		seven_seg[2]	-	PIN_C15
		seven_seg[3]	-	PIN_C16
		seven_seg[4]	-	PIN_E16
		seven_seg[5]	-	PIN_D17
		seven_seg[6]	-	PIN_C17
*/