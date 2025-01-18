`timescale 1ns / 1ps
//基本的数码管显示模块
module segment(
   input [3:0] seg_data_1,		
	input [3:0] seg_data_2,		
	output [8:0] seg_led_1,		
	output [8:0] seg_led_2		
);
   
reg [8:0] seg [16:0];   		

initial        	         									                           

	begin
		seg[0] = 9'h3f;         
		seg[1] = 9'h06;        
		seg[2] = 9'h5b;       
		seg[3] = 9'h4f;         
		seg[4] = 9'h66;        
		seg[5] = 9'h6d;        
		seg[6] = 9'h7d;       
		seg[7] = 9'h07;      
		seg[8] = 9'h7f;      
		seg[9] = 9'h6f;         
		seg[10] = 9'h77;   //A     
		seg[11] = 9'h7c;	 //B
		seg[12] = 9'h39;
		seg[13] = 9'h5e;
		seg[14] = 9'h79;
		seg[15] = 9'h71;
		seg[16] = 9'h00;	//OFF
     end
	
	assign seg_led_1 = seg[seg_data_1];      
	assign seg_led_2 = seg[seg_data_2];      

endmodule
