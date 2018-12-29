module count_num_5(clk,key,res,digit_seg);
	input clk;
	input key;
	input res;
	output reg[7:0] digit_seg;
	
	wire key_pulse;
	wire res_pulse;
	reg[6:0] count_num=7'b0000000;
	
	reg[31:0] div_count;
	reg digit;
	wire[1:0] digit_con;
	
	reg[3:0] tens=4'b0000;
	reg[3:0] ones=4'b0000;
	always @(posedge clk)
		div_count=div_count+1;
	
	always @(posedge div_count[10])
		digit<=~digit;
		
	assign digit_con={digit,~digit};
	
	always @(posedge key_pulse or posedge res_pulse)
		begin
		if(key_pulse==1)
		begin
		count_num=count_num+1;
		end
		if(res_pulse==1)
		begin
		count_num=0;
		end
		end
	debounce u1(.clk(clk),.key(key),.led(key_pulse));
	debounce u2(.clk(clk),.key(res),.led(res_pulse));
	
	integer i;
	always @(posedge clk)
		begin
		tens=4'b0000;
		ones=4'b0000;
		
		for(i=6;i>=0;i=i-1)
		begin
			if(tens>=5)
			tens=tens+3;
			if(ones>=5)
			ones=ones+3;
			
			tens=tens<<1;
			tens[0]=ones[3];
			ones=ones<<1;
			ones[0]=count_num[i];
		end
	end
	
	always @(posedge div_count[10])
		begin
		if(digit_con==2'b10)
		begin
			case(tens)
			4'd0:digit_seg<=8'b11111100;
			4'd1:digit_seg<=8'b01100000;
			4'd2:digit_seg<=8'b11011010;	
			4'd3:digit_seg<=8'b11110010;
			4'd4:digit_seg<=8'b01100110;
			4'd5:digit_seg<=8'b10110110;
			4'd6:digit_seg<=8'b10111110;
			4'd7:digit_seg<=8'b11100000;
			4'd8:digit_seg<=8'b11111110;
			4'd9:digit_seg<=8'b11110110;
			endcase
		end
		if(digit_con==2'b01)
		begin
			case(ones)
			4'd0:digit_seg<=8'b11111100;
			4'd1:digit_seg<=8'b01100000;
			4'd2:digit_seg<=8'b11011010;	
			4'd3:digit_seg<=8'b11110010;
			4'd4:digit_seg<=8'b01100110;
			4'd5:digit_seg<=8'b10110110;
			4'd6:digit_seg<=8'b10111110;
			4'd7:digit_seg<=8'b11100000;
			4'd8:digit_seg<=8'b11111110;
			4'd9:digit_seg<=8'b11110110;
			endcase
		end
		
		end
	endmodule


module debounce(clk, key, led);
input key,clk;
 
output led;
 
reg  led;
reg sysclk;
reg [18:0]cnt_20ms;
 
always @(posedge clk)
begin
    cnt_20ms <= cnt_20ms + 1;
if(cnt_20ms == 19'd500000 )
    sysclk <= ~sysclk;
end
 
reg key_low;
 
always @( posedge sysclk)
begin
key_low <= key; 
end
 
reg key_low_r; //按键值锁存一个时钟周期，以判断按键是否按下
 
always @( posedge clk)
begin
 
key_low_r <= key_low; 
end
 
wire led_ctrl;
assign led_ctrl = key_low_r & (!key_low);
 
always @( posedge clk)
begin
if( led_ctrl == 1)
led <= ~led;
end
 
endmodule