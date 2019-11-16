Examples for file reading
===========================

This example runs on [**Nexys4-DDR board**](http://www.digilent.com.cn/products/product-nexys-4-ddr-artix-7-fpga-trainer-board.html), which finds example.txt in the root directory of SD card and read all its contents, then send it to PC by UART.


# Running Example

1、 Prepare a microSD card in FAT16 or FAT32 format. If not, it needs to be pre formatted to FAT16 or FAT32.

2、 Create example.txt in the root directory of microSD card, then write some contents in the file.

3、 Insert microSD card into the slot of Nexys4-DDR board.

4、 Plug the USB port of Nexys4-DDR development board into PC, and open the corresponding serial port with a Serial Monitor Software, such as **Serial Assistant** or **Putty**.

5、 Open the project **Nexys4-ReadFile.xpr** with **Vivado2018**(or higher version) , synthesis, implement, and then upload the board.

6、 Once the uploading finish, the serial port prints out the contents of the file. Press the red **CPU Reset** button on the board to read it again.

7、 Meanwhile, the LEDs on the board have changed, indicating the status and type of SD. See the code Notes for the specific meaning.
