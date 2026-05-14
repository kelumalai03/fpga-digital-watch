`timescale 1ns / 1ps
module binary_to_bcd (
    input  logic [6:0] bin,
    output logic [3:0] tens,
    output logic [3:0] ones
);

  always_comb begin
    tens = 4'(bin / 7'd10);
    ones = 4'(bin % 7'd10);
  end

endmodule
