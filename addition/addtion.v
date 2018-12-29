module addition(cina,cinb,cout,top,clk);
	input clk;
	input [3:0]cina;
	input [3:0]cinb;
	output [3:0]cout;
	output top;
	wire b;
	wire a='b0;
	always @(posedge clk)
		begin
		add_N add1(cina[0],cinb[0],a,b,cout[0]);
		add_N add2(cina[1],cinb[1],b,ci1,cout[1]);
		add_N add3(cina[2],cinb[2],ci1,ci2,cout[2]);
		add_N add4(cina[3],cinb[3],ci2,top,cout[3]);
		end
endmodule

module add_N(a,b,fro,term1,Cout);
	input a,b,fro;
	output term1,Cout;
	
	assign {term1,Cout}=a+b+fro;
endmodule
