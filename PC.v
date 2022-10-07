`timescale 1ns / 1ps

`include "bus.v"
`include "pcdef.v"

module PC(
  input                       clk,
  input                       rst,
  // stall signal
  input                       stall_pc,
  // branch control
  input                       branch_flag,
  input       [`ADDR_BUS]     branch_addr,
  // to ID stage
  output  reg [`ADDR_BUS]     pc,
  // ROM control
  output  reg                 rom_en,
  output      [`MEM_SEL_BUS]  rom_write_en,
  output      [`ADDR_BUS]     rom_addr,
  output      [`DATA_BUS]     rom_write_data
);

  reg[`ADDR_BUS] next_pc;

  assign rom_addr = next_pc;
  assign rom_write_en = 0;
  assign rom_write_data = 0;

  // generate value of next PC
  always @(*) begin
    if (!stall_pc) begin
      if (branch_flag) begin
        next_pc <= branch_addr;
      end
      else begin
        next_pc <= pc + 4;
      end
    end
    else begin
      // pc & rom_addr stall
      next_pc <= pc;
    end
  end

  always @(posedge clk) begin
    rom_en <= !rst;
  end

  always @(posedge clk) begin
    if (!rom_en) begin
      pc <= `INIT_PC - 4;
    end
    else if (!stall_pc) begin
      pc <= next_pc;
    end
  end

endmodule // PC
