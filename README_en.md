![test](https://img.shields.io/badge/test-passing-green.svg)
![docs](https://img.shields.io/badge/docs-passing-green.svg)
![platform](https://img.shields.io/badge/platform-Quartus|Vivado-blue.svg)

FPGA SDcard File Reader
===========================
**SDcard file reader based on FPGA**

* **Function** ：FPGA as SD-host, specifies the file name to read the file content, or specifies the sector number to read the sector content.
* **Performance** : Using SD bus instead of SPI bus to get higher reading speed.
* **Compatibility** : Automatic adaptation of SDcard version. Automatic adaptation of FAT16/FAT32 file system.
* **RTL implementation** ：Pure SystemVerilog implementation, which is convenient for migration and simulation.

|                       |  SDv1.1 card       |  SDv2 card          | SDHCv2 card        |
| :-----                | :------------:     |   :------------:    | :------------:     |
| **Read Sector**       | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark: |
| **Read File (FAT16)** | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark: |
| **Read File (FAT32)** | :heavy_check_mark: |  :heavy_check_mark: | :heavy_check_mark: |




# Main Code

See [RTL directory](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/RTL/) , which contains the main code of this repo. It can be called by users for secondary development.



# Xilinx FPGA Examples

The following example is based on [**Nexys4-DDR board**](http://www.digilent.com.cn/products/product-nexys-4-ddr-artix-7-fpga-trainer-board.html) (Xilinx Artix-7)。

* [Examples for file reading](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/Nexys4-ReadFile/) : Read the file in SDcard and print the content through UART.
* [Examples for sector reading](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/Nexys4-ReadSector/) : Read the sector in SDcard and print the content through UART.



# Altera FPGA Examples

The following example is based on [**DE0-CV board**](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=163&No=921) (Altera Cyclone V)。

* [Examples for file reading](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/DE0-CV-ReadFile/) : Read the file in SD card and display the content on a VGA screen
* [Examples for sector reading](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/DE0-CV-ReadSector/) : Read the sector in SDcard.

| ![Display on VGA screen](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/images/screen.jpg) |
| :------: |
| Figure：The example display a SDcard file content on a VGA screen |


# Related links

* [FPGA SDcard File Reader (SPI Version)](https://github.com/WangXuan95/FPGA-SDcard-Reader-SPI/) : Same function as the repo, but using SPI bus.

* [FPGA SDcard Simulator](https://github.com/WangXuan95/FPGA-SDcard-Simulator/) : Make a FPGA acts like a SDcard.
