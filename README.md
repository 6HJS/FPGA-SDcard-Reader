![test](https://img.shields.io/badge/test-passing-green.svg)
![docs](https://img.shields.io/badge/docs-passing-green.svg)

FPGA SDcard File Reader
===========================
**基于 FPGA 的 SD卡文件读取器**

* **基本功能** ：FPGA作为 **SD-host** ， 指定文件名 **读取文件内容** ；或指定扇区号 **读取扇区内容**。
* **性能** : 使用 **SD总线** 实现，而不是 **SPI总线** 。 读取速度更快。
* **兼容性强** : 自动适配 **SD卡版本** ，自动适配 **FAT16/FAT32文件系统**。
* **RTL实现** ：完全使用 **SystemVerilog**  ,便于移植和仿真。

|                      |  SDv1.1 card       |  SDv2 card          | SDHCv2 card          |
| :-----               | :------------:     |   :------------:    | :------------:       |
| **读取扇区**         | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark:   |
| **读取文件 (FAT16)** | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark:\* |
| **读取文件 (FAT32)** | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark:   |

> \* 注： SDHCv2 card 一般不使用 FAT16 文件系统



# 核心代码

详见 [RTL目录](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/RTL/ "RTL目录") ，它包含**本库的核心代码** ， 可以被用户调用，实现二次开发。



# 示例

* [读取文件示例](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/example/ReadFile/ "读取文件示例")：FPGA 读取SD卡中的文件

* [读取扇区示例](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/example/ReadSector/ "读取扇区示例")：FPGA 读取SD卡中的扇区



# 相关链接

* [FPGA SD卡读取器 (SPI版本)](https://github.com/WangXuan95/FPGA-SDcard-Reader-SPI/ "SPI版本") : 与该库功能相同，但使用 **SPI总线**。

* [FPGA SD卡模拟器](https://github.com/WangXuan95/FPGA-SDcard-Simulator/ "SD卡模拟器") : FPGA模仿SD卡行为，实现FPGA 模拟 **SDHC v2 ROM卡**
