module migong(clk,res,self_exa,start,change_map,direction,digit_seg0,digit_con,r_col,g_col,row);
	input clk;
	input res;
	input [3:0] direction;
	input start;
	input change_map;
	input self_exa;	

	output reg[7:0] digit_seg0;
	output reg[7:0] digit_con;	
	output reg[7:0] r_col;
	output reg[7:0] g_col;
	output reg[7:0] row;
	wire [4:0] time2;
	

	reg [7:0] map_row [7:0];
	reg [7:0] map_row_1 [7:0];
	reg [7:0] map_row_2 [7:0];

	reg [6:0] step_cnt=7'b0000001;
	
	initial
	begin
	map_row_1[0]=8'b1111_1000;
	map_row_1[1]=8'b1000_0011;
	map_row_1[2]=8'b1011_1111;
	map_row_1[3]=8'b1010_0001;
	map_row_1[4]=8'b1000_1101;
	map_row_1[5]=8'b1111_1101;
	map_row_1[6]=8'b0000_0001;
	map_row_1[7]=8'b1111_1111;

	map_row_2[0]=8'b1111_1111;
	map_row_2[1]=8'b0000_0101;
	map_row_2[2]=8'b1001_0011;
	map_row_2[3]=8'b1010_1001;
	map_row_2[4]=8'b1010_0101;
	map_row_2[5]=8'b1110_1101;
	map_row_2[6]=8'b1000_0001;
	map_row_2[7]=8'b1011_1111;
	end

	reg [2:0] terminal_point_row;
	reg [2:0] terminal_point_col;
	reg [2:0] start_point_row;	
	reg [2:0] start_point_col;
	reg [5:0] start_point_1=6'b110_111;	
	reg [5:0] terminal_point_1=6'b000_000;
	reg [5:0] start_point_2=6'b111_110;
	reg [5:0] terminal_point_2=6'b001_111;
	
	reg [2:0] location_row_num;
	reg [2:0] location_col_num;

	
	
	always @(posedge clk) begin
		if(start==1&&change_map==0) begin
			map_row[0]=map_row_1[0];
			map_row[1]=map_row_1[1];
			map_row[2]=map_row_1[2];
			map_row[3]=map_row_1[3];
			map_row[4]=map_row_1[4];
			map_row[5]=map_row_1[5];
			map_row[6]=map_row_1[6];
			map_row[7]=map_row_1[7];
			start_point_row=start_point_1[5:3];
			start_point_col=start_point_1[2:0];
			terminal_point_row=terminal_point_1[5:3];
			terminal_point_col=terminal_point_1[2:0];
		end
		else if(start==1&&change_map==1) begin
			map_row[0]=map_row_2[0];
			map_row[1]=map_row_2[1];
			map_row[2]=map_row_2[2];
			map_row[3]=map_row_2[3];
			map_row[4]=map_row_2[4];
			map_row[5]=map_row_2[5];
			map_row[6]=map_row_2[6];
			map_row[7]=map_row_2[7];
			start_point_row=start_point_2[5:3];
			start_point_col=start_point_2[2:0];
			terminal_point_row=terminal_point_2[5:3];
			terminal_point_col=terminal_point_2[2:0];
		end
	end

	wire res_lock;
	debounce m4(.clk(clk),.key_in(res),.key_out(res_lock));
	debounce1 m5(clk,res,direction[0],direction[1],direction[2],direction[3],direction_lock[0],direction_lock[1],direction_lock[2],direction_lock[3]);
	
	wire [3:0]direction_lock;
