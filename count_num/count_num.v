module count_num(clk,res,key,digit_seg);
	input clk;
	input res;
	input key;
	output reg[7:0]digit_seg;
	
	wire [6:0]binary=7'd0;
	wire [3:0]ten=4'd0;
	wire [3:0]one=4'd0;
	
	reg [31:0]div_count;
	reg digit=1'b0;
	
	wire [1:0]digit_con;
	wire key_pulse;
	
	always @(posedge clk)
		begin
			if(res==1)
		begin
		binary=7'b0;
		end
		div_count=div_count+1;
		end
	
	 debounce u1 (.clk (clk),.rst (rst),.key (key),.key_pulse (key_pulse));

	