FPGA SDcard 示例
===========================

* [读取文件示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadFile/ "读取文件示例")：FPGA 作为 **SD-host** ，读取SD卡中的文件
* [读取扇区示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector/ "读取扇区示例")：FPGA 作为 **SD-host** ，读取SD卡中的扇区
* [FPGA模拟SD卡示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard/ "FPGA模拟SD卡示例") ：FPGA模拟SD卡，将FPGA相应引脚接在读卡器上，让读卡器识别出SD卡。
* [FPGA模拟SD卡示例(Debug)](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard_Debug/ "FPGA模拟SD卡示例(Debug)")：与上一个类似，但多出一个 **SD总线监视** 功能，监视到的数据包发送到UART。
* [读取模拟SD卡扇区示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector_FakeSD/ "读取模拟SD卡扇区示例") : FPGA模拟 **SD卡** ，再作为 **SD-host** 去读它，相当于 FPGA 自己读取自己。
* [读取模拟SD卡扇区示例仿真](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector_FakeSD_simulation/ "读取模拟SD卡扇区示例仿真") : 上一个示例的仿真，用来观察SD卡初始化时总线上的波形（如下图）
