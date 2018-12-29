module led(clk, rst_n, r, g, b);
input clk;
input rst_n;
output r, g, b;

reg [15:0] wheel_pos;
reg [7:0] r_buf,g_buf,b_buf;
reg [31:0] div_buffer;
wire clk;
reg div_clk;

pwm pwm_r(r, r_buf, clk);
pwm pwm_g(g, g_buf, clk);
pwm pwm_b(b, b_buf, clk);

always@(posedge clk)//改变频率
begin
	if(div_buffer < 50000)
	begin
		div_buffer <= div_buffer + 1;
	end
	else
	begin
		div_clk <= ~div_clk;
		div_buffer <= 0;
	end
end

always@(posedge div_clk)
begin
	if(wheel_pos < 765)
		wheel_pos <= wheel_pos + 1;
	else
		wheel_pos <= 0;
	if(wheel_pos < 255)
	begin
		r_buf <= 255 - wheel_pos;
		g_buf <= 0;
		b_buf <= wheel_pos;
	end
	else if(wheel_pos < 510)
	begin
		r_buf <= 0;
		g_buf <= (wheel_pos - 255);
		b_buf <= 255 - (wheel_pos - 255);
	end
	else
	begin
		r_buf <= (wheel_pos - 510);
		g_buf <= 255 - (wheel_pos - 510);
		b_buf <= 0;
	end
end
endmodule

module pwm(out, duty, clk);
output reg out;
input [7:0] duty;
input clk;
reg [7:0] buffer;

always@(posedge clk)
begin
	buffer <= buffer + 1;
	if(buffer < duty)
	begin
		out <= 0;
	end
	else
	begin
		out <= 1;
	end
end
endmodule
