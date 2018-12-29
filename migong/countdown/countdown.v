module countdown(clk,but,one,ten,digit_con,digit_seg0);		
		input but;
		input clk;
		output reg[3:0] ten;
		output reg[3:0] one;
		output reg[7:0] digit_con;
		output reg[7:0] digit_seg0;
		reg [31:0] time_count=32'd0;
		reg [4:0] time1=5'd30;

		/*always @(posedge but or posedge a)
		begin 
			if(a==1)begin
				time1<=time1-1;
			end
			else begin
				time1<=5'd30;
			end

		end*/
		
		always @(posedge div_clk or posedge but) begin
			if(but) time1<=5'd30;
			else time1<=time1-1;
		end
		 reg div_clk;
		always @(posedge clk)
			begin
			if(time1!=0) begin
			if(time_count==25000000)
			begin
				time_count<=32'd0;
				div_clk<=~div_clk;
			end
			else begin
			time_count<=time_count+1;
			end
			end
			end
		
			integer i;
	
			always @(posedge clk)
			begin
				ten=4'd0;
				one=4'd0;
		
				for(i=4;i>=0;i=i-1)
				begin
					if(ten>4)
						ten=ten+4'd3;
					if(one>4)
						one=one+4'd3;
					ten=ten<<1;
					ten[0]=one[3];
					one=one<<1;
					one[0]=time1[i];
				end
			end

		reg clk_1kHz;
		reg [31:0] cnt=32'd0;
		always @(posedge clk) begin
			if(cnt==50000) begin
				cnt<=32'd0;
				clk_1kHz=~clk_1kHz;
			end
			else begin
				cnt<=cnt+1;
			end
		end

	reg [3:0] row_num=4'b0000; 
	
	always @(posedge clk_1kHz) begin
	if(row_num!=4'b0111) begin
		row_num<=row_num+1;
	end
	else row_num<=4'b0000;
	end

	always @(posedge clk_1kHz) begin
	case(row_num)
	4'h0: begin
		digit_con<=8'b1111_1110;
	end
	4'h1: begin
		digit_con<=8'b1111_1101;
	end
	4'h2: begin
		digit_con<=8'b1111_1011;
	end
	4'h3: begin
		digit_con<=8'b1111_0111;
	end
	4'h4: begin
		digit_con<=8'b1110_1111;
	end
	4'h5: begin
		digit_con<=8'b1101_1111;
	end
	4'h6: begin
		digit_con<=8'b1011_1111;
	end
	4'h7: begin
		digit_con<=8'b0111_1111;
	end
	endcase
	
	
end

	always @(posedge clk_1kHz) begin
		if(row_num==1) begin
			case(ten)
			4'd0:digit_seg0<=8'b11111100;
			4'd1:digit_seg0<=8'b01100000;
			4'd2:digit_seg0<=8'b11011010;	
			4'd3:digit_seg0<=8'b11110010;
			4'd4:digit_seg0<=8'b01100110;
			4'd5:digit_seg0<=8'b10110110;
			4'd6:digit_seg0<=8'b10111110;
			4'd7:digit_seg0<=8'b11100000;
			4'd8:digit_seg0<=8'b11111110;
			4'd9:digit_seg0<=8'b11110110;
		endcase
		end
		if(row_num==0) begin
		case(one)
			4'd0:digit_seg0<=8'b11111100;
			4'd1:digit_seg0<=8'b01100000;
			4'd2:digit_seg0<=8'b11011010;	
			4'd3:digit_seg0<=8'b11110010;
			4'd4:digit_seg0<=8'b01100110;
			4'd5:digit_seg0<=8'b10110110;
			4'd6:digit_seg0<=8'b10111110;
			4'd7:digit_seg0<=8'b11100000;
			4'd8:digit_seg0<=8'b11111110;
			4'd9:digit_seg0<=8'b11110110;
		endcase
		end
		if(row_num==2||row_num==3||row_num==4||row_num==5||row_num==6||row_num==7) begin
			digit_seg0<=8'b0000_0000;
			end
		
		end

		

endmodule				