module a(clk,start,direction1,direction2,direction3,direction4,row,g_col,r_col);
	input clk;
	input start;
	input direction1;
	input direction2;
	input direction3;
	input direction4;

	output reg [7:0] row;
	output reg [7:0] g_col;
	output reg [7:0] r_col;

	reg [2:0] terminal_point_row=3'b000;
	reg [2:0] terminal_point_col=3'b000;
	reg [2:0] start_point_row=3'b110;	
	reg [2:0] start_point_col=3'b111;
	reg [5:0] start_point_1=6'b110_111;	
	reg [5:0] terminal_point_1=6'b000_000;
	reg [5:0] start_point_2=6'b111_110;
	reg [5:0] terminal_point_2=6'b001_111;

	reg [2:0] location_row_num;
	reg [2:0] location_col_num;


	wire start_lock;
	sw a1(.clk(clk),.sw(start),.lo_sw(start_lock));
	
	wire direction_lock1;
	wire direction_lock2;
	wire direction_lock3;
	wire direction_lock4;

	
	/*debounce m0(clk,rst,direction1,direction2,direction3,direction4,direction_lock1,direction_lock2,direction_lock3,direction_lock4);
	

	always @(posedge clk)	//瀹氫箟direction[0]涓哄悜涓婃帶鍒堕敭posedge direction_lock1 or posedge direction_lock2 or posedge direction_lock3 or posedge direction_lock4 
	begin

	if(start_lock==1) begin
		step_cnt<=7'b0000000;
		location_row_num<=start_point_row;
		location_col_num<=start_point_col;
	end
	if(direction_lock1||direction_lock2||direction_lock3||direction_lock4)	begin
		if(location_row_num!=terminal_point_row||location_col_num!=terminal_point_col)
		begin
			if(location_row_num<7 &&direction_lock1)
					begin
						if(!map_row[location_row_num+1][location_col_num])
							begin
								step_cnt<=step_cnt+1;
								location_row_num<=location_row_num+1;
							end
					end
				if(location_row_num>0&&direction_lock2)
					begin
						if(!map_row[location_row_num-1][location_col_num])
							begin
								step_cnt<=step_cnt+1;
								location_row_num<=location_row_num-1;
							end
					end
		end
		if(location_col_num!=terminal_point_col||location_row_num!=terminal_point_row)
			begin
				if(location_col_num>0&&direction_lock3)
					begin
						if(!map_row[location_row_num][location_col_num-1])
							begin
								step_cnt<=step_cnt+1;
								location_col_num<=location_col_num-1;
							end
					end
				if(location_col_num<7&&direction_lock4)
					begin
						if(!map_row[location_row_num][location_col_num+1])
							begin
								step_cnt<=step_cnt+1;
								location_col_num<=location_col_num+1;
							end
					end
			end
	
	end

	end*/
	//debounce debounce1(clk,rst,direction1,direction2,direction3,direction4,direction_lock1,direction_lock2,direction_lock3,direction_lock4);
	sw c1(clk,direction1,direction_lock1);
	sw c2(clk,direction2,direction_lock2);
	sw c3(clk,direction3,direction_lock3);
	sw c4(clk,direction4,direction_lock4);

always @(posedge clk or posedge start_lock)
	begin
		if(start_lock)
			begin
				location_row_num<=start_point_row;
				location_col_num<=start_point_col;
			end
	   else if(location_row_num!=terminal_point_row||location_col_num!=terminal_point_col) begin

	   if(location_row_num<7 &&direction_lock1)
			begin
								location_row_num<=location_row_num+1;
			end
		else if(location_row_num>0&&direction_lock2)
			begin
								location_row_num<=location_row_num-1;
							
			end
		else if(location_col_num>0&&direction_lock3)
			begin
							
								location_col_num<=location_col_num-1;
							
			end
		else if(location_col_num<7&&direction_lock4)
			begin
				
								location_col_num<=location_col_num+1;
			end
		end
	end

	reg [31:0] count=32'd0;
	reg clk_1kHz;

	always @(posedge clk) begin  //1k频率的时钟
		if(count==50000) begin
			count<=32'd0;
			clk_1kHz<=~clk_1kHz;
		end
		else begin
			count<=count+1;
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
		row<=8'b1111_1110;
	end
	4'h1: begin
		row<=8'b1111_1101;
	end
	4'h2: begin
		row<=8'b1111_1011;
	end
	4'h3: begin
		row<=8'b1111_0111;
	end
	4'h4: begin
		row<=8'b1110_1111;
	end
	4'h5: begin
		row<=8'b1101_1111;
	end
	4'h6: begin
		row<=8'b1011_1111;
	end
	4'h7: begin
		row<=8'b0111_1111;
	end
	endcase
	end
	always @(posedge clk_1kHz) begin
		if(row_num==location_row_num) begin
			case(location_col_num)
				3'd0:g_col<=8'b0000_0001;
				3'd1:g_col<=8'b0000_0010;
				3'd2:g_col<=8'b0000_0100;
				3'd3:g_col<=8'b0000_1000;
				3'd4:g_col<=8'b0001_0000;
				3'd5:g_col<=8'b0010_0000;
				3'd6:g_col<=8'b0100_0000;
				3'd7:g_col<=8'b1000_0000;
			endcase
		end
		if((row_num)!=location_row_num)
		begin
			g_col<=8'b0000_0000;
		end
	end

endmodule

module sw(sw,lo_sw,clk);
input sw;
input clk;
output reg lo_sw;
reg [31:0] tcnt;
always @(posedge clk)
begin
	if(!sw)tcnt<=20'd0;
	else tcnt<=tcnt+1;
end
always @(posedge clk)
begin
	if(!sw)lo_sw<=0;
	else if(tcnt==32'h3fffff)lo_sw<=sw;
end
endmodule

