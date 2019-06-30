FPGA SDcard
===========================
有关 **SD卡** 的各种 **FPGA实现**

|           |  SDv1.1 card       |  SDv2 card          | SDHCv2 card        | FPGA模拟SDHCv2 card
| :-----:   | :------------:     |   :------------:    | :------------:     | :------------:     |
| **FPGA读取扇区**  | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark:  |  :heavy_check_mark:  | 
| **FPGA读取根目录中的文件(FAT16)** | :heavy_check_mark: |  :heavy_check_mark: | NaN  | 不计划 |
| **FPGA读取根目录中的文件(FAT32)** | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark: | 不计划 |
| **读卡器读取**    | | | | 仍需完善 |

* 该库完全使用 **SD总线** 实现，而不是 **SPI** 。笔者也有 [SPI版本](https://github.com/WangXuan95/FPGA-SDcard-File/ "SPI版本")，但读取速度不如该库的 **SD总线** ，因此推荐使用该库。
* **已实现的功能**：该库提供两个稳定的功能：指定文件名 **读取文件内容** ；或指定扇区号 **读取扇区内容**。
* **尚未实现的功能**：除了用FPGA实现 **SD卡读取器** 以外，该库还尝试用 Verilog 实现一个 **虚假的SD卡** ，这么做的目的不仅仅是仿真，还希望这个 **虚假的SD卡** 是可综合的，这样就能实现 **FPGA模拟SD卡**。这一步仍需完善。
* **纯 RTL 实现** ：完全使用 **SystemVerilog**  ,方便移植

# 目录组织
* [./RTL](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/ "./RTL") : 包含 SD卡相关的核心代码，这些模块留出**明确的输入输出接口**，方便Verilog开发者调用它们进行二次开发。
* [./example](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ "./example") : 包含几个示例，展示如何调用 [RTL](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/ "RTL") 中的模块，读取 SD 卡扇区或文件，并用 **UART** 发送给上位机。
* [./UART](https://github.com/WangXuan95/fpga-sdcard/blob/master/UART/ "./UART") : UART发送器代码，虽然与SD卡本身无关，但 [example](https://github.com/WangXuan95/fpga-sdcard/blob/master/RTL/ "example") 中的很多示例都用到了它。
* [./images](https://github.com/WangXuan95/fpga-sdcard/blob/master/images/ "./images") : 一些图片


# 示例
* [读取文件示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadFile/ "读取文件示例")
* [读取扇区示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector/ "读取扇区示例")
* [读取模拟SD卡扇区示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector_FakeSD/ "读取模拟SD卡扇区示例") : 与 [读取扇区示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector/ "读取扇区示例") 唯一的不同是不使用真实的SD卡，而是在FPGA内模拟一个SD卡，也就是整个过程都是FPGA自己读取自己。如果你手头没有 SD 卡，可以先尝试该示例。
* [读取模拟SD卡扇区示例仿真](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/ReadSector_FakeSD_simulation/ "读取模拟SD卡扇区示例仿真") : 上一个示例的仿真，在仿真中你可以看到SD卡初始化时总线上的波形（如下图）
* [FPGA模拟SD卡示例](https://github.com/WangXuan95/fpga-sdcard/blob/master/example/FakeSDcard/ "FPGA模拟SD卡示例") ：FPGA模拟SD卡，留出引脚接在读卡器上，让读卡器识别成SD卡（尚未完善）

![仿真波形](https://github.com/WangXuan95/fpga-sdcard/blob/master/images/wave.png)

# 推荐硬件电路

![推荐硬件电路](https://github.com/WangXuan95/fpga-sdcard/blob/master/images/sch.png)

# 应用场景
* 在没有 MCU 或 软核 辅助的 FPGA 系统中，实现一些离线配置，例如任意波发生器的波形配置。
* 为 FPGA 中的软核配置运行程序或操作系统。
