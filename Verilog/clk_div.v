module clk_div(clk_in, clk_out, div, nreset);

input clk_in;
input [3 : 0] div;
output reg clk_out = 1'b0;

reg [3 : 0] cnt;

always @(posedge clk_in)
begin
	if (nreset)
	begin
		cnt <= 0;
		clk_out <= 0;
	end	else
	begin
		if(cnt == div)
		begin
			clk_out <= !clk_out;
			cnt <= 0;
		end else
		begin
			cnt <= cnt + 1;
		end
	end
end

endmodule