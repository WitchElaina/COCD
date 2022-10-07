`timescale 1ns / 1ps

module PipelineDeliver #(
  parameter WIDTH = 1
) (
  input                     clk,
  input                     rst,
  input                     stall_current_stage,
  input                     stall_next_stage,
  input       [WIDTH - 1:0] in,
  output  reg [WIDTH - 1:0] out
);

  always @(posedge clk) begin
    if (rst) begin
      out <= 0;
    end
    else if (stall_current_stage && !stall_next_stage) begin
      out <= 0;
    end
    else if (!stall_current_stage) begin
      out <= in;
    end
  end

endmodule // PipelineDeliver
