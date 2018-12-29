module count_num_4(clk,key,res,digit_seg,digit_con);
	input clk;
	input key;
	input res;
	output reg[7:0] digit_seg;
	output[1:0] digit_con;
	
	reg[7:0] count_num=8'b0000000;
	
	reg[31:0] div_count;
	reg digit;
	reg lo_key,lo_res;
	reg [19:0]tcnt1,tcnt2;
	
	always @(posedge clk or negedge res)	//按键消抖
	begin
	if(!res)tcnt1<=20'd0;
	else tcnt1<=tcnt1+1;
	end
	always @(posedge clk or negedge res)
	begin
	if(!res)lo_res<=0;
	else if(tcnt1==20'hfffff)lo_res<=res;
	end
	always @(posedge clk or negedge key)
	begin
	if(!key)tcnt2<=20'd0;
	else tcnt2<=tcnt2+1;
	end
	always @(posedge clk or negedge key)
	begin
	if(!key)lo_key<=0;
	else if(tcnt2==20'hfffff)lo_key<=key;
	end

	always @(posedge clk)
		div_count<=div_count+1;
	
	always @(posedge div_count[10])
		digit<=~digit;
		
	assign digit_con={digit,~digit};
	
	always @(posedge lo_key or posedge lo_res)
		begin
		if(lo_res)
		count_num<=0;
		else if(lo_key)
		count_num<=count_num+1;
		
		end
		
	reg[3:0]ten=4'd0;
	reg[3:0]one=4'd0;
	integer i;
	
	always @(count_num)  //十进制转化BCD码
		begin
		ten=4'd0;
		one=4'd0;
		
		for(i=6;i>=0;i=i-1)
		begin
		if(ten>4)
		ten=ten+4'd3;
		if(one>4)
		one=one+4'd3;
		
		ten=ten<<1;
		ten[0]=one[3];
		one=one<<1;
		one[0]=count_num[i];
		end
		end
		
	always @(posedge div_count[10])
		begin
		if(digit)
		begin
			case(ten)
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
		if(~digit)
		begin
			case(one)
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
	/*wire[3:0] digit_sig;
	assign digit_sig=digit?count_num[7:4]:count_num[3:0];
	always @(posedge div_count[10])     
	begin
    case (digit_sig)
        4'h0:  digit_seg <= 8'b11111100; //显示0~F
        4'h1:  digit_seg <= 8'b01100000;  
        4'h2:  digit_seg <= 8'b11011010;
        4'h3:  digit_seg <= 8'b11110010;
        4'h4:  digit_seg <= 8'b01100110;
        4'h5:  digit_seg <= 8'b10110110;
        4'h6:  digit_seg <= 8'b10111110;
        4'h7:  digit_seg <= 8'b11100000;
        4'h8:  digit_seg <= 8'b11111110;
        4'h9:  digit_seg <= 8'b11110110;
		  4'hA:  digit_seg <= 8'b11101110;
        4'hB:  digit_seg <= 8'b00111110;
        4'hC:  digit_seg <= 8'b10011100;
        4'hD:  digit_seg <= 8'b01111010;
        4'hE:  digit_seg <= 8'b10011110;
        4'hF:  digit_seg <= 8'b10001110;
		  endcase
	end*/
	
	endmodule

