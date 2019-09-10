FPGA SDcard Reader 核心代码
===========================

|  文件名             |    描述                                              |  备注      |
| :------             | :---------                                           | :----      |
| **SDFileReader.sv** | SD卡文件读取器                                       | 可作为顶层 |
| **SDDirParser.sv**  | FAT16/FAT32 目录解析器 ，被 **SDFileReader.sv** 调用 |    -       |
| **SDReader.sv**     | SD卡 扇区读取器                                      | 可作为顶层 |
| **SDCmdCtrl.sv**    | CMD 信号线上的会话控制器 ，被 **SDReader.sv** 调用   |    -       |


# 各种应用场景下的组织结构

### 应用场景 : FPGA读取SD卡文件（参见[读取文件示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadFile/ "读取文件示例")）

* **项目顶层**
	* **SDFileReader.sv**
		* **SDDirParser.sv**
		* **SDReader.sv**
			* **SDCmdCtrl.sv**
	* **其它用户代码**

### 应用场景 : FPGA读取SD卡扇区 (参见[读取扇区示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/ReadSector/ "读取扇区示例"))

* **项目顶层**
	* **SDReader.sv**
		* **SDCmdCtrl.sv**
	* **其它用户代码**
