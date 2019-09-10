读取文件示例
===========================

该示例从 **SD卡根目录** 中找到文件 **example.txt** 并读取其全部内容，然后用 **UART** 发送出去。将 **UART** 连接到PC 可以看到文件内容。

# 运行示例

要运行该示例，你需要一个带有 **SD卡槽** 的 FPGA开发板（如Nexys4开发板、荔枝糖开发板）。

本例在笔者的Altera FPGA开发板上运行，为了适配你的开发板，请重新为工程分配器件和引脚。详见 **top.sv** 里的注释。

> 注意: clk 的频率最好是 50MHz，这是为了保证UART波特率正确，实际上SD读取器可以接受0~50MHz的任意频率。

> 注: 很多 **SoC FPGA** 开发板也带有 **SD卡槽** ，但一般该卡槽是与 **硬核处理器** 连接的。我们需要的是与 FPGA 连接的 **SD卡槽**。

![推荐硬件电路](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/sch.png)

# 运行结果

我用了手头所有能用的 SD卡 测试了该示例的兼容性，如下表：

|           |  SDv1.1 2GB card    | SDv2 128MB card     | SDv2 2GB card       | SDHCv2 8GB card    | SDHCv2 16GB card   |
| :------:  | :------------:      | :------------:      | :------------:      | :-----------:      | :-----------:      |
| **FAT16** | :heavy_check_mark:  |  :heavy_check_mark: | :heavy_check_mark:  | NaN\*              | NaN\*              |
| **FAT32** | :heavy_check_mark:  |  :heavy_check_mark: | :heavy_check_mark:  | :heavy_check_mark: | :heavy_check_mark: |

>  注：SDHCv2 无法在 Windows 中格式化成 FAT16 格式，所以也没法测试。

该示例将 目标文件 ( **example.txt** ) 的内容通过 **UART** 发送了出去( **波特率=115200** )，如果你的 FPGA 开发板有 UART，可以在上位机中观察读到的文件内容。

下图展示了使用 **SDHCv2 card** + **FAT32** 测试的结果。图中的 8 个 LED 来自 top.sv 中的输出端口 **output [7:0] led** ，编码为 **11111110** ， 最前面两个 **11** 代表SD卡类型为 **SDHCv2** ； 紧接着的两个 **11** 代表文件系统为 **FAT32** ；再接着的一个 *1* 代表找到目标文件（本示例中为 **target.txt** ，你可以修改）；最后的三个位 **110** 代表任务结束，这仅仅是 **SDFileReader.sv** 内的状态机码而已。 这 8 位 LED 的具体含义请见 **top.sv** 中的注释。

![测试结果照片](https://github.com/WangXuan95/FPGA-SDcard/blob/master/images/ReadFile.png)
