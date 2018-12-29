module dig_lock(clk,switch,led,key,res_but);
	input clk;
	input key;
	input res_but;
	input [7:0]switch;
	output reg led;
	parameter a=8'b00000000;
always @(posedge clk)
begin
	begin
	if(switch!=a&&key&&!res_but)
		begin
		led<=1'b1;
		end
	else
		begin
		led<=1'b0;
		end
	end
end
endmodule

