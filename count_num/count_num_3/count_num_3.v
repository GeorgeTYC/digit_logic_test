module count_num_3(clk,rst, switch, digit_seg, digit_cath);
input clk;
input rst;
input switch;
output reg [7:0] digit_seg; 
output [1:0] digit_cath; 
reg [7:0] cnt;
reg [31:0]div_count;
reg lo_sw,lo_rst;
reg [19:0]tcnt1,tcnt2;
always @(posedge clk or negedge rst)
begin
	if(!rst)tcnt1<=20'd0;
	else tcnt1<=tcnt1+1;
end
always @(posedge clk or negedge rst)
begin
	if(!rst)lo_rst<=0;
	else if(tcnt1==20'hfffff)lo_rst<=rst;
end
always @(posedge clk or negedge switch)
begin
	if(!switch)tcnt2<=20'd0;
	else tcnt2<=tcnt2+1;
end
always @(posedge clk or negedge switch)
begin
	if(!switch)lo_sw<=0;
	else if(tcnt2==20'hfffff)lo_sw<=switch;
end
always @(posedge clk)div_count<=div_count+1;
always @(posedge lo_rst,posedge lo_sw)
begin
    if(lo_rst)
        cnt <= 0;   
    else if(lo_sw)
        cnt <= cnt + 1;
end
wire [7:0] digit_display;
assign digit_display = cnt;

wire [3:0] digit;
always @(*)     
begin
    case (digit)
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
end
reg segcath_holdtime=0;
always @(posedge div_count[10])
     segcath_holdtime <= ~segcath_holdtime;
assign digit_cath ={segcath_holdtime, ~segcath_holdtime};
assign digit =segcath_holdtime ? digit_display[7:4] : digit_display[3:0];
endmodule