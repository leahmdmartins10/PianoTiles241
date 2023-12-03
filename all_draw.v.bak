module all_draw(input clock, resetn, startn, draw_go,
						input [5:0] offset,
						
						input [2:0] line_0,
										line_1,
										line_2,
										line_3,
										line_4,
										line_5,
										line_6,
						input [5:0] main_st,
						output isDrawingDone, vga_en,
						output [8:0] xOutput,
						output [7:0] yOutput,
						output [2:0] colorOutput);
						
						wire [5:0] draw_done,
									  erase_done,
									  draw_color,
									  erase_color,
									  draw_en,
									  erase_en;
						
						wire [8:0] draw_0x, // the max x dimension is 320 therefore, 9'b101000000
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
						erase_5x;
						
						wire [7:0] draw_0y, // the max y dimension is 240 therefore, 8'b11110000
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
						erase_5y;
						
						wire [4:0] current_state;
						
						draw_cont c0(.clock(clock), 
										 .resetn(resetn), 
										 .startn(startn), 
										 .draw_go(draw_go), 
										 .drawdone(draw_done[5:0]),
										 .erase_done(erase_done[5:0]),
										 .draw_color(draw_color[5:0]),
										 .erase_color(erase_color[5:0]),
										 .draw_0x(draw_0x[8:0]),
										 .draw_1x(draw_1x[8:0]),
										 .draw_2x(draw_2x[8:0]),
										 .draw_3x(draw_3x[8:0]),
										 .draw_4x(draw_4x[8:0]),
										 .draw_5x(draw_5x[8:0]),
										 .erase_0x(erase_0x[8:0]),
										 .erase_1x(erase_1x[8:0]),
										 .erase_2x(erase_2x[8:0]),
										 .erase_3x(erase_3x[8:0]),
										 .erase_4x(erase_4x[8:0]),
										 .erase_5x(erase_5x[8:0]),
										 .draw_0y(draw_0x[7:0]),
										 .draw_1y(draw_1x[7:0]),
										 .draw_2y(draw_2x[7:0]),
										 .draw_3y(draw_3x[7:0]),
										 .draw_4y(draw_4x[7:0]),
										 .draw_5y(draw_5x[7:0]),
										 .erase_0y(erase_0x[7:0]),
										 .erase_1y(erase_1x[7:0]),
										 .erase_2y(erase_2x[7:0]),
										 .erase_3y(erase_3x[7:0]),
										 .erase_4y(erase_4x[7:0]),
										 .erase_5y(erase_5x[7:0]),
										 .main_st(main_st[5:0]),
										 
										 .isDrawingDone(isDrawingDone),
										 .vga_en(vga_en),
										 .draw_en(draw_en[5:0]),
										 .erase_en(erase_en[5:0]),
										 .xOutput(xOutput[8:0]),
										 .yOutput(yOutput[7:0]),
										 .color_out(colorOutput),
										 .current_St(current_state[4:0]));
										 
						drawProg draw0(.clock(clock),
									  .draw_en(draw_en[0]),
									  .line_id(4'b0000),
									  .line_above(line_0[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(draw_0x[8:0]),
									  .y(draw_0y[7:0]),
									  .color(draw_color[0]),
									  .drawdone(draw_done[0]));
									  
						drawProg draw1(.clock(clock),
									  .draw_en(draw_en[1]),
									  .line_id(4'b0001),
									  .line_above(line_1[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(draw_1x[8:0]),
									  .y(draw_1y[7:0]),
									  .color(draw_color[1]),
									  .drawdone(draw_done[1]));
									  
						drawProg draw2(.clock(clock),
									  .draw_en(draw_en[2]),
									  .line_id(4'b0010),
									  .line_above(line_2[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(draw_2x[8:0]),
									  .y(draw_2y[7:0]),
									  .color(draw_color[2]),
									  .drawdone(draw_done[2]));
									  
						drawProg draw3(.clock(clock),
									  .draw_en(draw_en[3]),
									  .line_id(4'b0011),
									  .line_above(line_3[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(draw_3x[8:0]),
									  .y(draw_3y[7:0]),
									  .color(draw_color[3]),
									  .drawdone(draw_done[3]));
									  
						drawProg draw4(.clock(clock),
									  .draw_en(draw_en[4]),
									  .line_id(4'b0100),
									  .line_above(line_4[2:0]),
									  .offset(offset[5:0]),
									 
									  .x(draw_4x[8:0]),
									  .y(draw_4y[7:0]),
									  .color(draw_color[4]),
									  .drawdone(draw_done[4]));	
									  
						drawProg draw5(.clock(clock),
									  .draw_en(draw_en[5]),
									  .line_id(4'b0101),
									  .line_above(line_5[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(draw_5x[8:0]),
									  .y(draw_5y[7:0]),
									  .color(draw_color[5]),
									  .drawdone(draw_done[5]));
									  
						eraseProg erase0(.clock(clock),
									  .erase_en(erase_en[0]),
									  .line_id(4'b0000),
									  .line_below(line_1[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(erase_0x[8:0]),
									  .y(erase_0y[7:0]),
									  .color(erase_color[0]),
									  .erase_done(erase_done[0]));			

						eraseProg erase1(.clock(clock),
									  .erase_en(erase_en[1]),
									  .line_id(4'b0001),
									  .line_below(line_2[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(erase_1x[8:0]),
									  .y(erase_1y[7:0]),
									  .color(erase_color[1]),
									  .erase_done(erase_done[1]));
									  
						eraseProg erase2(.clock(clock),
									  .erase_en(erase_en[2]),
									  .line_id(4'b0010),
									  .line_below(line_3[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(erase_2x[8:0]),
									  .y(erase_2y[7:0]),
									  .color(erase_color[2]),
									  .erase_done(erase_done[2]));		
									
						eraseProg erase3(.clock(clock),
									  .erase_en(erase_en[3]),
									  .line_id(4'b0011),
									  .line_below(line_4[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(erase_3x[8:0]),
									  .y(erase_3y[7:0]),
									  .color(erase_color[3]),
									  .erase_done(erase_done[3]));	

						eraseProg erase4(.clock(clock),
									  .erase_en(erase_en[4]),
									  .line_id(4'b0100),
									  .line_below(line_5[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(erase_4x[8:0]),
									  .y(erase_4y[7:0]),
									  .color(erase_color[4]),
									  .erase_done(erase_done[4]));	

						eraseProg erase5(.clock(clock),
									  .erase_en(erase_en[5]),
									  .line_id(4'b0101),
									  .line_below(line_6[2:0]),
									  .offset(offset[5:0]),
									  
									  .x(erase_5x[8:0]),
									  .y(erase_5y[7:0]),
									  .color(erase_color[5]),
									  .erase_done(erase_done[5]));									  
						
endmodule
