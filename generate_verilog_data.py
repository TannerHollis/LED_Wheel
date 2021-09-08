import random, os

n_LEDS = 320
start_addr = 0

with open("LEDWheel/input_files/input_data.b", 'w') as f:
    data = [0] * (n_LEDS + 3)
    data[0] = 1     #instruction
    data[1] = start_addr >> 8       #high-byte starting address
    data[2] = start_addr & 0x0F     #low-byte starting address
    for i in range(n_LEDS):
        data[i + 3] = random.randint(0, 255)
    for i in range(n_LEDS + 1):
        f.write("{:08b}\n".format(data[i]))

    with open("LEDWheel/input_files/input_data.txt", 'w') as g:
        g.write("Instruction:\t{}\n".format(data[0]))
        g.write("Start Device:\t{:3d}\t(8'b{:08b})\n".format(start_addr >> 9, data[1]))
        g.write("Start Address:\t{:3d}\t(8'b{:08b})\n".format(start_addr & 0x1FF, data[2]))
        for i in range(3, n_LEDS + 3):
            g.write("{:03d}:\t{}\n".format(i - 2, data[i]))

##os.system('iverilog -o LEDWheel/spi_in_tb.txt spi_in_tb.v')
##os.system('vvp LEDWheel/spi_in_tb.txt -lxt2')
##os.system('gtkwave LEDWheel/test.vcd')
