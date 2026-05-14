`timescale 1ns / 1ps
module restartable_rate_generator #(
    parameter int CYCLE_COUNT = 2
) (
    input  logic clk,
    input  logic run,
    output logic tick
);

  generate
    if (CYCLE_COUNT > 1) begin : g_general
      localparam int CountWidth = $clog2(CYCLE_COUNT);
      logic tick_next;
      logic [CountWidth-1:0] count;
      mod_n_counter #(
          .N(CYCLE_COUNT),
          .WIDTH(CountWidth)
      ) u_counter (
          .clk(clk),
          .rst(!run),
          .enable(run),
          .count(count)
      );
      assign tick_next = run && (count == CountWidth'(CYCLE_COUNT - 2));
      always_ff @(posedge clk) begin
        if (!run) begin
          tick <= 1'b0;
        end else begin
          tick <= tick_next;
        end
      end
    end else begin : g_special
      always_ff @(posedge clk) begin
        tick <= run;
      end
    end
  endgenerate
endmodule
