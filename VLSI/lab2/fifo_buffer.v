module fifo_buffer #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

    // FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
    
    // Pointers for read and write operations
    reg [$clog2(FIFO_DEPTH)-1:0] wr_ptr, rd_ptr;
    
    // Counter for number of elements in FIFO
    reg [$clog2(FIFO_DEPTH):0] count;

    // Full and empty flags
    assign full = (count == FIFO_DEPTH);
    assign empty = (count == 0);

    // Write operation
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read operation
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr <= 0;
            data_out <= 0;
        end else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Update count
    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end else begin
            case ({wr_en, rd_en})
                2'b10: count <= count + 1; // Write only
                2'b01: count <= count - 1; // Read only
                2'b11: count <= count;     // Read and write simultaneously
                default: count <= count;   // No operation
            endcase
        end
    end

endmodule
