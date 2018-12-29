module countdown(clk,but,digit_con,digit_seg0,stop);		
		input but;
		input clk;
		input stop;
		output [1:0] digit_con;
		output reg [7:0] digit_seg0;
		wire [3:0] ten;
		wire [3:0] one;
		reg[4:0] time1=5'd30;
		reg [31:0] time_count=32'd0;
		
		always @(posedge div_clk or posedge but) begin
			if(but==1) time1<=5'd24;
			else time1<=time1-1;
		end
		reg div_clk;
		always @(posedge clk)
			begin
			if(time1!=0&&stop==0) begin
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
		
	two_ten t1(.clk(clk),.num(time1),.ten(ten),.one(one));

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
	reg rev;
	always @(posedge clk_1kHz) begin
		rev<=~rev;
	end

	assign digit_con={rev,~rev};
	always @(posedge clk_1kHz) begin
		if(rev==1) begin
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

		else  if(rev==0) begin
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
		
		end
		

endmodule				


module two_ten(clk,num,ten,one);
input [4:0] num;
input clk;
output reg [3:0] ten;
output reg [3:0] one;

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
					one[0]=num[i];
				end
			end
endmodule