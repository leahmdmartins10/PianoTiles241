module check_arrow_keys(
    input check_input,
    input wire clock,
    input [2:0] line_6,
    output reg up,
	 output reg down, 
	 output reg right, 
	 output reg left, 
 	output reg done,
	output reg incorrect,
	output reg correct,
    // keyboard wires
    inout PS2_DAT,
    inout PS2_CLK
);

    wire [7:0] the_command;
    wire send_command;
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
	    done <= 1'b0; 
	    correct <=1'b0; 
	    incorrect <= 1'b0; 
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
		    done <= 0; 
		    correct <= 0;
		    incorrect <= 0; 
                end
                 if (received_data == 8'b01110010)
                    down = 1;
		    done <= 1;
		    incorrect <= 1;
		    correct <= 0; 
                 if (received_data == 8'b01101011)
                    left <= 1;
		    done <= 1;
		    incorrect <= 1;
		    correct <= 0; 
                 if (received_data == 8'b01110100)
                    right <= 1;
		    done <= 1;
		    correct <= 0;
		    incorrect <= 1; 
                 if (received_data == 8'b01110101)
                    up <= 1;
		    done <= 1;
		    correct <= 0;
		    incorrect <= 1; 
		if(received_data!= 8'b01110010 && received_data !=8'b01101011 && received_data!= 8'b01110100 && received_data!=8'b01110101)
		    done <= 1; 
		    incorrect <= 0; 
		    correct <= 1;  
            end
        end
    end

endmodule
