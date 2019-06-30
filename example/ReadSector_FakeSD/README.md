读取模拟SD卡扇区示例
===========================

该示例 **使用FPGA模拟一个SD卡**，然后读取该SD卡的 **0号扇区**，然后用 **UART** 发送出去。如果 **UART** 连接到 电脑，可以看到扇区内容。

该示例相当于 FPGA 模拟一个SD卡，然后自己读取自己。虽然没有什么意义，但手头没有SD卡的可以先尝试该示例。

该示例需要用到以下几个源文件：
* **./RTL** 下的 [top.sv](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector_FakeSD/RTL/top.sv "top.sv")，是该示例的顶层
* **../../RTL** 下的 [SDFake.sv](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/SDFake.sv "SDFake.sv")、[SDReader.sv](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/SDReader.sv "SDReader.sv")、[SDCmdCtrl.sv](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/SDCmdCtrl.sv "SDCmdCtrl.sv")
* **../../UART** 下的 [uart_tx.sv](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/uart_tx.sv "uart_tx.sv")、[ram.sv](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/ram.sv "ram.sv")

你需要手动建立工程并为 **top.sv** 分配引脚。详见 **top.sv** 里的注释

另外，**./Quartus** 目录中提供了一个基于 **Altera Cyclone IV FPGA** 的工程示例。但你多半需要重新为它调整器件型号和引脚分配，才能在你的 FPGA 板子上正确的运行。


运行结果：

该示例将 **扇区0** 中的内容通过 **UART** 发送了出去( **波特率=115200** )，如果你的 FPGA 开发板有 UART，请将 **top.sv** 的 **output uart_tx** 引脚正确的分配，以在上位机中观察读到的文件内容。

最后注意，clk 的频率需要给 50MHz，如果你没办法给 50MHz，请按照注释修改一些参数后，程序照样能正确运行。另外， rst_n 信号是低电平复位的，你可以把它连接到按钮上，每次复位都能重新读取一遍 SD 卡。如果你的 FPGA 开发板没有按钮，请将 rst_n 赋值为 1'b1

