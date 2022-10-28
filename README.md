# USTB Computer Organization Course Design

`extend`

## 搭建环境

主流教程推荐使用虚拟机/WSL进行交叉编译，使用Windows下的Vivado进行仿真，可以，但。。如果你和我一样使用**macOS**或者Linux，该怎么办呢？我肯定不推荐装一个Ubuntu虚拟机交叉编译再装一个Windows虚拟机跑Vivado，一点也不优雅，如果你有类似需求请看下文，使用docker搭建整个实验环境，一个词，**优雅**！

### 安装Vivado

参考我的这篇博文

> 教程地址：[如何在mac上优雅地使用Vivado](https://witchelaina.github.io/posts/vivado_on_mac/)

### 配置交叉编译环境

按上述教程安装好vivado之后，进入docker容器，这时你得到了一个能运行vivado的类WSL或mSL(macOS Sub Linux)，接下来的步骤和实验指导书中在WSL的操作没有任何区别，把gcc拖到共享文件夹里就行。

> 如果你还不会，提issue，有其他macOS上跑USTB实验的需求也可以提，可以帮你优雅地解决（尽量）


## Info

| 序号 | 指令名称 | 指令分值 | 指令分组             | 实现|
| :--- | :------- | :------- | -------------------- | --- |
| 1    | ADD      | 2        | R型运算指令/加法指令 | 1|
| 2    | SUB      | 2        | R型运算指令          | 1|
| 3    | NOR      | 2        | R型运算指令          | 1|
| 4    | ADDI     | 2        | I型运算指令/加法指令 | 1|
| 5    | ANDI     | 2        | I型运算指令          | 1|
| 6    | ORI      | 2        | I型运算指令          | 1|
| 7    | XORI     | 2        | I型运算指令          | x|
| 8    | SLTI     | 2        | I型运算指令          | x|
| 9    | SLTIU    | 2        | I型运算指令          | x|
| 10   | SRL      | 2        | Shamt移位指令        | x|
| 11   | SRA      | 2        | Shamt移位指令        | x|
| 12   | J        | 2        | 直接跳转指令         | x|
| 13   | JR       | 3        | 直接跳转指令         | 1|
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

Total Score: 10/10


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

与上一部分的三个R指令类似，首先在`funct.v`中按照tinyMIPS规定添加对应的语句的低六位`funct`值

```verilog
// JR
`define FUNCT_JR 6'b001000
```

随后在`BranchGen.v`中修改跳转的case语句中的`OP_SPECIAL`分支

```verilog
    case (op)
      `OP_SPECIAL: begin
        if (funct == `FUNCT_JALR || funct == `FUNCT_JR) begin
          branch_flag <= 1;
          branch_addr <= reg_data_1;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
    // ...
    endcase

```


## I-type

### ADDI, ANDI, ORI

I-type指令有op字段，首先修改`opcode.v`添加对应的字段定义

```verilog
// extends
`define OP_ADDI       6'b001000
`define OP_ANDI       6'b001100
`define OP_ORI        6'b001101
```

随后在`RegGen.v`中生成寄存器读写控制信号

以上三条I型指令需读取的操作数都在rs寄存器中，要写入结果的寄存器都为rt，因此需要设置对应的read_enable和write_enable，具体如下

```verilog
 // generate read address
  always @(*) begin
    case (op)
      // extends
      `OP_ADDI, `OP_ANDI, `OP_ORI:
      begin
        reg_read_en_1 <= 1;
        reg_read_en_2 <= 0;
        reg_addr_1 <= rs;
        reg_addr_2 <= 0;
      end
    // ...   
    endcase
  end

  // generate write address
  always @(*) begin
    case (op)
      // extends
      `OP_ADDI, `OP_ANDI, `OP_ORI:
      begin
        reg_write_en <= 1;
        reg_write_addr <= rt;
      end
      // ...
    endcase
  end
```


在`OperandGen.v`中完成操作数的取出

ADDI指令需要对立即数进行符号扩展，原始CPU代码中已经包含，此处只需要编写高位0扩展的代码即可

```verilog
  wire[`DATA_BUS] zero_ext_imm_lo = {16'b0, imm};
```

完成后正常编写取出操作数的代码即可

```verilog
  // generate operand_1
  always @(*) begin
    case (op)
      // extends
      `OP_ADDI,`OP_ANDI,`OP_ORI:
      begin
        operand_1 <= reg_data_1;
      end
      // ...
    endcase
  end

  // generate operand_2
  always @(*) begin
    case (op)
      // extends
      `OP_ANDI, `OP_ORI:
      begin
        operand_2 <= zero_ext_imm_lo;
      end
      
      // extends
      `OP_ADDI:
      begin
        operand_2 <= sign_ext_imm;
      end
      
      //...
    endcase
  end
```

在`FunctGen.v`中设置对应的funct字段


```verilog
  always @(*) begin
    case (op)
      // Extends
      `OP_ADDI: funct <= `FUNCT_ADD;
      `OP_ANDI: funct <= `FUNCT_AND;
      `OP_ORI: funct <= `FUNCT_OR;
      // ...
    endcase
  end
```


