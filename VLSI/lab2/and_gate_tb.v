`timescale 1ns / 1ps

module and_gate_tb;

    // Inputs
    reg a;
    reg b;

    // Output
    wire y;

    // Instantiate the Unit Under Test (UUT)
    and_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Stimulus
    initial begin
        // Initialize inputs
        a = 0;
        b = 0;

        // Wait for 100 ns for global reset to finish
        #100;

        // Test all input combinations
        #10 a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;

        // Wait for another 100 ns and finish simulation
        #100 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %0t, a = %b, b = %b, y = %b", $time, a, b, y);
    end

endmodule 