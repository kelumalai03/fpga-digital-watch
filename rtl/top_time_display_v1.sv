`timescale 1ns / 1ps
module top_time_display_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic CLOCK_50,
    input logic [1:0] SW,
    output logic [6:0] HEX5,
    output logic [6:0] HEX4,
    output logic [6:0] HEX3,
    output logic [6:0] HEX2,
    output logic [6:0] HEX1,
    output logic [6:0] HEX0
);

  logic [4:0] hours;
  logic [5:0] minutes;
  logic [5:0] seconds;
  logic [3:0] h_tens, h_ones, m_tens, m_ones, s_tens, s_ones;
  logic tick_1hz, tick_25hz, tick_1khz;
  logic tick;

  hms_counter #(
      .N_HOURS  (24),
      .N_MINUTES(60),
      .N_SECONDS(60),
      .W_HOURS  (5),
      .W_MINUTES(6),
      .W_SECONDS(6)
  ) u_hms_counter (
      .clk(CLOCK_50),
      .enable(tick),
      .hours(hours),
      .minutes(minutes),
      .seconds(seconds)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND)
  ) u_divider_1hz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_1hz)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 25)
  ) u_divider_25hz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_25hz)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 1000)
  ) u_divider_1khz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_1khz)
  );

  always_comb begin
    unique case (SW)
      2'b00: tick = tick_1hz;
      2'b01: tick = tick_25hz;
      2'b10: tick = tick_1khz;
      2'b11: tick = 1'b1;
    endcase
  end

  binary_to_bcd u_binary_to_bcd_hours (
      .bin ({2'b0, hours}),
      .tens(h_tens),
      .ones(h_ones)
  );

  binary_to_bcd u_binary_to_bcd_minutes (
      .bin ({1'b0, minutes}),
      .tens(m_tens),
      .ones(m_ones)
  );

  binary_to_bcd u_binary_to_bcd_seconds (
      .bin ({1'b0, seconds}),
      .tens(s_tens),
      .ones(s_ones)
  );

  seven_segment #(
      .ACTIVE_LOW(1)
  ) u_seven_segment_htens (
      .digit(h_tens),
      .blank(1'b0),
      .segments(HEX5)
  );

  seven_segment #(
      .ACTIVE_LOW(1)
  ) u_seven_segment_hones (
      .digit(h_ones),
      .blank(1'b0),
      .segments(HEX4)
  );

  seven_segment #(
      .ACTIVE_LOW(1)
  ) u_seven_segment_mtens (
      .digit(m_tens),
      .blank(1'b0),
      .segments(HEX3)
  );

  seven_segment #(
      .ACTIVE_LOW(1)
  ) u_seven_segment_mones (
      .digit(m_ones),
      .blank(1'b0),
      .segments(HEX2)
  );

  seven_segment #(
      .ACTIVE_LOW(1)
  ) u_seven_segment_stens (
      .digit(s_tens),
      .blank(1'b0),
      .segments(HEX1)
  );

  seven_segment #(
      .ACTIVE_LOW(1)
  ) u_seven_segment_sones (
      .digit(s_ones),
      .blank(1'b0),
      .segments(HEX0)
  );

endmodule
