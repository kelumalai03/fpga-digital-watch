module user_top_timerb_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
`ifdef FORMAL
    output logic probe_running,
    output logic [2:0] probe_mode_enable,
`endif
    input logic clk
);

`ifdef FORMAL
  assign probe_running = running;
  assign probe_mode_enable = mode_enable;
`endif

endmodule
