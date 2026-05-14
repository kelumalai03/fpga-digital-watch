`timescale 1ns / 1ps
module up_down_counter #(
    parameter int MAX   = 2,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic enable,
    input logic up,
    output logic [WIDTH-1:0] count
);

  // 1. Satisfy the linter by copying MAX into a correctly sized parameter
  localparam logic [WIDTH-1:0] Max = WIDTH'(MAX);

  // 2. Option 2 from the spec to suppress Quartus truncation warnings on +/- 1
  localparam logic [WIDTH-1:0] One = WIDTH'(1);

  logic [WIDTH-1:0] next_count;

  // 3. Explicitly sized initialization
  initial count = WIDTH'(0);

  // 4. Gate 'enable' inside the always_ff block
  always_ff @(posedge clk) begin
    if (enable) count <= next_count;
  end

  // 5. Use always_comb for the next-state logic
  always_comb begin
    // Default assignment prevents latches
    next_count = count;

    if (up) begin
      // Wrap from MAX to 0 on increment
      if (count < Max) begin
        next_count = count + One;
      end else begin
        next_count = WIDTH'(0);
      end
    end else begin
      // Wrap from 0 to MAX on decrement
      if (count > WIDTH'(0)) begin
        next_count = count - One;
      end else begin
        next_count = Max;
      end
    end
  end


endmodule
