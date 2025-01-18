`timescale 1ns / 1ps
//按键消抖模块
module key_debounce #(  
   parameter	DELAY_TIME = 250_000  
)(
		input wire	clk,		
		input wire  rstn,
		input wire	key_in,		
		output reg 	press_on			
);

reg		key_in_r0;		
reg		key_in_r1;		
reg 		key_in_nedge;		
reg	[19:0]delay_cnt;		
reg		delay_flag;		//延时标志位

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
        key_in_r0 <= 1'b0	;	
        key_in_r1 <= 1'b0	;	
    end
    else begin
       key_in_r0 <= key_in;
	   key_in_r1 <= key_in_r0;
    end
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
        key_in_nedge <= 1'b0;               
    end
    else begin
        key_in_nedge <= ~key_in_r0 & key_in_r1;
    end 
end

//delay_cnt 延时计数
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
        delay_cnt  <= 'd0;	
    end
    else begin
        if((delay_flag == 1) && (delay_cnt == DELAY_TIME - 1))
				delay_cnt <= 0;
        else if ((delay_flag == 1) && (delay_cnt < DELAY_TIME - 1))
            delay_cnt <= delay_cnt + 1;
        else  
				delay_cnt <= 0;
    end
end

//delay_flag
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
	 delay_flag <= 1'b0;		//若复位按键按下，则延时标志位置0
    end
    else begin
        if(key_in_nedge) begin	//按键下降沿到来 
				delay_flag <= 1'b1;	//延时标志位置1
        end
        else if (delay_cnt == DELAY_TIME - 1) begin
            delay_flag <= 1'b0;
        end
        else
            delay_flag <= delay_flag;
    end
end
//press_on
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
        press_on <= 1'b0;
    end
    else begin
        if((delay_cnt == DELAY_TIME - 1) && (delay_flag == 1'b1)) begin		//判断按键是否按下  
		    press_on <= 1'b1;
        end
        else begin
            press_on <= 1'b0;
        end
    end
end

endmodule
