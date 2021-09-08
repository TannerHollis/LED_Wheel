module spi_out (n_cs, clk_sys, clk_spi, send, waddr, sdo, raddr, rdata);

	parameter addr_width = 9;
	parameter data_width = 8;
	
	parameter num_devices = 20;
	parameter n_LEDS = 320;
	
	input n_cs, clk_sys, clk_spi, send;
	input [data_width - 1 : 0] rdata
	output [num_devices - 1 : 0] sdo;
	output [15 : 0] raddr, start_addr;
	
	reg [2 : 0] state;
	reg [3 : 0] led_cnt;
	reg [4 : 0] dev_cnt;
	reg [data_width*2 - 1 : 0] led_data [num_devices][2];
	
	reg send_en;
	
	always @(posedge clk_sys or posedge n_cs)
	begin
		if (n_cs)
		begin
			start_addr <= 0;
			raddr <= 0;
			state <= 0;
			led_cnt <= 0;
			dev_cnt <= 0;
			send_en <= 0;
		end
		else
		begin
			case (state)
				0 : 
					begin
						if (send == 1)
						begin
							start_addr <= waddr - (n_LEDS - 1);
							raddr <= waddr - (n_LEDS - 1);
							state <= 1;
							led_cnt <= 0;
						end
					end
				1 : 
					begin
						if (dev_cnt == num_devices - 1)
						begin
							led_cnt <= led_cnt + 1;
							raddr <= start_addr + led_cnt + 1;
							dev_cnt <= 0;
							send_en <= 1;
							state <= 2;
						end
						else
						begin
							led_data[ data_width - 1 : 0][dev_cnt][0] = rdata;						
							dev_cnt <= dev_cnt + 1;
							raddr <= raddr + 16;
						end
					end
				2 : 
					begin
						genvar i;
						
						generate
							for (i = 0; i < num_devices; i = i + 1)
							begin
								led_data[ data_width - 1 : 0][i][1] = led_data[ data_width - 1 : 0][i][0];
								led_data[ data_width*2 - 1 : data_width][i][1] = 8'h08 + led_cnt;
							end
						endgenerate
					
						if (led_cnt == 16)
							state <= 0;
						else
							state <= 1;
					end
			endcase
			
		end
	end
	
	genvar i;
	
	
	
	reg send_done;
	
	always @(posedge clk_sys)
	begin
		if (n_cs)
			send_done <= 0;
		if(send_en && !send_done)
		begin
			
		end
	end

endmodule