module BUS_MUX(
	input [2:0] control,
	input [3:0] switches,
	input [3:0] rout,
	output reg [3:0] the_BUS
);
always@(control[2:0]) begin
		case(control[2:0])
			3'b001:
				the_BUS = switches;
			3'b010:
				the_BUS = rout;
			3'b100:
				the_BUS = 4'b0011;
			default:
				the_BUS = 4'bzzzz;
		endcase
	end
endmodule