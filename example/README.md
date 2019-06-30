FPGA SDcard 示例
===========================

* [读取文件示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadFile/ "读取文件示例")
* [读取扇区示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector/ "读取扇区示例")
* [读取模拟SD卡扇区示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector_FakeSD/ "读取模拟SD卡扇区示例") : 与 [读取扇区示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector/ "读取扇区示例") 唯一的不同是不使用真实的SD卡，而是在FPGA内模拟一个SD卡，也就是整个过程都是FPGA自己读取自己。如果你手头没有 SD 卡，可以先尝试该示例。
* [读取模拟SD卡扇区示例仿真](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector_FakeSD_simulation/ "读取模拟SD卡扇区示例仿真") : 上一个示例的仿真，在仿真中你可以看到SD卡初始化时总线上的波形（如下图）
* [FPGA模拟SD卡示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/FakeSDcard/ "FPGA模拟SD卡示例") ：FPGA模拟SD卡，留出引脚接在读卡器上，让读卡器识别成SD卡（尚未完善）
