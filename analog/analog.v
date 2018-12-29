

module analog(clk,rst,start,change_map,direction1,direction2,direction3,direction4,time_sign,row,g_col,r_col,suc,step_cnt);
	input clk;
	input start;
	input rst;
	input change_map;
	input direction1;
	input direction2;
	input direction3;
	input direction4;
	input [4:0] time_sign;

	output reg [7:0] row;
	output reg [7:0] g_col;
	output reg [7:0] r_col;
	output reg suc=1'b0;
	output reg [6:0] step_cnt=7'b000_0000;
	reg [7:0] map_row [7:0];
	reg [7:0] map_row_1 [7:0];
	reg [7:0] map_row_2 [7:0];

	
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
	map_row_2[1]=8'b0001_1100;
	map_row_2[2]=8'b1100_0101;
	map_row_2[3]=8'b0101_0101;
	map_row_2[4]=8'b0101_0101;
	map_row_2[5]=8'b0101_1101;
	map_row_2[6]=8'b0100_0001;
	map_row_2[7]=8'b0111_1111;
	
	end

	reg [2:0] start_point_col;
	reg [2:0] start_point_row;
	reg [2:0] terminal_point_row;
	reg [7:0] terminal_point_col;
	reg [7:0] start_point_1=6'b110_111;
	reg [5:0] terminal_point_1=6'b000_000;
	reg [5:0] start_point_2=6'b001_000;
	reg [5:0] terminal_point_2=6'b001_111;

	reg [2:0] location_row_num;
	reg [2:0] location_col_num;


	wire [2:0] maze_con;  //三位信息分别代表开始，切换地图，以及切换模式
	reg start_con=1'b0;
	reg map_con=1'b0;
	reg mode_con=1'b0;

	assign maze_con = {mode_con,map_con,start_con};

	wire start_lock;
	wire change_map_lock;
	sw a1(.clk(clk),.key_in(start),.key_out(start_lock));
	sw a2(.clk(clk),.key_in(change_map),.key_out(change_map_lock));

	always @(posedge start_lock) begin
		if(start_lock==1) begin
			start_con<=1'b1;
		end
	end

	always @(change_map_lock) begin
		if(change_map_lock==1) begin
			map_con<=1'b1;
		end
		else begin
			map_con<=1'b0;
		end
	end

	always @(posedge clk) begin
		if(map_con==0) begin
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
		else if(map_con==1)begin
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

	wire direction_lock1;
	wire direction_lock2;
	wire direction_lock3;
	wire direction_lock4;

	//debounce c1(clk,~rst,direction1,direction2,direction3,direction4,direction_lock1,direction_lock2,direction_lock3,direction_lock4);
	
	sw c1(.clk(clk),.key_in(direction1),.key_out(direction_lock1));
	sw c2(.clk(clk),.key_in(direction2),.key_out(direction_lock2));
	sw c3(.clk(clk),.key_in(direction3),.key_out(direction_lock3));
	sw c4(.clk(clk),.key_in(direction4),.key_out(direction_lock4));

	always @(posedge clk) 
	begin
	if(start_lock==1) begin
		step_cnt<=7'b0000000;
		location_row_num=start_point_row;
		location_col_num=start_point_col;
	end
	
		if(location_row_num!=terminal_point_row||location_col_num!=terminal_point_col)
		begin
			if(direction_lock1&&location_row_num<7)
			
				begin
							if(map_row[location_row_num+1][location_col_num]==0)
							begin
								step_cnt<=step_cnt+1;
								location_row_num=location_row_num+1;
							end
							else begin
								location_col_num=location_col_num;
								location_row_num=location_row_num;
							end
					end
				if(direction_lock2&&location_row_num>0)
					begin
						if(map_row[location_row_num-1][location_col_num]==0) begin
								step_cnt<=step_cnt+1;
								location_row_num=location_row_num-1;
								end
								else begin
									location_row_num=location_row_num;
									location_col_num=location_col_num;
								end
					end
				if(direction_lock3&&location_col_num>0)
			
					begin
						if(map_row[location_row_num][location_col_num-1]==0)
						begin
								step_cnt<=step_cnt+1;
								location_col_num=location_col_num-1;
							end
							else begin
								location_col_num=location_col_num;
								location_row_num=location_row_num;
							end
					end
				if(direction_lock4&&location_col_num<7)
					begin
							if(map_row[location_row_num][location_col_num+1]==0)
							begin
								step_cnt<=step_cnt+1;
								location_col_num=location_col_num+1;
							end
							else begin
								location_row_num=location_row_num;
								location_col_num=location_col_num;
							end
					end
		end


end


	always @(posedge clk) begin
	if((location_row_num==terminal_point_row)&&(location_col_num==terminal_point_col)) begin
			suc<=1'b1;
		end
	else
		suc<=1'b0;
	end

	reg [31:0] count=32'd0;
	reg clk_1kHz;

	always @(posedge clk) begin  //1k频率的时钟
		if(count==2) begin
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
		if(start_con==0) begin
			r_col<=8'b000_0000;
			g_col<=8'b000_0000;
		end
		else if(start_con==1&&time_sign!=0&&suc==0) begin
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
		else if(start_con==1&&time_sign==0&&suc==0) begin
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
		else if(start_con==1&&time_sign!=0&&suc==1) begin
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

module debounce (clk,rst,key[0],key[1],key[2],key[3],key_pulse[0],key_pulse[1],key_pulse[2],key_pulse[3]);
 
        parameter       N  =  4;                      //要消除的按键的数量
 
	input             clk;
        input             rst;
        input 	[N-1:0]   key;             		  //输入的按键					
	output  [N-1:0]   key_pulse;                  //按键动作产生的脉冲	
 
        reg     [N-1:0]   key_rst_pre;                //定义一个寄存器型变量存储上一个触发时的按键值
        reg     [N-1:0]   key_rst;                    //定义一个寄存器变量储存储当前时刻触发的按键值
 
        wire    [N-1:0]   key_edge;                   //检测到按键由高到低变化是产生一个高脉冲
 
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

module sw(clk,key_in,key_out);
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
		else if(tcnt1==20'h1)key_out<=key_in;
	end
endmodule

