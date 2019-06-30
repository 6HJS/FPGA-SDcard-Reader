FPGA sdcard 核心RTL代码
===========================

* **SDReader.sv** : 实现一个 **扇区读取器** ，具体使用方法见其注释
* **SDFileReader.sv** : 实现一个 **文件读取器** ，具体使用方法见其注释
* **SDCmdCtrl.sv** : 实现一个 **sdcmd 信号线上的会话控制器** ，被 **SDReader.sv** 调用
* **SDDirParser.sv** : 实现一个 **FAT目录项解析器** ，被 **SDFileReader.sv** 调用
* **SDFake.sv** : 实现一个 **模拟SD卡**