//	debounce m0(.clk(clk),.key_in(direction[0]),.key_out(direction_lock[0]));
	//debounce m1(.clk(clk),.key_in(direction[1]),.key_out(direction_lock[1]));
	//debounce m2(.clk(clk),.key_in(direction[2]),.key_out(direction_lock[2]));
	//debounce m3(.clk(clk),.key_in(direction[3]),.key_out(direction_lock[3]));


	
	always @(posedge direction_lock[0] or posedge direction_lock[1] or posedge direction_lock[2] or posedge direction_lock[3] or posedge res_lock)	//瀹氫箟direction[0]涓哄悜涓婃帶鍒堕敭
	begin

	if(res_lock==1) begin
		step_cnt<=7'b0000000;
		location_row_num<=start_point_row;
		location_col_num<=start_point_col;
	end
	if(direction_lock[0]||direction_lock[1]||direction_lock[2]||direction_lock[3])	begin
		if(location_row_num!=terminal_point_row)
		begin
			if(location_col_num!=terminal_point_col)
			begin
				if(location_row_num<7 &&direction_lock[0])
					begin
						if(!map_row[location_row_num+1][location_col_num])
							begin
								step_cnt<=step_cnt+1;
								location_row_num<=location_row_num+1;
							end
					end
				if(location_row_num>0&&direction_lock[1])
					begin
						if(!map_row[location_row_num-1][location_col_num])
							begin
								step_cnt<=step_cnt+1;
								location_row_num<=location_row_num-1;
							end
					end
				if(location_col_num>0&&direction_lock[2])
					begin
						if(!map_row[location_row_num][location_col_num-1])
							begin
								step_cnt<=step_cnt+1;
								location_col_num<=location_col_num-1;
							end
					end
				if(location_col_num<7&&direction_lock[3])
					begin
						if(!map_row[location_row_num][location_col_num+1])
							begin
								step_cnt<=step_cnt+1;
								location_col_num<=location_col_num+1;
							end
					end
			end
	
		end
	end
	end
	
	reg clk_2Hz;
	reg clk_10kHz;
	reg clk_Hz;
	reg rev;
	reg [19:0] count1=20'd0;
	reg [24:0] count2=25'd0;
	
	always @(posedge clk)  //10kHz
	begin
	if(start==0&&self_exa==1) begin
		if(count2==12000000) begin
			clk_2Hz=~clk_2Hz;
			clk_Hz=clk_2Hz;
			count2=20'd0;
		end
		else count2=count2+1;
	end
	else begin
	if(count1==50000)
	begin
		clk_10kHz=~clk_10kHz;
		clk_Hz=clk_10kHz;
		count1=20'd0;
	end
	else
		begin
		count1=count1+1;
		end
	end
	end
	
	reg [3:0] row_num=4'b0000; 
	
	always @(posedge clk_Hz) begin
	if(row_num!=4'b0111) begin
		row_num<=row_num+1;
		rev=~rev;
	end
	else row_num<=4'b0000;
	end

	always @(posedge clk_Hz) begin
	case(row_num)
	4'h0: begin
		row<=8'b1111_1110;
		digit_con<=8'b1111_1110;
	end
	4'h1: begin
		row<=8'b1111_1101;
		digit_con<=8'b1111_1101;
	end
	4'h2: begin
		row<=8'b1111_1011;
		digit_con<=8'b1111_1011;
	end
	4'h3: begin
		row<=8'b1111_0111;
		digit_con<=8'b1111_0111;
	end
	4'h4: begin
		row<=8'b1110_1111;
		digit_con<=8'b1110_1111;
	end
	4'h5: begin
		row<=8'b1101_1111;
		digit_con<=8'b1101_1111;
	end
	4'h6: begin
		row<=8'b1011_1111;
		digit_con<=8'b1011_1111;
	end
	4'h7: begin
		row<=8'b0111_1111;
		digit_con<=8'b0111_1111;
	end
	endcase
end
	reg [7:0] g_row_info=8'b0000_0000;
	
    reg clks;
    reg [19:0] countm;
    always @(posedge clk) begin
    if(countm==50000) begin
       countm<=20'd0;
       clks<=~clks;
   end
   else countm<=countm+1;
   end
	always @(posedge clk_Hz) 
	begin
	if(start==0&&self_exa==0) begin  
			r_col<=8'b0000_0000;
			g_col<=8'b0000_0000;
			
	end
	
	if(start==0&&self_exa==1) begin
		if(rev==1) begin
				r_col<=8'b1111_1111;
				g_col<=8'b0000_0000;
			end
			else begin
				g_col<=8'b1111_1111;
				r_col<=8'b0000_0000;
			end
	end
	
	if(start==1&&(time2!=0)&&(!((location_col_num==terminal_point_col)&&(location_row_num==terminal_point_row)))) begin
		case(row_num)
			4'd0:r_col<=map_row[0];
			4'd1:r_col<=map_row[1];
			4'd2:r_col<=map_row[2];
			4'd3:r_col<=map_row[3];
			4'd4:r_col<=map_row[4];
			4'd5:r_col<=map_row[5];
			4'd6:r_col<=map_row[6];
			4'd7:r_col<=map_row[7];
		endcase
	end
	
	if(start==1&&time2==0&&(!((location_col_num==terminal_point_col)&&(location_row_num==terminal_point_row)))) begin
			case(row_num)
				4'd0:r_col<=8'b0000_0000;
				4'd1:r_col<=8'b0100_0010;
				4'd2:r_col<=8'b0011_1100;
				4'd3:r_col<=8'b0000_0000;
				4'd4:r_col<=8'b0110_0110;
				4'd5:r_col<=8'b0110_0110;
				4'd6:r_col<=8'b0000_0000;
				4'd7:r_col<=8'b0000_0000;
			endcase
			g_col<=8'b0000_0000;
		end
		
		else if(start==1&&((location_col_num==terminal_point_col)&&(location_row_num==terminal_point_row))) begin  //鎴愬姛鏄剧ず
			case(row_num)
				4'd0:g_col<=8'b0000_0000;
				4'd1:g_col<=8'b0011_1100;
				4'd2:g_col<=8'b0100_0010;
				4'd3:g_col<=8'b0000_0000;
				4'd4:g_col<=8'b0110_0110;
				4'd5:g_col<=8'b0110_0110;
				4'd6:g_col<=8'b0000_0000;
				4'd7:g_col<=8'b0000_0000;
			endcase
			r_col<=8'b0000_0000;
		end

		if(start==1&&(time2!=0)&&(!((location_col_num==terminal_point_col)&&(location_row_num==terminal_point_row)))) begin
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
	end


	wire [3:0] ten;
	wire [3:0] one;
	
	always @(posedge clks) begin
		
		if(self_exa==0&&start==0) begin
			digit_seg0<=8'b0000_0000;
		end

		
		if(self_exa==1&&start==0) begin
			digit_seg0<=8'b1111_1111;
		end
			


		if(start==1&&(time2!=0)&&(!((location_col_num==terminal_point_col)&&(location_row_num==terminal_point_row)))) begin
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
		if(row_num==2||row_num==3||row_num==6||row_num==7) begin
			digit_seg0<=8'b0000_0000;
		end
		end

		if(start==1&&((time2==0)||((location_col_num==terminal_point_col)&&(location_row_num==terminal_point_row)))) begin
			digit_seg0<=8'b0000_0000;
		end
		if(row_num==4) begin
		case(one_step)
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

		if(row_num==5) begin
			case(ten_step)
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

	

	frequency_divider u1(.start(start),.change_map(change_map),.clk(clk),.ten(ten),.one(one),.time1(time2));

	


	
	reg [3:0] ten_step;
	reg [3:0] one_step;

	integer j;
	always @(step_cnt)
	begin
		ten_step=4'd0;
		one_step=4'd0;
		
		for(j=6;j>=0;j=j-1)
		begin
			if(ten_step>4)
				ten_step=ten_step+4'd3;
			if(one_step>4)
				one_step=one_step+4'd3;
			ten_step=ten_step<<1;
			ten_step[0]=one_step[3];
			one_step=one_step<<1;
			one_step[0]=step_cnt[j];
		end
	end

	
endmodule

module frequency_divider(start,change_map,clk,ten,one,time1);		
		input start;
		input change_map;
		input clk;
		output reg[3:0] ten;
		output reg[3:0] one;
		output reg[4:0] time1;
		reg[31:0] time_count=32'd0;
		reg time1_temp=1'b0;
		
		always @(start or change_map or a)
		begin
			if(start==1&&a==0) begin
				time1<=5'd30;
			end
			else if(a==1)begin
				time1<=time1-1;
			end

		end

		reg a=1'b0;
		always @(time_count) begin
			if(time_count) begin
				a<=1'b0;
			end
			else if(time_count==0) begin
				a<=1'b1;
			end
		end
		always @(posedge clk)
			begin
			if(time1!=5'd00)
			begin
			if(time_count==50000000)
			begin
				time_count<=32'd0;
			end
			else begin
			time_count<=time_count+1;
			end
			end
			end
		
			integer i;
	
			always @(negedge time1)
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
endmodule				
			
module debounce(clk,key_in,key_out);
	input key_in;
	input clk;
	output reg key_out;
	reg [19:0]tcnt1;
	
	always @(posedge clk or negedge key_in)
	begin
	if(!key_in)tcnt1<=20'd0;
	else tcnt1<=tcnt1+1;
	end
	always @(posedge clk or negedge key_in)
	begin
	if(!key_in)key_out<=0;
		else if(tcnt1==20'hfffff)key_out<=key_in;
	end
endmodule


module debounce1 (clk,rst,key[0],key[1],key[2],key[3],key_pulse[0],key_pulse[1],key_pulse[2],key_pulse[3]);
 
    parameter N  =  4;                      //要消除的按键的数量
	input clk;
    input rst;
    input [N-1:0] key;             		  //输入的按键					
	output [N-1:0] key_pulse;                  //按键动作产生的脉冲	
 
    reg [N-1:0] key_rst_pre;                //定义一个寄存器型变量存储上一个触发时的按键值
    reg [N-1:0] key_rst;                    //定义一个寄存器变量储存储当前时刻触发的按键值
 
    wire [N-1:0] key_edge;                   //检测到按键由高到低变化是产生一个高脉冲
 
        //利用非阻塞赋值特点，将两个时钟触发时按键状态存储在两个寄存器变量中
    always @(posedge clk  or  negedge rst)
        begin
         if (!rst) begin
             key_rst <= {N{1'b1}};                //初始化时给key_rst赋值全为1，{}中表示N个1
               key_rst_pre <= {N{1'b1}};
         end
          else begin
               key_rst <= key;                     //第一个时钟上升沿触发之后key的值赋给key_rst,同时key_rst的值赋给key_rst_pre
              key_rst_pre <= key_rst;             //非阻塞赋值。相当于经过两个时钟触发，key_rst存储的是当前时刻key的值，key_rst_pre存储的是前一个时钟的key的值
         end    
    end
 
    assign  key_edge = key_rst_pre & (~key_rst);//脉冲边沿检测。当key检测到下降沿时，key_edge产生一个时钟周期的高电平
 
    reg	[19:0]	  cnt;                       //产生延时所用的计数器，系统时钟12MHz，要延时20ms左右时间，至少需要18位计数器     
 
        //产生20ms延时，当检测到key_edge有效是计数器清零开始计数
        always @(posedge clk or negedge rst)
           begin
             if(!rst)
                cnt <= 20'h0;
             else if(key_edge)
                cnt <= 20'h0;
             else
                cnt <= cnt + 1'h1;
             end  
 
        reg     [N-1:0]   key_sec_pre;                //延时后检测电平寄存器变量
        reg     [N-1:0]   key_sec;                    
 
 
        //延时后检测key，如果按键状态变低产生一个时钟的高脉冲。如果按键状态是高的话说明按键无效
        always @(posedge clk  or  negedge rst)
          begin
             if (!rst) 
                 key_sec <= {N{1'b1}};                
             else if (cnt==20'hf_ffff)
                 key_sec <= key;  
          end
          
       always @(posedge clk  or  negedge rst)
          begin
             if (!rst)
                 key_sec_pre <= {N{1'b1}};
             else                   
                 key_sec_pre <= key_sec;             
                 
         end      
       assign  key_pulse = key_sec_pre & (~key_sec);     
 
endmodule