FPGA模拟SD卡示例
===========================

该示例用FPGA模拟一个格式化好的SD卡(FAT32)。若将FPGA相应引脚接在读卡器上，能让读卡器识别出SD卡，如下图：

> 注：目前，FPGA模拟 FAT32 SD卡的方式是将 MBR、DBR、FAT表、根目录等数据 **写死在 Verilog实现的 ROM里** , 该 **模拟SDcard** 是只读的，如果你想改变其内容，见教程 [获取 SDcard 的内容到模拟 SDcard 里](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard/DumpCard.md)

![Windows识别出的假SD卡](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/FakeSDcardResult.png)

同时，该示例监视 SD总线，将 SD 总线上抓到的命令和响应发送到 UART。

> 注：目前该示例并不支持所有型号的 SD读卡器，笔者测试时，发现一个川宇和一个绿联的读卡器能识别，但一个杂牌的读卡器识别不了，还未找到原因。

该示例需要用到以下几个源文件：
* **./RTL** 下的 [top.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard_Debug/RTL/top.sv "top.sv")，是该示例的顶层
* **../../RTL** 下的 [SDFake.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDFake.sv "SDFake.sv")、[SDcardContent.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDcardContent.sv "SDcardContent.sv")
* **../../UART** 下的 [uart_tx.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/UART/uart_tx.sv "uart_tx.sv")、[ram.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/UART/ram.sv "ram.sv")
* **./RTL** 下的 **所有其它文件**，这些文件实现了一个 SD总线监视器，该监视器会发送监视数据给 UART 。

你需要手动建立工程并为 **top.sv** 分配引脚。详见 **top.sv** 里的注释

另外，**./Quartus** 目录中提供了一个基于 **Altera Cyclone IV FPGA** 的工程示例。但你多半需要重新为它调整器件型号和引脚分配，才能在你的 FPGA 板子上正确的运行。

# 推荐硬件电路

如下图，你需要想办法将 **FPGA连接到读卡器** 。笔者画了一个 **SD卡形状的PCB** ，能插入读卡器中。 当然，你可以采取飞线的方式等。

**注意事项** ：

* 下图所示的 **R1电阻** 和 **C1电容** 是必要的，因为 SD读卡器认为插入SD卡后 **必然会消耗一定的电流** ，这里 **R1电阻** 就是用来产生这个电流的。如果没有 **R1电阻** ，SD卡不会被读卡器识别。

* 下图所示的 **R2电阻** 是必要的，因为 DAT3 信号兼具 SD卡插入检测功能，上拉电阻R2用来生成检测信号。

* SDVCC 电源是读卡器提供的，该电源 **不允许** 用于给 FPGA 系统电路供电， FPGA应该使用额外的电源。 

* **R2电阻** 可以上拉到 SDVCC 上，也可以上拉到 FPGA 系统电源上。

![推荐硬件电路](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/FakeSD_sch.png)

笔者的测试平台：

![推荐硬件电路](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/FakeSD_platform.png)

# 调试

该示例将调试信息通过 **UART** 发送了出去( **波特率=115200** )，如果你的 FPGA 开发板有 UART，请将 **top.sv** 的 **output uart_tx** 引脚正确的分配。

下图是监视器发到串口的数据，每一行代表一个命令或响应，例如：

* 第一行代表读卡器发送了 CMD0，参数为 0x00000000，CRC+停止位 为 0x95
* 第二行代表读卡器发送了 CMD8，参数为 0x000001AA，CRC+停止位 为 0x87
* 第三行代表FPGA响应了 CMD8，参数为 0x000001AA，CRC+停止位 为 0x13
* ……

![监视器数据](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/monitor_data.png)

