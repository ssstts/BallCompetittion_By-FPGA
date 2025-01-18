`timescale 1ns / 1ps

module BallCompetition(
    input	wire clk,					//时钟
    input   wire rstn,					//复位
    input	wire	[3:0]  sw_in,  	//4位拨码开关
    input   wire  [2:0]  key_in,		//3位投篮加分按键
    output	wire	[1:0]  reg_ab,  	//两位rgb灯分别显示当前为A队orB队
    output  wire  [7:0]  led_time,	//8位led灯，表示当前为第几节，每结束一节，按顺序灭掉两位led灯
    output  [8:0]  seg_led_1,			//数码管1
	 output  [8:0]  seg_led_2			//数码管2
);

	localparam DelayTime = 250_000;	
//    localparam DelayTime = 25; //simulation time
   wire [2:0]	press_on;				//按键按下
	wire [3:0] seg_data_1;				//数码管数据输入1
	wire [3:0] seg_data_2;				//数码管数据输入2
	
    key_debounce	//按键消抖模块
    #(.DELAY_TIME  (DelayTime)) //250_000
    key0
    (
		.clk(clk),		            
      .rstn(rstn),
      .key_in(key_in[0]),		
      .press_on(press_on[0])	       
    );
    
    key_debounce
    #(.DELAY_TIME  (DelayTime)) //250_000
    key1
    (
      .clk(clk),		           
      .rstn(rstn),
      .key_in(key_in[1]),		
      .press_on(press_on[1])	       
    );
    
    key_debounce
    #(.DELAY_TIME  (DelayTime)) //250_000
    key2
    (
      .clk(clk),		            
      .rstn(rstn),
      .key_in(key_in[2]),		
      .press_on(press_on[2])	      
    ); 
	 
    //主功能模块
    Display u_Display(
      .clk(clk),  
      .rstn(rstn),
      .sw_in(sw_in),  
      .press_on(press_on),
      .reg_ab(reg_ab), 
      .led_time(led_time),
      .seg_data_1(seg_data_1),  
      .seg_data_2(seg_data_2)      
    );
	 
	
    //数码管显示模块
    segment u_segment(
   .seg_data_1  (seg_data_1),	
	.seg_data_2  (seg_data_2),		
	.seg_led_1   (seg_led_1),		
	.seg_led_2	 (seg_led_2)
    );
endmodule
