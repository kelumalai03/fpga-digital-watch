`timescale 1ns / 1ps
module hms_counter #(
    parameter int N_HOURS   = 24,
    parameter int N_MINUTES = 60,
    parameter int N_SECONDS = 60,

    // Output port widths
    parameter int W_HOURS   = 5,
    parameter int W_MINUTES = 6,
    parameter int W_SECONDS = 6
) (
    input logic clk,
    input logic enable,

    // Corrected to outputs
    output logic [  W_HOURS-1:0] hours,
    output logic [W_MINUTES-1:0] minutes,
    output logic [W_SECONDS-1:0] seconds
);

  localparam logic [W_MINUTES-1:0] MaxMinutes = W_MINUTES'(N_MINUTES - 1);
  localparam logic [W_SECONDS-1:0] MaxSeconds = W_SECONDS'(N_SECONDS - 1);
  logic minute_rollover;
  logic second_rollover;

  assign second_rollover = (seconds == MaxSeconds) ? 1'b1 : 1'b0;
  assign minute_rollover = (minutes == MaxMinutes) && second_rollover ? 1'b1 : 1'b0;

  up_down_counter #(
      .MAX  (N_HOURS - 1),
      .WIDTH(W_HOURS)
  ) u_hours (
      .clk(clk),
      .enable(enable && minute_rollover),  // Increment hours on minute rollover
      .up(1'b1),  // Always count up
      .count(hours)
  );

  up_down_counter #(
      .MAX  (N_MINUTES - 1),
      .WIDTH(W_MINUTES)
  ) u_minutes (
      .clk(clk),
      .enable(enable && second_rollover),  // Increment minutes on second rollover
      .up(1'b1),  // Always count up
      .count(minutes)
  );

  up_down_counter #(
      .MAX  (N_SECONDS - 1),
      .WIDTH(W_SECONDS)
  ) u_seconds (
      .clk(clk),
      .enable(enable),
      .up(1'b1),  // Always count up
      .count(seconds)
  );


endmodule

