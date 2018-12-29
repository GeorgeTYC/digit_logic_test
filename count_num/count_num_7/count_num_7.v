module count_num_7(clk,key,res,digit_seg,digit_con);
	input clk;
	input key;
	input res;
	output reg[7:0] digit_seg;
	output [1:0]digit_con;
	
	reg[6:0] count_num=7'b0000000;
	
	reg[31:0] div_count;
	reg digit;
	
	reg[3:0] tens=4'b0000;
	reg[3:0] ones=4'b0000;
	reg lo_sw,lo_rst;
	reg [19:0]tcnt1,tcnt2;
	always @(posedge clk or negedge res)
	begin
		if(!res)tcnt1<=20'd0;
		else tcnt1<=tcnt1+1;
	end
	always @(posedge clk or negedge res)
	begin
		if(!res)lo_rst<=0;
		else if(tcnt1==20'hfffff)lo_rst<=res;
	end
	always @(posedge clk or negedge key)
	begin
		if(!key)tcnt2<=20'd0;
		else tcnt2<=tcnt2+1;
	end
	always @(posedge clk or negedge key)
	begin
		if(!key)lo_sw<=0;
		else if(tcnt2==20'hfffff)lo_sw<=key;
	end
	always @(posedge clk)div_count<=div_count+1;
	always @(posedge lo_rst,posedge lo_sw)
	begin
		if(lo_rst)
			count_num = 0;   
		else if(lo_sw)
        count_num = count_num + 1;
	end

	always @(posedge clk)
		div_count=div_count+1;
	
	always @(posedge div_count[10])
		digit<=~digit;
		
	assign digit_con={digit,~digit};
	
	always @(posedge lo_sw or posedge lo_rst)
		begin
		if(lo_sw==1)
		count_num=count_num+1;
		if(lo_rst==1)
		count_num=0;
		end
	
	integer i;
	always @(posedge count_num)
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

module debounce(clk,key_in,key_out);
	parameter SAMPLE_TIME = 4;
	input clk;
	input key_in;
	output key_out;

	reg [21:0] count_low;
	reg [21:0] count_high;

	reg key_out_reg;

	always @(posedge clk)
	if(key_in ==1'b0)
	count_low <= count_low + 1;
	else
	count_low <= 0;

	always @(posedge clk)
	if(key_in ==1'b1)
	count_high <= count_high + 1;
	else
	count_high <= 0;

	always @(posedge clk)
	if(count_high == SAMPLE_TIME)
	key_out_reg <= 1;
	else if(count_low == SAMPLE_TIME)
	key_out_reg <= 0;

	assign key_out = key_out_reg;
	endmodule 

	