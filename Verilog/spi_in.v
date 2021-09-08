module spi_in(clk_sys, clk_spi, sdi, n_cs, d_out, write_en, waddr, send, settings);

	parameter n_LEDS = 320;
	parameter addr_width = 9;
	parameter data_width = 8;

	input clk_spi, clk_sys, sdi, n_cs;
	output reg [15 : 0] waddr;
	output reg [data_width - 1 : 0] d_out;
	output reg [15 : 0] settings = 0;
	output write_en, send;

	reg [15 : 0] start_addr;
	reg [data_width - 1 : 0] data;
	reg [data_width - 1 : 0] instruction;	//Instructions 0x00 = load to RAM
											//Instructions 0x01 = load to RAM & send to LED driver
											//Instructions 0x02 = send to LED driver
											//Instructions 0x03 = program drivers
											//Instructions 0xff = store settings
											//Settings MSB = setting, LSB = Value
	reg [2 : 0] bit_cnt = 0;
	reg [15 : 0] byte_cnt = 0;
	reg write_flag_spi = 1'b0;

	always @(posedge clk_spi or posedge n_cs)
	begin
		if (n_cs)
		begin
			waddr 		<= 0;
			d_out 		<= 0;
			bit_cnt 	<= 0;
			byte_cnt 	<= 0;
			start_addr 	<= 0;
			write_flag_spi 	<= 1'b0;
		end
		else
		begin
			if (bit_cnt == 7)
			begin
				bit_cnt <= 0;
				byte_cnt <= byte_cnt + 1;
			end
			else
			begin
				bit_cnt <= bit_cnt + 1;
				
				if (bit_cnt == 0)
				begin
					if ((instruction == 8'h00 || instruction == 8'h01) && byte_cnt > 3 && byte_cnt <= n_LEDS + 3)
					begin
						d_out <= data;
						write_flag_spi <= 1'b1;
					end
					
					if ((instruction == 8'h00 || instruction == 8'h01) && byte_cnt == 2)
						start_addr[15 : 8] <= data;
						
					if ((instruction == 8'h00 || instruction == 8'h01) && byte_cnt == 3)
					begin
						start_addr[ 7 : 0] <= data;
						waddr <= {start_addr[15 : 8], data};
					end

					if (byte_cnt == 1)
						instruction <= data;
					
					if (instruction == 8'hff && byte_cnt == 2)
						settings[15 : 8] <= data;
					
					if (instruction == 8'hff && byte_cnt == 3)
						settings[7 : 0] <= data;
					
				end
			end
			
			if (write_flag_spi)
			begin
				write_flag_spi <= 1'b0;
				waddr <= waddr + 1;
			end
			
			data <= {data[data_width - 2 : 0], sdi};
		end
	end

	reg write_flag_sys = 1'b0;
	
	always @(posedge clk_sys or posedge n_cs)
	begin
		if(n_cs)
			write_flag_sys <= 1'b0;
		else
		begin
			if(write_flag_sys != write_flag_spi)
				write_flag_sys <= write_flag_spi;
		end
	end

	assign write_en = write_flag_sys == 0 && write_flag_spi == 1;
	assign send = (instruction == 8'h01 && byte_cnt == n_LEDS + 3) || (instruction == 8'h02 && byte_cnt == 1);

endmodule