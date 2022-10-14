# USTB Computer Organization Course Design

`ilab-x`

ilab-x平台答案

`1.1`和`2.1`可以使用本分支下的脚本快速完成:

```
pip install pyautogui
python fill.py
```

## Warning

说一下我踩的坑，首先那个ilab-x平台注册是要确保个人资料中有你的学号

做实验时一定要**关闭代理**

建议一次做完然后上传，先前的分数刷新后就丢失了


## 1.1 

汇编代码

```assembly
# 赋值指令，借助0号寄存器和立即数做加法并存入目的寄存器的方式实现
addi $1,$0,10
addi $2,$0,20
addi $3,$0,30
addi $5,$0,50
addi $6,$0,60

# save word
sw $5,100($2)

# 常见运算
sub $2,$1,$3 
and $12,$2,$5
or $13,$6,$2 
add $14,$2,$2 

# load word
lw $15,100($2)
```

完成两个仿真后，进入冲关答题

答案

```
A A B A B
B A A 
```

## 1.2 

```verilog
# Core,v 
RegReadProxy reg_read_proxy(
    .read_en_1                (id_reg_read_en_1),
    .read_en_2                (id_reg_read_en_2),
    .read_addr_1              (id_reg_addr_1),
    .read_addr_2              (id_reg_addr_2),

    .data_1_from_reg          (regfile_read_data_1),
    .data_2_from_reg          (regfile_read_data_2),

    
    .reg_write_en_from_ex     (ex_reg_write_en),
    .reg_write_addr_from_ex   (ex_reg_write_addr),
    .data_from_ex             (ex_result),


    .reg_write_en_from_mem    (mem_reg_write_en),
    .reg_write_addr_from_mem  (mem_reg_write_addr),
    .data_from_mem            (mem_result),

    .read_data_1              (id_reg_data_1),
    .read_data_2              (id_reg_data_2)
  );
```

```verilog 
  // generate output read_data_1
  always @(*) begin
    if (read_en_1) begin
      if (reg_write_en_from_ex &&
          read_addr_1 == reg_write_addr_from_ex) begin
        read_data_1 <= data_from_ex;
      end
      else if (reg_write_en_from_mem &&
          read_addr_1 == reg_write_addr_from_mem) begin
        read_data_1 <= data_from_mem;
      end
      else begin
        read_data_1 <= data_1_from_reg;
      end
    end
    else begin
      read_data_1 <= 0;
    end
  end

  // generate output read_data_2
  always @(*) begin
    if (read_en_2) begin
      if (reg_write_en_from_ex &&
          read_addr_2 == reg_write_addr_from_ex) begin
        read_data_2 <= data_from_ex;
      end
      else if (reg_write_en_from_mem &&
          read_addr_2 == reg_write_addr_from_mem) begin
        read_data_2 <= data_from_mem;
      end
      else begin
        read_data_2 <= data_2_from_reg;
      end
    end
    else begin
      read_data_2 <= 0;
    end
  end
```

## 2.1 

汇编代码

```
addi $1,$0,10
addi $2,$0,20
addi $3,$0,30
sw $1,20($1)
addi $5,$0,50
addi $6,$0,60
addi $7,$0,70
lw $2,20($1)
and $4,$2,$5
or $8,$2,$6 
add $9,$4,$2 
slt $1,$2,$7
```

Answer

```
A A A B
A A A
```


## 2.2 

```verilog
// ID.v 
// line 57
  assign stall_request = load_related_1 || load_related_2;
```

```verilog
// PipeineDeliver.v 

    else if (stall_current_stage && !stall_next_stage) begin
      out <= 0;
    end
    else if (!stall_current_stage) begin
      out <= in;
    end
```

```verilog
// RegRead.v 

// generate load related signals
  assign load_related_1 =
      (ex_load_flag && read_en_1 && read_addr_1 == reg_write_addr_from_ex) ||
      (mem_load_flag && read_en_1 && read_addr_1 == reg_write_addr_from_mem);
  assign load_related_2 =
      (ex_load_flag && read_en_2 && read_addr_2 == reg_write_addr_from_ex) ||
      (mem_load_flag && read_en_2 && read_addr_2 == reg_write_addr_from_mem);

```
