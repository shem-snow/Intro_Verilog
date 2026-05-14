module baud_rate_generator #(
    parameter CLOCK_RATE = 50000000,  // 50 MHz clock
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    output reg baud_tick
);

    localparam integer DIVIDER = CLOCK_RATE / (16 * BAUD_RATE);
    reg [15:0] counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            baud_tick <= 0;
        end else begin
            if (counter == DIVIDER - 1) begin
                counter <= 0;
                baud_tick <= 1;
            end else begin
                counter <= counter + 1;
                baud_tick <= 0;
            end
        end
    end
endmodule