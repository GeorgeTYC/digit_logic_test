module secret_box(clk,key,but,r_led1,g_led1,b_led1,r_led2,g_led2,b_led2);
	input clk;
	input [7:0] key;
	input but;
	output reg r_led1,r_led2,g_led2,g_led1,b_led2,b_led1;

	reg [7:0] key1=8'b1111_0000;
	reg [7:0] key2=8'b0000_1111;
	reg [7:0] key_temp;

	reg con;
	wire but_lock;
	sw a1(.clk(clk),.key_in(but),.key_out(but_lock));

	always @(posedge but_lock) begin
		con<=~con;
	end

	

	always @(posedge clk) begin
		if(con==1) begin
			key_temp<=key1;
			r_led1<=1'b0;
			b_led1<=1'b1;
			g_led1<=1'b0;
		end
		else begin
			key_temp<=key2;
			r_led1<=1'b0;
			b_led1<=1'b0;
			g_led1<=1'b1;
		end
	end

	always @(posedge clk) begin
		if(key==key_temp) begin
			r_led2<=1'b1;
			b_led2<=1'b0;
			g_led2<=1'b0;
		end
		else begin
			r_led2<=1'b1;
			b_led2<=1'b0;
			g_led2<=1'b0;
		end
	end

endmodule

module sw(clk,key_in,key_out);
	input key_in;
	input clk;
	output reg key_out;
	reg [19:0]tcnt1;
	
	always @(posedge clk or negedge key_in)
	begin
	if(!key_in)tcnt1<=20'd0;
	else tcnt1<=tcnt1+1;
	end
	always @(posedge clk or negedge key_in)
	begin
	if(!key_in)key_out<=0;
		else if(tcnt1==20'hfffff)key_out<=key_in;
	end
endmodule