FPGA SDcard
===========================
有关 **SD卡** 的各种 **FPGA实现**

|           |  SDv1.1 card       |  SDv2 card          | SDHCv2 card        | FPGA模拟SDHCv2 card |
| :-----:   | :------------:     |   :------------:    | :------------:     | :------------:     |
| **FPGA读取扇区**  | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark:  |  :heavy_check_mark:  | 
| **FPGA读取根目录中的文件(FAT16)** | :heavy_check_mark: |  :heavy_check_mark: | NaN  | NaN |
| **FPGA读取根目录中的文件(FAT32)** | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| **读卡器读取**    | | | | :heavy_check_mark: |

* 该库完全使用 **SD总线** 实现，而不是 **SPI** 。笔者也有 [SPI版本](https://github.com/WangXuan95/FPGA-SDcard-File/ "SPI版本")，但读取速度不如该库的 **SD总线** ，因此推荐使用该库。
* **提供FPGA读取SD卡功能**：FPGA作为 **SD-host** ， 指定文件名 **读取文件内容** ；或指定扇区号 **读取扇区内容**。
* **提供FPGA模拟SD卡功能**：FPGA作为 **SD-device** ，能实现 **FPGA模拟SD卡**。目前已经成功使用 FPGA 模拟了一个 **FAT32格式** 的 **SDHCv2.0只读卡**，并能被读卡器识别。
* **纯 RTL 实现** ：完全使用 **SystemVerilog**  ,方便移植

# 目录组织
* [./RTL](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/ "./RTL") : 包含 SD卡相关的核心代码，这些模块留出**明确的输入输出接口**，方便Verilog开发者调用它们进行二次开发。
* [./example](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ "./example") : 几个示例，展示了 [./RTL](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/ "./RTL") 中的模块如何调用。
* [./UART](https://github.com/WangXuan95/FPGA-SDcard/blob/master/UART/ "./UART") : UART发送器代码，虽然与SD卡本身无关，但 [example](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/ "example") 中的很多示例都用到了它。
* [./images](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/ "./images") : 一些图片


# 核心代码
[RTL目录](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/ "RTL目录") 包含 **SD卡的核心代码** ， 它们可以当作 **IP核** 被调用，实现二次开发。

虽然核心代码文件很多，但并不是每种应用都要用到全部的文件，而是根据实际情况选择合适的顶层文件去调用。详见 [RTL目录](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/ "RTL目录") 里的 README

# 示例
* [读取文件示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadFile/ "读取文件示例")：FPGA 作为 **SD-host** ，读取SD卡中的文件
* [读取扇区示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector/ "读取扇区示例")：FPGA 作为 **SD-host** ，读取SD卡中的扇区
* [FPGA模拟SD卡示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard/ "FPGA模拟SD卡示例") ：FPGA模拟SD卡，将FPGA相应引脚接在读卡器上，让读卡器识别出SD卡。
* [FPGA模拟SD卡示例(Debug)](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard_Debug/ "FPGA模拟SD卡示例(Debug)")：与上一个类似，但多出一个 **SD总线监视** 功能，监视到的数据包发送到UART。
* [读取模拟SD卡扇区示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector_FakeSD/ "读取模拟SD卡扇区示例") : FPGA模拟 **SD卡** ，再作为 **SD-host** 去读它，相当于 FPGA 自己读取自己。
* [读取模拟SD卡扇区示例仿真](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector_FakeSD_simulation/ "读取模拟SD卡扇区示例仿真") : 上一个示例的仿真，用来观察SD卡初始化时总线上的波形（如下图）


![仿真波形](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/wave.png)
图：仿真波形

# 应用场景
* 在没有 MCU 或 软核 辅助的 FPGA 系统中，实现一些离线配置，例如任意波发生器的波形配置。
* 为 FPGA 中的软核配置运行程序或操作系统。
* FPGA 模拟 SD卡，为一些需要用 SD卡初始化的设备提供另一种初始化方式。
