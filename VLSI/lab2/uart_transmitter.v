module uart_transmitter(
    input wire clk,
    input wire reset,
    input wire baud_tick,
    input wire [7:0] data_in,
    input wire tx_start,
    output reg tx,
    output reg tx_done
);

    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    reg [1:0] state = IDLE;
    reg [2:0] bit_counter = 0;
    reg [3:0] tick_counter = 0;
    reg [7:0] shift_reg = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1;
            tx_done <= 0;
        end else if (baud_tick) begin
            case (state)
                IDLE: begin
                    if (tx_start) begin
                        state <= START;
                        shift_reg <= data_in;
                        tick_counter <= 0;
                        tx_done <= 0;
                    end
                end
                START: begin
                    if (tick_counter == 15) begin
                        state <= DATA;
                        tx <= shift_reg[0];
                        shift_reg <= {1'b0, shift_reg[7:1]};
                        bit_counter <= 0;
                        tick_counter <= 0;
                    end else begin
                        tx <= 0;
                        tick_counter <= tick_counter + 1;
                    end
                end
                DATA: begin
                    if (tick_counter == 15) begin
                        if (bit_counter == 7) begin
                            state <= STOP;
                        end else begin
                            tx <= shift_reg[0];
                            shift_reg <= {1'b0, shift_reg[7:1]};
                            bit_counter <= bit_counter + 1;
                        end
                        tick_counter <= 0;
                    end else begin
                        tick_counter <= tick_counter + 1;
                    end
                end
                STOP: begin
                    if (tick_counter == 15) begin
                        state <= IDLE;
                        tx <= 1;
                        tx_done <= 1;
                    end else begin
                        tx <= 1;
                        tick_counter <= tick_counter + 1;
                    end
                end
            endcase
        end
    end

endmodule
