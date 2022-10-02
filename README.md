# USTB Computer Organization Course Design

`2-1`

## Usage

You have to install `git` on your device.

Use `git checkout [branch_name]` to get the code you need in CG.

For example, to get homework 2-1 RegFile, type following commands

```git
git checkout 2-1
```

Then compress all files in the current dictory and upload it to CG.

## 读端口

两个异步读端口，当读寄存器地址和上一个写寄存器相同时直接取出上次写的数据，其他情况正常读取。


## 写端口

由于不允许对0号寄存器进行写入，因此使用下列条件判断

```verilog
else if (write_en && |write_addr) begin
  registers[write_addr] <= write_data;
end
```

判断语句`write_en && |write_addr`当`write_addr`上每一位都为0（即地址为0号寄存器地址时）真值为0，不会进行写入操作。
