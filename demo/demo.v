module demo (key,sw,led);
 
	input [3:0] key;						//按键输入信号
	input [3:0] sw;							//开关输入信号
	output [7:0] led;						//输出信号到LED
 
	assign led = {key,sw};                                          //assign连续赋值。大括号是拼接符，表示把key和sw拼接组成一个新的8位数赋值给led
 
endmodule