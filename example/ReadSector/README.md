读取扇区示例
===========================

该示例读取 **SD卡** 的 **0号扇区**，然后用 **UART** 发送出去。如果 **UART** 连接到 电脑，可以看到扇区内容。

# 推荐硬件电路

要运行该示例，你需要一个带有 **SD卡槽** 的 FPGA开发板（如Nexys4开发板、荔枝糖开发板）。

本例在笔者的Altera FPGA开发板上运行，为了适配你的开发板，请重新为工程分配器件和引脚。详见 **top.sv** 里的注释。

> 注: clk 的频率最好是 50MHz，这是为了保证UART波特率正确，实际上SD读取器可以接受0~50MHz的任意频率。

> 注: 很多 **SoC FPGA** 开发板也带有 **SD卡槽** ，但一般该卡槽是与 **硬核处理器** 连接的。我们需要的是与 FPGA 连接的 **SD卡槽**。

![推荐硬件电路](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/images/sch.png)

# 运行结果

![读取扇区结果](https://github.com/WangXuan95/FPGA-SDcard-Reader/blob/master/images/ReadSector.png)

上图是从SD卡读出的0号扇区的内容，可以看出，这就是所谓的 **MBR扇区**
