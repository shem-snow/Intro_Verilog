module uart_receiver(
    input wire clk,
    input wire reset,
    input wire baud_tick,
    input wire rx,
    output reg [7:0] data_out,
    output reg rx_done
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
            rx_done <= 0;
        end else if (baud_tick) begin
            case (state)
                IDLE: begin
                    if (!rx) begin
                        state <= START;
                        tick_counter <= 0;
                    end
                end
                START: begin
                    if (tick_counter == 7) begin
                        state <= DATA;
                        bit_counter <= 0;
                        tick_counter <= 0;
                    end else begin
                        tick_counter <= tick_counter + 1;
                    end
                end
                DATA: begin
                    if (tick_counter == 15) begin
                        shift_reg <= {rx, shift_reg[7:1]};
                        if (bit_counter == 7) begin
                            state <= STOP;
                        end else begin
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
                        data_out <= shift_reg;
                        rx_done <= 1;
                    end else begin
                        tick_counter <= tick_counter + 1;
                    end
                end
            endcase
        end else begin
            rx_done <= 0;
        end
    end

endmodule
