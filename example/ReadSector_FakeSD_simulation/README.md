读取模拟SD卡扇区示例（仿真）
===========================

该仿真示例 **使用Verilog模拟一个SD卡**，然后读取该SD卡的 **0号扇区**。

该示例需要用到以下几个源文件：
* **./RTL** 下的 [top.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector_FakeSD_simulation/testbench/top.sv "top.sv")，是该仿真的顶层
* **../../RTL** 下的 [SDFake.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDFake.sv "SDFake.sv")、[SDReader.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDReader.sv "SDReader.sv")、[SDCmdCtrl.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDCmdCtrl.sv "SDCmdCtrl.sv")

你可以手动将以上几个文件用你熟悉的 RTL 仿真环境搭建仿真。

另外，如果你用modelsim，也可以打开 [modelsim仿真工程](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector_FakeSD_simulation/Modelsim "modelsim仿真工程")

仿真结果是一个SD卡初始化后开始读取数据的波形图：

![仿真波形](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/wave.png)
