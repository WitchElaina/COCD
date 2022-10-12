`ifndef TINYMIPS_SEGPOS_V_
`define TINYMIPS_SEGPOS_V_

// opcode
`define SEG_OPCODE   31:26

// register segment
`define SEG_RS       25:21
`define SEG_RT       20:16
`define SEG_RD       15:11

// immediate or offset
`define SEG_IMM      15:0
`define SEG_OFFSET   15:0

// shamt
`define SEG_SHAMT    10:6

// funct
`define SEG_FUNCT    5:0

`endif  // TINYMIPS_SEGPOS_V_
