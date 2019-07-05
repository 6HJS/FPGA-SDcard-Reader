FPGA sdcard 核心 SystemVerilog 代码
===========================

* **SDReader.sv** : SD卡 **扇区读取器**
* **SDFileReader.sv** : SD卡 **文件读取器**
* **SDCmdCtrl.sv** : **sdcmd 信号线上的会话控制器** ，被 **SDReader.sv** 调用
* **SDDirParser.sv** : **FAT16/FAT32 目录项解析器** ，被 **SDFileReader.sv** 调用
* **SDFake.sv** :  **模拟SD卡**
* **SDcardContent.sv** : 一个ROM，其内容作为SD卡内的内容时，会被识别为一个 **FAT32** 的磁盘

# 推荐的各种应用场景下的项目组织结构

### 应用场景 : FPGA读取SD卡文件（参见[读取文件示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadFile/ "读取文件示例")）

> **项目顶层**
>> **SDFileReader.sv**
>>> **SDDirParser.sv**
>>> **SDReader.sv**
>>>> **SDCmdCtrl.sv**
>> **其它用户代码** (比如处理读到的结果)

### 应用场景 : FPGA读取SD卡扇区 (参见[读取扇区示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector/ "读取扇区示例"))

> **项目顶层**
>> **SDReader.sv**
>>> **SDCmdCtrl.sv**
>> **其它用户代码** (比如处理读到的结果) 

### 应用场景 : FPGA模拟SD卡 (参见[FPGA模拟SD卡示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard/ "FPGA模拟SD卡示例"))

> **项目顶层**
>> **SDFake.sv**
>> **SDcardContent.sv** (此文件为模拟SD卡提供内容，可自行修改它)
