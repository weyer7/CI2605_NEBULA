`timescale 1ns / 10ps

module wrapper(
    input logic [17:0] SW,
    input logic CLOCK_50,
	 input [3:0] KEY,    
	 
    output logic [35:0] GPIO
);
	
	logic auto_nRST;
    logic [3:0] auto_nRST_count;

    initial begin
        auto_nRST = 0;
        auto_nRST_count = 0;
    end

    logic nRST;

    assign nRST = KEY[3] & auto_nRST;

    always_ff @(posedge CLOCK_50) begin
        if(auto_nRST_count != 4'hF) begin
            auto_nRST_count <= auto_nRST_count + 1;
            auto_nRST <= '0;
        end else begin
            auto_nRST <= '1;
        end
    end
	
    top synth (
        .clk(CLOCK_50),
        .n_rst(nRST),
        .keypad_i(SW[13:0]),
        .pwm(GPIO[0])
    );

endmodule
