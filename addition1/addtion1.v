module addtion1(clk,cina,cinb,cout,term,digit_seg,digit_con,ci);
	input ci;
	input clk;
	input [3:0]cina;
	input [3:0]cinb;
	output [4:0]cout;
	output [2:0]term;
	output [1:0]digit_con;
	output reg[7:0]digit_seg;
	reg [31:0]div_count;
	
	always @(posedge clk)
		begin
		div_count<=div_count+1;
		end
	
		add f1(.a(cina[0]),.b(cinb[0]),.fro(ci),.Cout(term[0]),.sum(cout[0]));
		add f2(.a(cina[1]),.b(cinb[1]),.fro(term[0]),.Cout(term[1]),.sum(cout[1]));
		add f3(.a(cina[2]),.b(cinb[2]),.fro(term[1]),.Cout(term[2]),.sum(cout[2]));
		add f4(.a(cina[3]),.b(cinb[3]),.fro(term[2]),.Cout(top),.sum(cout[3]));
		
	assign cout[4]=top;
	
	
	reg digit=1'b0;
	always @(posedge div_count[10])
		begin
		digit<=~digit;
		end
		
	assign digit_con={digit,~digit};
	
	always @(posedge div_count[10])
		begin
			case(cout)
			5'd0:digit_seg<=8'b11111100;
			5'd1:
				begin
					if(digit_con==2'b10)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b01)
					digit_seg<=8'b11111100;
				end
			5'd2:
				begin
					if(digit_con==2'b10)
					digit_seg<=8'b11011010;		
					else if(digit_con==2'b01)
					digit_seg<=8'b11111100;
				end
			5'd3:
				begin
					if(digit_con==2'b10)
					digit_seg<=8'b11110010;
					else if(digit_con==2'b01)
					digit_seg<=8'b11111100;
				end
			5'd4:
			begin
				if(digit_con==2'b10)
				digit_seg<=8'b01100110;
				else if(digit_con==2'b01)
				digit_seg<=8'b11111100;
			end
			5'd5:
				begin
					if(digit_con==2'b10)
					digit_seg<=8'b10110110;
					else if(digit_con==2'b01)
					digit_seg<=8'b11111100;
				end
			5'd6:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b10111110;
					else if(digit_con==2'b10)
					digit_seg<=8'b11111100;
				end
			5'd7:
				begin
					if(digit_con==2'b10)
					digit_seg<=8'b11100000;
					else if(digit_con==2'b01)
					digit_seg<=8'b11111100;
				end
			5'd8:
				begin
					if(digit_con==2'b10)
					digit_seg<=8'b11111110;
					else if(digit_con==2'b01)
					digit_seg<=8'b11111100;
				end
			5'd9:
				begin
					if(digit_con==2'b10)
					digit_seg<=8'b11110110;
					else if(digit_con==2'b01)
					digit_seg<=8'b11111100;
				end
			5'd10:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b11111100;
				end
			5'd11:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b01100000;
				end
			5'd12:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b11011010;
				end
			5'd13:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b11110010;
				end
			5'd14:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b01100110;
				end
			5'd15:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b10110110;
				end
			5'd16:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b10111110;
				end
			5'd17:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b11100000;
				end
			5'd18:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b11111110;
				end
			5'd19:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b01100000;
					else if(digit_con==2'b10)
					digit_seg<=8'b11110110;
				end
			5'd20:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11111100;
				end
			5'd21:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b01100000;
				end
			5'd22:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11011010;
				end
			5'd23:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11110010;
				end
			5'd24:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b01100110;
				end
			5'd25:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b10110110;
				end
			5'd26:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b10111110;
				end
			5'd27:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11100000;
				end
			5'd28:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11111110;
				end
			5'd29:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11011010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11110110;
				end
			5'd30:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11110010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11111100;
				end
			5'd31:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11110010;
					else if(digit_con==2'b10)
					digit_seg<=8'b01100000;
				end
			5'd32:
				begin
					if(digit_con==2'b01)
					digit_seg<=8'b11110010;
					else if(digit_con==2'b10)
					digit_seg<=8'b11011010;
				end
			endcase
		end
endmodule

module add(a,b,fro,Cout,sum);
	input a;
	input b;
	input fro;
	output Cout;
	output sum;
	
	assign {Cout,sum}=a+b+fro;
endmodule
