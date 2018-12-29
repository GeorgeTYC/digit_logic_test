module count_num_6(clk,key,res,digit_seg);
	input clk;
	input key;
	input res;
	output reg[7:0] digit_seg;
	
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
	
	always @(posedge key)
		begin
		count_num=count_num+1;
		end
		
	always @(posedge res)
		begin
		count_num=0;
		end
	
	integer i;
	always @(posedge count_num[0])
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