`timescale 1ns / 1ps
module mod_n_counter #(
    parameter int N = 4,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic rst,
    input logic enable,
    output logic [WIDTH-1:0] count
);

  initial count = WIDTH'(0);
  always_ff @(posedge clk) begin
    if (rst) count <= WIDTH'(0);
    else if (enable) count <= (count == WIDTH'(N - 1)) ? WIDTH'(0) : count + WIDTH'(1);
  end

endmodule
