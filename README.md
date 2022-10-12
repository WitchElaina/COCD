# USTB Computer Organization Course Design

`extend`

## Extend Insturction On CDE

| 序号 | 指令名称 | 指令分值 | 指令分组             | 实现|
| :--- | :------- | :------- | -------------------- | --- |
| 1    | ADD      | 2        | R型运算指令/加法指令 | 0|
| 2    | SUB      | 2        | R型运算指令          | 0|
| 3    | NOR      | 2        | R型运算指令          | 0|
| 4    | ADDI     | 2        | I型运算指令/加法指令 | 0|
| 5    | ANDI     | 2        | I型运算指令          | x|
| 6    | ORI      | 2        | I型运算指令          | x|
| 7    | XORI     | 2        | I型运算指令          | x|
| 8    | SLTI     | 2        | I型运算指令          | x|
| 9    | SLTIU    | 2        | I型运算指令          | x|
| 10   | SRL      | 2        | Shamt移位指令        | x|
| 11   | SRA      | 2        | Shamt移位指令        | x|
| 12   | J        | 2        | 直接跳转指令         | x|
| 13   | JR       | 3        | 直接跳转指令         | 0|
| 14   | LH       | 3        | 内存载入指令         | x|
| 15   | LHU      | 3        | 内存载入指令         | x|
| 16   | SH       | 3        | 内存存储指令         | x|
| 17   | BGEZ     | 3        | 条件分支指令/BGE跳转 | x|
| 18   | BGTZ     | 3        | 条件分支指令         | x|
| 19   | BLEZ     | 3        | 条件分支指令         | x|
| 20   | BLTZ     | 3        | 条件分支指令/BLT跳转 | x|
| 21   | BGEZAL   | 3        | 条件分支指令/BGE跳转 | x|
| 22   | BLTZAL   | 3        | 条件分支指令/BLT跳转 | x|


> x - Not Extended, 0 - Developing, 1 - Complete

Total Score: 0/10


## R-type

### ADD, SUB, NOR

首先在`funct.v`中按照tinyMIPS规定添加对应的语句的低六位`funct`值

```verilog
// Extend
// ADD
// SUB
// NOR
`define FUNCT_ADD 6'b100000
`define FUNCT_SUB 6'b100010
`define FUNCT_NOR 6'b100111
```

随后在`EX.v`中加入对应的语句完成执行

```verilog
// calculate result
  always @(*) begin
    case (funct)
      // ...
      // extends
      `FUNCT_ADD: result <= operand_1 + operand_2;
      `FUNCT_SUB: result <= operand_1 - operand_2;
      `FUNCT_NOR: result <= ~(operand_1 | operand_2);
      default: result <= 0;
    endcase
  end
```

### JR

TODO


## I-type

### ADDI

I-type指令有op字段，首先修改`opcode.v`添加对应的字段定义

```verilog
// extends
`define OP_ADDI       6'b001000
```

随后在`RegGen.v`中生成寄存器读写控制信号

```verilog
// TODO
```

在`OperandGen.v`中完成操作数的取出

```verilog
// TODO
```


