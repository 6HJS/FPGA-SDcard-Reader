获取 SDcard 的内容到模拟 SDcard 里
===========================

本文档展示了如何将 **真实SDcard** 的内容复制到 **FPGA模拟SDcard** 里，以让 **模拟SDcard** 展现出与 **真实SDcard** 完全相同的内容。

# 首先你需要
* 成功跑通 [FPGA模拟SD卡示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard/ "FPGA模拟SD卡示例") ，因为我们要在它的基础上做修改。
* 安装软件 [WinHex](http://www.x-ways.net/winhex/ "WinHex")

# 步骤

SD卡中的内容决定了它有几个分区，每个分区的文件系统是什么，以及每个分区中的目录结构和文件内容。所以我们只需将 **真实SDcard** 的内容原封不动的导出到 **FPGA模拟SDcard** 即可。步骤如下：
* 将你想复制的 **真实的，已经格式化了的SDcard** 通过读卡器连到电脑
* 用 **管理员权限** 打开 **WinHex** ，打开 **菜单栏->工具->打开磁盘->物理磁盘** ，然后选择 **你的SDcard**
* 然后你可以看到 **SDcard** 的全部内容，点击 **非分区空间** 可以看到起始地址为0的MBR（主引导记录)，它占一个扇区(512B)的大小。然后点击 **分区1** ，可以看到 **SDcard** 中的一个分区。
* 下面你要把这些内容原封不动的放入 [SDcardContent.sv](https://github.com/WangXuan95/FPGA-SDcard/blob/master/RTL/SDcardContent.sv "SDcardContent.sv") 里，该 SystemVerilog 文件描述了一个 **ROM** 。手工放的工作量太大，你可以从 WinHex 复制到文件后，编写一个脚本把它转换成 **Verilog ROM**。
> **提示**: 因为SDcard内的字节大多是0x00，**Verilog ROM** 里只需要记录 **非零字节** 即可。最后加一句 **default : sddata=8'h00;**
* 完成后，重新编译综合上传 [FPGA模拟SD卡示例](https://github.com/WangXuan95/FPGA-SDcard/blob/master/example/FakeSDcard/ "FPGA模拟SD卡示例") 。你就能看到 **FPGA模拟SDcard** 里的内容变成了和 **真实SDcard** 一样了。
