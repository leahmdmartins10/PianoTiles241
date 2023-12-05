// drawing the columns

// resolution of the screen is 320x240 via the vga controller resolution

module draw_cont(input clock, resetn, startn, draw_go,
						input [5:0] drawdone, // we need a draw done for each draw
						erase_done, draw_color,
						erase_color,
						
						input [8:0] draw_0x, // the max x dimension is 320 therefore, 9'b101000000
						draw_1x,
						draw_2x,
						draw_3x,
						draw_4x,
						draw_5x,
						
						// need an erase for each xdraw
						erase_0x,
						erase_1x,
						erase_2x,
						erase_3x,
						erase_4x,
						erase_5x,
						
						input [7:0] draw_0y, // the max y dimension is 240 therefore, 8'b11110000
						draw_1y,
						draw_2y,
						draw_3y,
						draw_4y,
						draw_5y,
						
						// need an erase for each ydraw
						erase_0y,
						erase_1y,
						erase_2y,
						erase_3y,
						erase_4y,
						erase_5y,
						
						input [5:0] main_st,
						output reg isDrawingDone, vga_en,
						output reg [5:0] draw_en, erase_en,
						
						output reg [8:0] xOutput,
						output reg [7:0] yOutput,
						output reg [2:0] color_out,
						output reg [4:0] current_St);
						
						reg [4:0] next_st;
						
						// initialize all of the states
						
						localparam  WAIT = 4'd0,
										ERASELINE_0 = 4'd1,
										DRAW_LINE0 = 4'd2,
										ERASELINE_1 = 4'd3,
										DRAW_LINE1 = 4'd4,
										ERASELINE_2 = 4'd5,
										DRAW_LINE2 = 4'd6,
										ERASELINE_3 = 4'd7,
										DRAW_LINE3 = 4'd8,
										ERASELINE_4 = 4'd9,
										DRAW_LINE4 = 4'd10,
										ERASELINE_5 = 4'd11,
										DRAW_LINE5 = 4'd12,
										DONE = 4'd13;

						// initializing the beginning state as "WAIT"
						initial current_St = WAIT;
						
						always @(posedge clock)
						begin: stateTable// start of state_table
							case (current_St)
								WAIT: next_st = draw_go ? ERASELINE_0 : WAIT;
								
								ERASELINE_0: next_st = erase_done[0] ? DRAW_LINE0 : ERASELINE_0;
								DRAW_LINE0: next_st = drawdone[0] ? ERASELINE_1 : DRAW_LINE0;
								
								ERASELINE_1: next_st = erase_done[1] ? DRAW_LINE1: ERASELINE_1;
								DRAW_LINE1: next_st = drawdone[1] ? ERASELINE_2 : DRAW_LINE1;
								
								ERASELINE_2: next_st = erase_done[2] ? DRAW_LINE2: ERASELINE_2;								
								DRAW_LINE2: next_st = drawdone[2] ? ERASELINE_3 : DRAW_LINE2;
								
								ERASELINE_3: next_st = erase_done[3] ? DRAW_LINE3 : ERASELINE_3;
								DRAW_LINE3: next_st = drawdone[3] ? ERASELINE_4: DRAW_LINE3;
								
								ERASELINE_4: next_st = erase_done[4] ? DRAW_LINE4 : ERASELINE_4;
								DRAW_LINE4: next_st = drawdone[4] ? ERASELINE_5 : DRAW_LINE4;
								
								ERASELINE_5: next_st = erase_done[5] ? DRAW_LINE5: ERASELINE_5;
								DRAW_LINE5: next_st = drawdone[5] ? DONE : DRAW_LINE5;
								
								DONE: next_st = draw_go ? DONE : WAIT;
								
								default: next_st = WAIT;
							endcase
					end // end of state table
					
					always @(*) begin: enableSignals// enabling all signals
						isDrawingDone = 1'b0;
						vga_en = 1'b0;
						draw_en = 6'b000000;
						erase_en = 6'b000000;
						
						case (current_St)
							ERASELINE_0 : begin
								erase_en[0] = 1'b1;
								xOutput = erase_0x;
								yOutput = erase_0y;
								color_out = {erase_color[0], erase_color[0], erase_color[0]};
								vga_en = 1'b1;
								
							end
							DRAW_LINE0 : begin
								draw_en[0] = 1'b1;
								xOutput = draw_0x;
								yOutput = draw_0y;
								color_out = {draw_color[0], draw_color[0], draw_color[0]};
								vga_en = 1'b1;
						   end
							
							ERASELINE_1 : begin
								erase_en[1] = 1'b1;
								xOutput = erase_1x;
								yOutput = erase_1y;
								color_out = {erase_color[1], erase_color[1], erase_color[1]};
								vga_en = 1'b1;
							end
							DRAW_LINE1 : begin
								draw_en[1] = 1'b1;
								xOutput = draw_1x;
								yOutput = draw_1y;
								color_out = {draw_color[1], draw_color[1], draw_color[1]};
								vga_en = 1'b1;
						   end
							
							ERASELINE_2 : begin
								erase_en[2] = 1'b1;
								xOutput = erase_2x;
								yOutput = erase_2y;
								color_out = {erase_color[2], erase_color[2], erase_color[2]};
								vga_en = 1'b1;
							end
							DRAW_LINE2 : begin
								draw_en[2] = 1'b1;
								xOutput = draw_2x;
								yOutput = draw_2y;
								color_out = {draw_color[2], draw_color[2], draw_color[2]};
								vga_en = 1'b1;
							end
							
							ERASELINE_3 : begin
								erase_en[3] = 1'b1;
								xOutput = erase_3x;
								yOutput = erase_1y;
								color_out = {erase_color[3], erase_color[3], erase_color[3]};
								vga_en = 1'b1;
							end							
							DRAW_LINE3 : begin
								draw_en[3] = 1'b1;
								xOutput = draw_3x;
								yOutput = draw_3y;
								color_out = {draw_color[3], draw_color[3], draw_color[3]};
								vga_en = 1'b1;
						   end
							
							ERASELINE_4 : begin
								erase_en[4] = 1'b1;
								xOutput = erase_4x;
								yOutput = erase_4y;
								color_out = {erase_color[4], erase_color[4], erase_color[4]};
								vga_en = 1'b1;
							end
							DRAW_LINE4 : begin
								draw_en[4] = 1'b1;
								xOutput = draw_4x;
								yOutput = draw_4y;
								color_out = {draw_color[4], draw_color[4], draw_color[4]};
								vga_en = 1'b1;
							end
							
							ERASELINE_5 : begin
								erase_en[5] = 1'b1;
								xOutput = erase_5x;
								yOutput = erase_5y;
								color_out = {erase_color[5], erase_color[5], erase_color[5]};
								vga_en = 1'b1;
							end
							DRAW_LINE5 : begin
								draw_en[5] = 1'b1;
								xOutput = draw_5x;
								yOutput = draw_5y;
								color_out = {draw_color[5], draw_color[5], draw_color[5]};
								vga_en = 1'b1;		
							end
							
							DONE : begin
								isDrawingDone = 1'b1;
								xOutput = 9'b0;
								yOutput = 8'b0;
								color_out = 3'b111;
							end
							default: begin
								xOutput = 9'b0;
								yOutput = 8'b0;
								color_out = 3'b111;
							end
						endcase
				end // end enabling signals
				
				// setting the current state
				always @(posedge clock) begin //state FF
					if(!resetn | (!startn & main_st == 5'd0))
						current_St <= WAIT;
					else
						current_St <= next_st;
				end // end of the flip flop
endmodule

module drawProg(input clock, draw_en,
					input [3:0] line_id,
					input [2:0] line_above,
					input [5:0] offset,
					
					output reg [8:0] x,
					output reg [7:0] y,
					output reg color, drawdone);
					
					reg [7:0] line_id_offset;
					
					localparam black = 1'b0,
									white = 1'b1;
					
					always @(*)
						line_id_offset = line_id * 40;
					
					always @(*)
						y = line_id_offset + offset;
						
					always @(posedge clock) begin
						if(!draw_en)
							case(line_above)
								3'b000: begin
									x <= 140;
									drawdone <= 1'b0;
									color <= white;
								end
								3'b001: begin
									x <= 120;
									drawdone <= 1'b0;
									color <= black;
								end
								3'b010: begin
									x <= 140;
									drawdone <= 1'b0;
									color <= black;
								end
								3'b011: begin
									x <= 160;
									drawdone <= 1'b0;
									color <= black;
								end
								3'b100: begin
									x <= 180;
									drawdone <= 1'b0;
									color <= black;
								end
								default: begin
									x <= 140;
									drawdone <= 1'b0;
									color <= white;
								end
						endcase
					else
						// start incrementing x values
						
						case(line_above)
							3'b000:
								drawdone <= 1'b1;
							3'b001: begin
								if(x == 139)
									drawdone <= 1'b1;
								else
									x = x + 1;
							end
							3'b010: begin
								if(x == 159)
									drawdone <= 1'b1;
								else
									x = x + 1;
							end
							3'b011: begin
								if(x == 179)
									drawdone <= 1'b1;
								else
									x = x + 1;
							end
							3'b100: begin
								if(x == 199)
									drawdone <= 1'b1;
								else
									x = x + 1;
							end
							default:
								drawdone <= 1'b1;
					 endcase
				end
endmodule

module eraseProg(input clock, erase_en,
						input[3:0] line_id,
						input [2:0] line_below,
						input [5:0] offset,
						
						output reg [8:0] x,
						output reg [7:0] y,
						output color,
						output reg erase_done);
						
						reg [7:0] line_id_offset;
						
						assign color = 1'b1; // it'll "erase" by drawing white
						
						always @(*)
							line_id_offset = line_id * 40;
						
						always @(*)
							y = line_id_offset + offset;
						
						always @(posedge clock) begin
							if(!erase_en)
								case(line_below)
									3'b000 : begin
										x <= 140;
										erase_done <= 1'b0;
									end
									3'b001 : begin
										x <= 120;
										erase_done <= 1'b0;
									end
									3'b010 : begin
										x <= 140;
										erase_done <= 1'b0;
									end
									3'b011 : begin
										x <= 160;
										erase_done <= 1'b0;
									end
									3'b100 : begin
										x <= 180;
										erase_done <= 1'b0;
									end
									default : begin
										x <= 140;
										erase_done <= 1'b0;
									end
							 endcase
						  else
							// start incrementing the x values
							
							case(line_below)
								3'b000:
									erase_done <= 1'b1; // x == 139 after 
								3'b001 : begin
									if(x == 139)
										erase_done <= 1'b1;
									else
										x = x + 1; // shifting over until x == 139
								end
								3'b010 : begin
									if(x == 159)
										erase_done <= 1'b1;
									else
										x = x + 1;
								end
								3'b011 : begin
									if(x == 179)
										erase_done <= 1'b1;
									else
										x = x + 1;
								end
								3'b100 : begin
									if(x == 199)
										erase_done <= 1'b1;
									else
										x = x + 1;
								end
								default:
									erase_done <= 1'b1;
						endcase
					end
endmodule
