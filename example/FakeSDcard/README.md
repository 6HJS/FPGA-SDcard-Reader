FPGA模拟SD卡示例
===========================

该示例用FPGA模拟一个格式化好的SD卡(FAT32)。若将FPGA相应引脚接在读卡器上，能让读卡器识别出SD卡，如下图：

![Windows识别出的假SD卡](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/FakeSDcardResult.png)

> 注：目前该示例并不支持所有型号的 SD读卡器，笔者测试时，发现一个川宇和一个绿联的读卡器能识别，但一个杂牌的读卡器识别不了，还未找到原因。

该示例需要用到以下几个源文件：
* **./RTL** 下的 [top.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard/RTL/top.sv "top.sv")，是该示例的顶层
* **../../RTL** 下的 [SDFake.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDFake.sv "SDFake.sv")、[SDcardContent.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDcardContent.sv "SDcardContent.sv")

你需要手动建立工程并为 **top.sv** 分配引脚。详见 **top.sv** 里的注释

另外，**./Quartus** 目录中提供了一个基于 **Altera Cyclone IV FPGA** 的工程示例。但你多半需要重新为它调整器件型号和引脚分配，才能在你的 FPGA 板子上正确的运行。

# 推荐硬件电路

如下图，你需要想办法将 **FPGA连接到读卡器** 。笔者画了一个 **SD卡形状的PCB** ，能插入读卡器中。 当然，你可以采取飞线的方式等。

注意：下图所示的 **R1电阻** 是必要的，因为 SD读卡器认为插入SD卡后 **必然会消耗一定的电流** ，这里 **R1电阻** 就是用来产生这个电流的。如果没有 **R1电阻** ，SD卡不会被读卡器识别。

![推荐硬件电路](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/FakeSD_sch.png)

笔者的测试平台：

![推荐硬件电路](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/FakeSD_platform.png)

# 调试

该示例并不反馈任何调试信息。如果你想查看SD卡插入读卡器时的一连串命令和响应，请参阅：[FPGA模拟SD卡示例(Debug)](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard_Debug/ "FPGA模拟SD卡示例(Debug)")
