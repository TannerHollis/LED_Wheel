module LED_Wheel (clk_sys, clk_in, sdi, n_cs_in, n_reset, clk_out, sdo, n_cs_out);

parameter n_LEDS = 320;
parameter addr_width = 9;
parameter data_width = 8;

input clk_sys, clk_in, sdi, n_cs_in, n_reset;
output clk_out, sdo, n_cs_out;

wire [data_width - 1 : 0] wdata, rdata;
wire [addr_width - 1 : 0] waddr;
wire [15 : 0] settings;
wire write_en, send;

reg [addr_width - 1: 0] raddr = 0;
reg read_en = 1;

clk_div clk_div_inst( 	.clk_in(clk_sys),
						.clk_out(clk_out),
						.div(4'b0000),
						.nreset(n_reset) );

spi_in spi_in_inst( .clk_in(clk_in),
					.sdi(sdi),
					.n_cs_in(n_cs_in),
					.d_out(wdata),
					.write_en(write_en),
					.waddr(waddr),
					.send(send),
					.settings(settings) );

SB_RAM512x8 ram512x8_inst (	.RDATA(rdata),
							.RADDR(raddr),
							.RCLK(clk_sys),
							.RCLKE(read_en),
							.RE(read_en),
							.WADDR(waddr),
							.WCLK(clk_in),
							.WCLKE(write_en),
							.WDATA(wdata),
							.WE(write_en) );

assign sdo = rdata[0];
assign n_cs_out = n_cs_in;

endmodule