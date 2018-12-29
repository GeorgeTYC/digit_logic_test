debounce debounce1(clk,rst,direction1,direction2,direction3,direction4,direction_lock1,direction_lock2,direction_lock3,direction_lock4);
always@(posedge clk or posedge rst)
	begin
		if(rst)
			begin
				step_cnt<=7'b0000000;
				location_row_num<=start_point_row;
				location_col_num<=start_point_col;
			end
	   else if(location_row_num!=terminal_point_row||location_col_num!=terminal_point_col) begin

	   if(location_row_num<7 &&direction_lock1)
			begin
				if(!map_row[location_row_num+1][location_col_num])
							begin
								step_cnt<=step_cnt+1;
								location_row_num<=location_row_num+1;
							end
			end
		else if(location_row_num>0&&direction_lock2)
			begin
				if(!map_row[location_row_num-1][location_col_num])
							begin
								step_cnt<=step_cnt+1;
								location_row_num<=location_row_num-1;
							end
			end
		else if(location_col_num>0&&direction_lock3)
			begin
				if(!map_row[location_row_num][location_col_num-1])
							begin
								step_cnt<=step_cnt+1;
								location_col_num<=location_col_num-1;
							end
			end
		else if(location_col_num<7&&direction_lock4)
			begin
				if(!map_row[location_row_num][location_col_num+1])
							begin
								step_cnt<=step_cnt+1;
								location_col_num<=location_col_num+1;
							end
			end
		end
	end