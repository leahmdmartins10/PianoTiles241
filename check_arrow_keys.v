module check_arrow_keys(
    input check_input,
    input wire clock,
    input [2:0] line_6,
	 input [2:0] correct_tile_column,
    output reg up,
	 output reg down, 
	 output reg right, 
	 output reg left,
	 output reg correct_key_pressed,
    // keyboard wires
    inout PS2_DAT,
    inout PS2_CLK
);

    wire [7:0] the_command;
    wire send_command;
    reg incorrect_key, correct_key; // signal to track incorrect key presses
    wire command_was_sent;
    wire error_communication_timed_out;
	 wire received_data_en; 
    wire [7:0] received_data;
  
    // instantiate PS2 controller
    PS2_Controller PS2 (
        .CLOCK_50(clock),
        .the_command(the_command),
        .send_command(send_command),
        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),
        .command_was_sent(command_was_sent),
        .error_communication_timed_out(error_communication_timed_out),
        .received_data(received_data),
        .received_data_en(received_data_en)
    );

    always @ (posedge clock)
    begin
        if (!check_input)
        begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b0;
				correct_key_pressed <= 1'b0;
        end
        else
        begin
            if (received_data_en)
            begin
                // Your existing logic here
                if (received_data == 8'b1111_0000)
                begin
                    up <= 0;
                    down <= 0;
                    left <= 0;
                    right <= 0;
						  correct_key_pressed <= 1'b0;
                end
                else if (received_data == 8'b01110010 && line_6 == correct_tile_column) begin
                    down = 1;
						  correct_key_pressed <= 1'b1;
					 end
                else if (received_data == 8'b01101011 && line_6 == correct_tile_column) begin
                    left <= 1;
						  correct_key_pressed <= 1'b1;
					 end
                else if (received_data == 8'b01110100 && line_6 == correct_tile_column) begin
                    right <= 1;
						  correct_key_pressed <= 1'b1;
					 end
                else if (received_data == 8'b01110101 && line_6 == correct_tile_column) begin
                    up <= 1;
						  correct_key_pressed <= 1'b1;
					 end
            end
        end
    end

endmodule
