`timescale 1ns / 1ps

module uart_with_fifo_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 100 MHz clock
    parameter BAUD_RATE = 9600;
    parameter CLKS_PER_BIT = 100000000 / BAUD_RATE;

    // Signals
    reg clk;
    reg reset;
    reg rx;
    wire tx;
    
    reg tx_start;
    wire tx_done;
    
    wire rx_done;
    wire tx_fifo_full;
    wire rx_fifo_empty;
	 
	 // old
	 //reg [7:0] tx_data;
	 //wire [7:0] rx_data;
	 
	 wire [7:0] tx_data;
	 reg [7:0] rx_data;
	 
	 
	 integer i;
	 integer j;

    // Instantiate the Unit Under Test (UUT)
    uart_with_fifo uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_done(tx_done),
        .rx_data(tx_data),
        .rx_done(rx_done),
        .tx_fifo_full(tx_fifo_full),
        .rx_fifo_empty(rx_fifo_empty)
    );

    // Clock generation
    always begin
        #(CLK_PERIOD/2) clk = ~clk;
    end

    // Task to send a byte
    task send_byte;
        input [7:0] data;
        begin
            // Start bit
            rx = 0;
            #(CLKS_PER_BIT * CLK_PERIOD);

            // Data bits
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(CLKS_PER_BIT * CLK_PERIOD);
            end

            // Stop bit
            rx = 1;
            #(CLKS_PER_BIT * CLK_PERIOD);
        end
    endtask

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        rx = 1;
        tx_data = 8'h00;
        tx_start = 0;

        // Reset the system
        #(CLK_PERIOD * 10);
        reset = 0;
        #(CLK_PERIOD * 10);

        // Test 1: Send data through TX FIFO
        $display("Test 1: Sending data through TX FIFO");
        for (i = 0; i < 20; i = i + 1) begin
            tx_data = i;
            tx_start = 1;
            #CLK_PERIOD;
            tx_start = 0;
            #(CLK_PERIOD * 10);
        end

        // Wait for all data to be transmitted
        while (!tx_fifo_full) #CLK_PERIOD;

        // Test 2: Receive data through RX
        $display("Test 2: Receiving data through RX");
		  
        for (j = 0; j < 20; j = j + 1) begin
            send_byte(j);
        end

        // Wait for all data to be received
        while (rx_fifo_empty) #CLK_PERIOD;

        // Test 3: Verify TX FIFO full condition
        $display("Test 3: Verifying TX FIFO full condition");
        while (!tx_fifo_full) begin
            tx_data = $random;
            tx_start = 1;
            #CLK_PERIOD;
            tx_start = 0;
            #(CLK_PERIOD * 10);
        end

        // Test 4: Verify RX FIFO empty condition
        $display("Test 4: Verifying RX FIFO empty condition");
        while (!rx_fifo_empty) begin
            @(posedge rx_done);
            $display("Received data: %h", tx_data);
        end

        // End simulation
        #(CLK_PERIOD * 1000);
        $display("Simulation completed");
        $finish;
    end

    // Monitor TX
    always @(posedge clk) begin
        if (tx_done) begin
            $display("Transmitted data: %h", tx_data);
        end
    end

    // Monitor RX
    always @(posedge clk) begin
        if (rx_done) begin
            $display("Received data: %h", tx_data);
        end
    end

endmodule
