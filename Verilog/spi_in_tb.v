`include "spi_in.v"
`include "ram_512_8.v"
`include "addr_xlator.v"
`timescale 1ns / 10ps

module spi_in_tb;

	reg [7 : 0] data_in[321];
	reg [9 : 0] count = 0;
	reg [7 : 0] bit_count = 0;
	
	parameter num_devices = 20;
	
	/* Make a reset that pulses once. */
	reg reset = 0;
	initial 
	begin
		$dumpfile("test.vcd");
		$dumpvars(0, spi_in_tb);
		# 4 reset = 1;
		#17 reset = 0;
		# 32500 reset = 1;
		# 33000 $finish;
	end

	/* Fill data_in with file contents */
	initial
	begin
		$readmemb("input_files/input_data.b",data_in);
	end

	/* Make a regular pulsing clock for spi. */
	reg clk_spi = 0;
	always #5 clk_spi = !clk_spi;
	
	/* Make a regular pulsing clock for spi. */
	reg clk_sys = 0;
	always #2 clk_sys = !clk_sys;

	wire [num_devices - 1 : 0] dev;
	wire [7:0] d_ram_in, d_ram_out;
	wire [8:0] waddr_xlated;
	wire [15:0] settings, waddr;
	wire write_en, send;
	wire sdi;
  
	always @(negedge clk_spi or posedge reset)
	begin
		if(reset)
		begin
			count <= 0;
			bit_count <= 0;
		end
		else
		begin
			if(bit_count == 7)
			begin
				count <= count + 1;
				bit_count <= 0;
			end
			else
			begin
				bit_count <= bit_count + 1;
			end
		end
	end

	assign sdi = data_in[count][7 - bit_count];

	/* Connect the device under test */
	spi_in spi_in_inst(
		.clk_sys(clk_sys),
		.clk_spi(clk_spi), 
		.sdi(sdi), 
		.n_cs(reset), 
		.d_out(d_ram_in), 
		.write_en(write_en), 
		.waddr(waddr), 
		.send(send), 
		.settings(settings));
	
	addr_xlator addr_xlator_inst_0(
		.addr_in(waddr), 
		.write_en(write_en), 
		.dev(dev), 
		.addr_out(waddr_xlated));
	
	genvar i;
	generate
		for (i = 0; i < num_devices; i = i + 1)
		begin : ram_512_8
			ram_512_8 ram_512_8(
				.din(d_ram_in),
				.write_en(dev[i]),
				.waddr(waddr_xlated),
				.wclk(clk_sys),
				.raddr(),
				.rclk(clk_sys),
				.dout(d_ram_out));
		end
	endgenerate

endmodule // test