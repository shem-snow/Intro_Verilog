module uart_with_fifo (
    input wire clk,
    input wire reset,
    input wire rx,
    output wire tx,
    input wire [7:0] tx_data,
    input wire tx_start,
    output wire tx_done,
    output wire [7:0] rx_data,
    output wire rx_done,
    output wire tx_fifo_full,
    output wire rx_fifo_empty
);

    // Internal signals
    wire baud_tick;
    wire [7:0] rx_fifo_out, tx_fifo_out;
    wire rx_fifo_wr_en, tx_fifo_rd_en;

    // Baud rate generator
    baud_rate_generator baud_gen(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );

    // UART transmitter
    uart_transmitter tx_module(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .data_in(tx_fifo_out),
        .tx_start(~tx_fifo_empty),
        .tx(tx),
        .tx_done(tx_fifo_rd_en)
    );

    // UART receiver
    uart_receiver rx_module(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .rx(rx),
        .data_out(rx_data),
        .rx_done(rx_fifo_wr_en)
    );

    // TX FIFO
    fifo_buffer #(
        .DATA_WIDTH(8),
        .FIFO_DEPTH(16)
    ) tx_fifo (
        .clk(clk),
        .rst(reset),
        .wr_en(tx_start),
        .rd_en(tx_fifo_rd_en),
        .data_in(tx_data),
        .data_out(tx_fifo_out),
        .full(tx_fifo_full),
        .empty(tx_fifo_empty)
    );

    // RX FIFO
    fifo_buffer #(
        .DATA_WIDTH(8),
        .FIFO_DEPTH(16)
    ) rx_fifo (
        .clk(clk),
        .rst(reset),
        .wr_en(rx_fifo_wr_en),
        .rd_en(rx_done),
        .data_in(rx_data),
        .data_out(rx_fifo_out),
        .full(),
        .empty(rx_fifo_empty)
    );

    // assign rx_data = rx_fifo_out; I commented this out because it's a duplicate assignment.

endmodule
