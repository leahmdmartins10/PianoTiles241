module controlModule(input clk,
								resetn,
								startn,
								reset_screen_done,
								drawdone,
								wait_done,
								check_input_done,
								correct,
								incorrect,
								correct_done,
								incorrect_input_done,
								color_line_done,
								input [5:0] offset,
								input [2:0] line_6,
								
								output reg reset_screen_go,
											  draw_go,
											  wait_go,
											  edge_go,
											  offset_increase,
											  check_input_go,
											  correct_go,
											  incorrect_input_go,
											  color_line_go,
											  light
								
//								output reg [5:0] current_state
							);
																 reg [5:0] current_state;

								reg [5:0] next_st;
								
								localparam WAIT_FOR_START = 5'd0,
											  RESET_SCREEN = 5'd1,
													CHECK_INPUT = 5'd7,
													CORRECT_INPUT = 5'd8,
													INCORRECT_INPUT = 5'd9,
											  DETECT_EDGE = 5'd2,
													EDGE_CHECK = 5'd11,
											  EDGE = 5'd3,
													EDGE_FAIL = 5'd10,
											  DRAW_EN = 5'd4,
											  WAIT_FOR_NEXT = 5'd5,
											  NEXT_ROW = 5'd6;
								
								initial current_state <= WAIT_FOR_START;
								
								always @(*) begin: stateTable
									case(current_state)
										WAIT_FOR_START: next_st <= (startn == 1'b0) ? RESET_SCREEN : WAIT_FOR_START;
										RESET_SCREEN: next_st <= reset_screen_done ? CHECK_INPUT : RESET_SCREEN;
										CHECK_INPUT: begin
											if(startn == 1'b0)
												next_st <= DRAW_EN;
											else if(check_input_done && correct)
												next_st <= CORRECT_INPUT;
											else if(check_input_done && incorrect)
												next_st <= INCORRECT_INPUT;
											else if(check_input_done)
												next_st <= DETECT_EDGE;
											else
												next_st <= CHECK_INPUT;
											end
									  CORRECT_INPUT: next_st <= correct_done ? DETECT_EDGE : CORRECT_INPUT;
									  INCORRECT_INPUT: next_st <= incorrect_input_done ? WAIT_FOR_START : INCORRECT_INPUT;
									  DETECT_EDGE: next_st <= (offset == 6'b101000) ? EDGE_CHECK : DRAW_EN;
									  EDGE_CHECK: next_st <= (line_6 == 3'b000) ? EDGE : EDGE_FAIL;
									  EDGE: next_st <= DRAW_EN;
									  EDGE_FAIL: next_st <= color_line_done ? WAIT_FOR_START : EDGE_FAIL;
									  DRAW_EN: next_st <= drawdone ? WAIT_FOR_NEXT : DRAW_EN;
									  WAIT_FOR_NEXT: next_st <= wait_done ? NEXT_ROW : WAIT_FOR_NEXT;
									  NEXT_ROW: next_st <= CHECK_INPUT;
								 default: next_st <= WAIT_FOR_START;
								 endcase
							 end
							 
							 // setting everything to zero
							 
							 always @(*) begin: enable_signals
								 reset_screen_go = 1'b0;
								 draw_go = 1'b0;
								 wait_go = 1'b0;
								 edge_go = 1'b0;
								 offset_increase = 1'b0;
								 check_input_go = 1'b0;
								 correct_go = 1'b0;
								 incorrect_input_go = 1'b0;
								 color_line_go = 1'b0;
								 
								 case(current_state)
									RESET_SCREEN: begin reset_screen_go = 1'b1;
										light = 1'b1; end
									CHECK_INPUT: begin 
									check_input_go = 1'b1;
										light = 1'b0; end

									CORRECT_INPUT: 
									correct_go = 1'b1;
									
									INCORRECT_INPUT: incorrect_input_go = 1'b1;
									
									EDGE: edge_go = 1'b1;
									EDGE_FAIL: color_line_go = 1'b1;
									DRAW_EN: draw_go = 1'b1;
									WAIT_FOR_NEXT: wait_go = 1'b1;
									NEXT_ROW: offset_increase = 1'b1;
									default: reset_screen_go = 1'b0;
								endcase
							end
							
							always @(posedge clk) begin: stateFlipFlop
								if(!resetn)
									current_state <= WAIT_FOR_START;
								else
									current_state <= next_st;
						   end // end of state ffs
								 
endmodule
