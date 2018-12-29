module count(clk,res,cou,digit_seg);
	input clk;
	input res;
	input cou;
	output reg[7:0]digit_seg;
	reg [3:0]ten=4'd0;
	reg [3:0]one=4'd0;
	reg [6:0]binary=7'b0;
	reg [31:0]div_count;
	reg digit=1'b0;
	wire[1:0] digit_con;
	
	always @(posedge clk)
		begin
		if(res==1)
		begin
		binary=7'b0;
		end
		div_count=div_count+1;
		end
		
	always @(posedge div_count[10])
		begin
		digit=~digit;
		end
		
	assign digit_con={digit,~digit};
	
	always @(posedge count)
		begin
		binary=binary+1;
		end
	
	always @(posedge binary)
	begin
		reg [2:0]i;
		for(i=3'd6;i>=0;i=i-1)
		begin
			if(ten>=5)
			ten=ten+3;
			if(one>=5)
			one=one+3;
			
			ten=ten<<1;
			ten[0]=one[3];
			one=one<<1;
			one[0]=binary[i];
		end
	end
	always @(posedge div_count[10])
		begin
		if(digit_con==2'b10)
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
		if(digit_con==2'b01)
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
	
endmodule

			
	
	
	
	
	