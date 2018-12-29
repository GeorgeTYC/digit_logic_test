module test3(clk,rst,rst_num,seg,seg_on);
	input clk;
	input rst;//重置按钮
	input rst_num;//按键计数
	output reg[7:0] seg;//八段数码管
	output reg[1:0] seg_on;//切换数码管
	reg[7:0] seg_num[15:0];//数码管数字
	reg onMSChange;//ms级时间
	reg[7:0] sum;
	reg[4:0] shake_cnt;
	reg[16:0] clk_count;	
	reg[16:0] cnt_num;
	reg mode;
	initial
		begin
		seg_num[0] <= 8'b11111100;
		seg_num[1] <= 8'b01100000;
		seg_num[2] <= 8'b11011010;
		seg_num[3] <= 8'b11110010;
		seg_num[4] <= 8'b01100110;
		seg_num[5] <= 8'b10110110;
		seg_num[6] <= 8'b10111110;
		seg_num[7] <= 8'b11100000;
		seg_num[8] <= 8'b11111110;
		seg_num[9] <= 8'b11110110;
		seg_num[10] <= 8'b11101110;
		seg_num[11] <= 8'b00111110;
		seg_num[12] <= 8'b10011100;
		seg_num[13] <= 8'b01111010;
		seg_num[14] <= 8'b10011110;
		seg_num[15] <= 8'b10001110;
		seg <= 8'b0;
		seg_on <= 2'b10;
		clk_count <= 0;
		onMSChange <= 0;
		//on10MSChange <= 0;
		//MSclk_count <= 0;
		shake_cnt <= 0;
		sum <= 8'd0;
		cnt_num <= 13000;
		mode <= 0;
		end
		
	always@(posedge clk)
		
			begin
			if(clk_count >= 44800)
				begin
				clk_count <= 0;
				onMSChange <= 1;
				end
			else
				begin
				clk_count <= clk_count + 1;
				onMSChange <= 0;
				end
			end

	always@(posedge onMSChange)
		begin
		//延时10ms检测，从而按键消抖正确计数
			if(rst_num)
				begin
				if(shake_cnt <= 10)
					begin
					shake_cnt <= shake_cnt + 1;
					end
				if(shake_cnt == 10)
					begin
					sum <= sum + 8'd1;
					end
				end
			else
				begin
				shake_cnt <= 0;
				end
		if(sum[3:0] >= 4'd10)
			begin
			sum[7:4] <= sum[7:4] + 1;
			sum[3:0] <= sum[3:0] - 10;
			end
		if(sum[7:4] == 4'd9)
			begin
			sum <= 8'd0;
			end
		if(rst)
			begin
			sum <= 8'd0;
			end
		
		
			//seg
			if(seg_on == 2'b01)
				begin
				seg_on <= 2'b10;
				end
			else
				begin
				seg_on <= seg_on << 1 | 1;
				end
			
			
				if(seg_on == 2'b10)
					begin
					seg <= seg_num[sum[7:4]];
					end
				else if(seg_on == 2'b01)
					begin
					seg <= seg_num[sum[3:0]];
					end
		
		end
endmodule
