`timescale 1ns / 1ps

module BallCompetition_tb();
reg	        clk;
reg        rstn ;
reg	 [3:0]   sw_in   ; 
reg  [3:0]   key_in  ;
wire [1:0]  reg_ab ;
wire [7:0]  led_time;
wire  [8:0]  seg_led_1;	
wire  [8:0]  seg_led_2;	


initial
begin
	clk <= 0;
	rstn <=0;
	sw_in <=  4'b0000;
	key_in <= 4'b1111;
	#10
	rstn <=1;
	sw_in <=  4'b0011; 
	key_in <= 4'b1110;
	#300
	key_in <= 4'b1111;
	#20;
	key_in <= 4'b1101;
	#300
	key_in <= 4'b1111;
	#20;
	key_in <= 4'b1011;
	#300
	key_in <= 4'b1111;
	#20;
end

always #5 clk <= ~clk;

BallCompetition u_BallCompetition(
    .clk            (clk)   ,
    .rstn         (rstn       )  ,
    .sw_in       (sw_in)   , 
    .key_in          (key_in)   ,
    .reg_ab         (reg_ab)  ,  
    .led_time         (led_time) ,
    .seg_led_1       (seg_led_1),		
	.seg_led_2		 (seg_led_2)
    );
endmodule
