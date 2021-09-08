module addr_xlator(addr_in, write_en, dev, addr_out);

	parameter addr_width = 9;
	parameter num_ram = 20;

	input [15 : 0] addr_in;
	input write_en;
	output [num_ram - 1 : 0] dev;
	output [addr_width - 1 : 0] addr_out;

	assign addr_out = addr_in[addr_width - 1 : 0];
	assign dev = 1 << addr_in[15 : addr_width] & {num_ram{write_en}};

endmodule