`timescale 1ns / 1ps

module Display(
    input	wire	clk,  //12MHz 83ns
    input   wire  rstn,
    input	wire	[3:0]  sw_in,  
    input   wire  [2:0]  press_on,
    output	wire	[1:0]  reg_ab, 
    output  wire  [7:0]  led_time,
    output	wire 	[3:0]  seg_data_1, 
	 output	wire 	[3:0]  seg_data_2 
    );
localparam COUNT_1S = 12048193; //1S
localparam Quarter_Time = 60; 	//扩展2：可连续进行四节60s+10s的比赛 60s为每一节的时长，10s为中场休息时长
localparam Quarter_Time_rest = 10;	//rest时间
//localparam COUNT_1S = 120; //simulation time
//localparam Quarter_Time = 60; //simulation time

wire clk1h;
reg [23:0] counter ;//计数器
reg [23:0] Qcounter ;
reg [6:0] scorer_A ; 
reg [6:0] scorer_B ; 
reg [6:0] Quarter_Time_Down ;	//每小节比赛倒计时
reg [2:0] Quarter_Time_rest_Down ; //各小节比赛之间的休息时间倒计时
reg [4:0] AttackT_A ; 
reg [4:0] AttackT_B; 
reg [1:0] reg_ab_reg;
reg [7:0] led_time_reg ;
reg [3:0] seg_data_1_reg;
reg [3:0] seg_data_2_reg;
reg [1:0] DownCNT;	//记录目前是第几节比赛
reg [6:0] countA_1;	//A投篮次数 1分球
reg [6:0] countA_2;	//A投篮次数 2分球
reg [6:0] countA_3;	//A投篮次数 3分球
reg [6:0] countB_1;	//B投篮次数 1分球
reg [6:0] countB_2;	//B投篮次数 2分球
reg [6:0] countB_3;	//B投篮次数 3分球


/*每小节比赛过后 led灯熄灭两盏，且重新开始每小节倒计时*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin	//若复位，则均归零
       led_time_reg <= 8'b0000_0000; 
       Qcounter <= 'd0;//计数功能
	    Quarter_Time_Down <= Quarter_Time;	
		 Quarter_Time_rest_Down <= Quarter_Time_rest;
	    DownCNT <= 'd0;
    end
    else begin
        if(Qcounter == COUNT_1S - 1) begin  
            Qcounter <= 'd0;
				if(Quarter_Time_Down == 0) begin        
						if(DownCNT == 2'd3) begin
						   DownCNT <= 2'd3;
							Quarter_Time_Down <=  0;
							Quarter_Time_rest_Down <= 0;
							led_time_reg <= {led_time_reg[5:0],1'b1,1'b1};// 每次灭两盏灯
						end
						else begin
							if(Quarter_Time_rest_Down == 0)begin
								DownCNT <= DownCNT + 1'b1;
								Quarter_Time_Down <=  Quarter_Time;
								Quarter_Time_rest_Down <= Quarter_Time_rest;
								led_time_reg <= {led_time_reg[5:0],1'b1,1'b1};// 每次灭两盏灯
							end
							else begin
								Quarter_Time_rest_Down <= Quarter_Time_rest_Down -1'b1;
							end
						end
						
				 end
				 else begin
					 Quarter_Time_Down <= Quarter_Time_Down - 1'b1;
				 end
				 
        end
        else begin
           Qcounter <= Qcounter + 1;//计数器
        end 
    end
end 

//A B Score
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
        scorer_A <= 'd0; 
        scorer_B <= 'd0; 
		  countA_1 <= 'd0;countA_2 <= 'd0;countA_3 <= 'd0;
		  countB_1 <= 'd0;countB_2 <= 'd0;countB_3 <= 'd0;
	 end
    else begin
        case(sw_in[3:1])
            3'b011:begin //A Score
              case(press_on) //key
                3'b001: begin
                    scorer_A <= scorer_A + 1;
						  countA_1 <= countA_1 + 1;
                end 
                3'b010: begin
                    scorer_A <= scorer_A + 2;
						  countA_2 <= countA_2 + 1;
                end 
                3'b100: begin
                    scorer_A <= scorer_A + 3;
						  countA_3 <= countA_3 + 1;
					 end
                default:begin
                    scorer_A <= scorer_A; 
                end
              endcase  
            end
            3'b111:begin //B Score
               case(press_on)
                3'b001: begin
                    scorer_B <= scorer_B + 1;
						  countB_1 <= countB_1 + 1;
                end 
                3'b010: begin
                    scorer_B <= scorer_B + 2;
						  countB_2 <= countB_2 + 1;
                end 
                3'b100: begin
                    scorer_B <= scorer_B + 3;
						  countB_3 <= countB_3 + 1;
                end
                default:begin
                    scorer_B <= scorer_B; 
                end
              endcase     
            end			 
            default:begin
                scorer_A <= scorer_A; 
                scorer_B <= scorer_B; 
            end
        endcase
    end
end
    
// A B 进攻倒计时24s    
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
        AttackT_A <= 5'd24;
        AttackT_B <= 5'd24;
        counter <=  'd0;
    end
    else begin
        case(sw_in[3:1])
		3'b000:begin   //A 24S
              if(sw_in[0] == 1'b1) begin 
                    if(counter == COUNT_1S - 1) begin  
                            counter <= 'd0;
									 if(AttackT_A == 0) begin  
                                AttackT_A <= 0 ;
                            end
									 
                            else begin
                               AttackT_A <= AttackT_A - 1'b1;
                            end
                    end
                    else begin
                       counter <= counter + 1;
                    end
             end
             else begin   
                counter <= counter;
             end   
		end
		3'b001:begin //B 24S
              if(sw_in[0] == 1'b1) begin  
                    if(counter == COUNT_1S - 1) begin  
                            counter <= 'd0;
                            if(AttackT_B == 0) begin 
                                AttackT_B <= 0 ;
                            end
                            else begin
                               AttackT_B <= AttackT_B - 1'b1;
                            end
                    end
                    else begin
                       counter <= counter + 1;
                    end
             end
             else begin   
                counter <= counter;
             end
		end
		3'b011:begin //A Score
           counter <=  counter;
           AttackT_A <= AttackT_A;
		     AttackT_B <= AttackT_B;
		end
		3'b111:begin //B Score
		     counter <=  counter;
           AttackT_A <= AttackT_A;
		     AttackT_B <= AttackT_B;
		end	
		default:begin
            counter <=  'd0;
            AttackT_A <= 5'd24;
		      AttackT_B <= 5'd24;
	    end
	   endcase
    end
end


//显示RGB+SEG 集成显示模块
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0) begin
		  seg_data_1_reg <= 4'd16;//不显示 OFF
        seg_data_2_reg <= 4'd16;
		  reg_ab_reg <= 2'b11;
    end
    else begin
        case(sw_in[3:1])
		3'b000:begin   //A 24S
            seg_data_2_reg <= AttackT_A%10;//个位
            seg_data_1_reg <= AttackT_A/10;//十位
			reg_ab_reg <= 2'b10;
		end
		3'b001:begin //B 24S
            seg_data_2_reg <= AttackT_B%10;
            seg_data_1_reg <= AttackT_B/10;
			reg_ab_reg <= 2'b01;
		end
		3'b011:begin //A Score
            seg_data_2_reg <= scorer_A%10;
            seg_data_1_reg <= scorer_A/10;
			reg_ab_reg <= 2'b10;
		end
		3'b111:begin //B Score
				seg_data_2_reg <= scorer_B%10;
				seg_data_1_reg <= scorer_B/10;
		   reg_ab_reg <= 2'b01;
		end			 
		3'b110:begin  //Quarter Time //实现四小节比赛连续进行
				if(Quarter_Time_Down == 0)begin
					seg_data_2_reg <= Quarter_Time_rest_Down%10;
					seg_data_1_reg <= Quarter_Time_rest_Down/10;end
				else begin
					seg_data_2_reg <= Quarter_Time_Down%10;
					seg_data_1_reg <= Quarter_Time_Down/10;end
		    reg_ab_reg <= 2'b00;
		end
		3'b100:begin  //拓展1：WIN Time 若某队获胜，则该队的RGB亮灯，且数码管显示为该队的字母，否则不亮
            if(scorer_A > scorer_B) begin
					seg_data_2_reg <= 4'd10;  //A
					seg_data_1_reg <= scorer_A-scorer_B;  //扩展3：显示A,B两队的比分差
					reg_ab_reg <= 2'b10;
			   end
				else if(scorer_A < scorer_B) begin
					seg_data_2_reg <= 4'd11;  //B
					seg_data_1_reg <= scorer_B-scorer_A;  //比分差
					reg_ab_reg <= 2'b01;
			   end 
				else begin	//打成平局
					seg_data_2_reg <= 4'd00;  
					seg_data_1_reg <= 4'd00;  //A,B分数清零
					reg_ab_reg <= 2'b00;
				end
		end
	   3'b010:begin
		case(press_on)	//扩展4：显示队伍A,B分别进了多少了1分球，2分球，3分球
				3'b001:begin
					seg_data_2_reg <= countA_1%10;
					seg_data_1_reg <= countA_1/10;end
				3'b010:begin
					seg_data_2_reg <= countA_2%10;
					seg_data_1_reg <= countA_2/10;end
				3'b100:begin
					seg_data_2_reg <= countA_3%10;
					seg_data_1_reg <= countA_3/10;end
				endcase
		end
		3'b101:begin
				case(press_on)
				3'b001:begin
					seg_data_2_reg <= countB_1%10;
					seg_data_1_reg <= countB_1/10;end
				3'b010:begin
					seg_data_2_reg <= countB_2%10;
					seg_data_1_reg <= countB_2/10;end
				3'b100:begin
					seg_data_2_reg <= countB_3%10;
					seg_data_1_reg <= countB_3/10;end
				endcase
		end
		default:begin //否则均关闭 OFF
			seg_data_2_reg <= 4'd16;
			seg_data_1_reg <= 4'd16;
			reg_ab_reg <= 2'b11;
	    end
	endcase
    end
end    
    
//output 
assign reg_ab = reg_ab_reg; // BLUE GREEN
assign led_time = led_time_reg;
assign seg_data_1 = seg_data_1_reg;
assign seg_data_2 = seg_data_2_reg;
	 
endmodule
