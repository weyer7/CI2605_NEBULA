module top_rng #(
    parameter FPGA_USED = 0
) (
    // I/O ports
    input  logic clk, n_rst,
    // FPGA ports
    input  logic [20:0] pb,
    output logic [7:0] ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
    // ASIC ports
    input logic [7:0] ui_in,
    input logic [7:0] uio_in,
    output logic [7:0] uio_out,
    output logic [7:0] uo_out
);
    // define the signals
    logic [31:0] state, next_state;
    logic [31:0] real_next_state;
    logic [31:0] mixing;
    logic [3:0] keypad_row_async;
    logic [1:0] keypad_col;

    logic update_state;
    logic state_ready;
    logic [2:0] ssel;
    logic [7:0] ssd;
    logic [8:0] ecstate_count_out_ignored;


    
    keypad k1(
        .clk(clk), .n_rst(n_rst),
        .state(state[3:0]),
        .keypad_row_async(keypad_row_async),
        .mixing(mixing)
        ,.keypad_col(keypad_col)
    );

    lookuptable lut1 (
        .clk(clk), .n_rst(n_rst),
        .start_generation(update_state),
        .mixer(mixing),
        .state(state),
        .next_state(next_state),
        .next_state_ready(state_ready)
    );

    example_counter #(.SIZE(9)) ecstate(
        .clk(clk), .n_rst(n_rst),
        .rollover_val(500),
        .rollover_flag(update_state),
        .count_enable(1),
        .clear(0),
        .count_out(ecstate_count_out_ignored)
    );

    ssout display (
        .clk(clk), .n_rst(n_rst),
        .state(state),
        .ss_enable(ssel),
        .ss_out(ssd)
    );


    always_comb begin
        real_next_state = state;
        if (state_ready) begin
            real_next_state = next_state;
        end
    end

    
    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            state <= 32'h0000000f;
        end else begin
            state <= real_next_state;
        end
    end

    // Unused signals
    if (FPGA_USED) begin
        assign uo_out[7:5] = 8'b0;
    end else begin
        assign uo_out[7:5] = 3'b0; // unused anyway
        assign ss0[7:0] = 8'b0;
        assign ss1[7:0] = 8'b0;
        assign ss2[7:0] = 8'b0;
        assign ss3[7:0] = 8'b0;
        assign ss4[7:0] = 8'b0;
        assign ss5[7:0] = 8'b0;
        assign ss6[7:0] = 8'b0;
        assign ss7[7:0] = 8'b0;
    end

    // Keypad 
    if (FPGA_USED) begin
        always_comb begin
            keypad_row_async = 4'b0;
            if (keypad_col == 0) begin
                keypad_row_async = pb[3:0];
            end else if (keypad_col == 1) begin
                keypad_row_async = pb[7:4];
            end else if (keypad_col == 2) begin
                keypad_row_async = pb[11:8];
            end else begin
                keypad_row_async = pb[15:12];
            end
        end
        assign uo_out[1:0] = 2'b0;
    end else begin
        assign keypad_row_async = ui_in[3:0];
        assign uo_out[1:0] = keypad_col;
    end

    // SS output
    if (FPGA_USED) begin
        assign ss0[7:0] = (ssel == 3'd0) ? ssd : 8'b0;
        assign ss1[7:0] = (ssel == 3'd1) ? ssd : 8'b0;
        assign ss2[7:0] = (ssel == 3'd2) ? ssd : 8'b0;
        assign ss3[7:0] = (ssel == 3'd3) ? ssd : 8'b0;
        assign ss4[7:0] = (ssel == 3'd4) ? ssd : 8'b0;
        assign ss5[7:0] = (ssel == 3'd5) ? ssd : 8'b0;
        assign ss6[7:0] = (ssel == 3'd6) ? ssd : 8'b0;
        assign ss7[7:0] = (ssel == 3'd7) ? ssd : 8'b0;
        assign uio_out[7:0] = 8'b0;
        assign uo_out[4:2] = 3'b0;
    end else begin
        assign uio_out[7:0] = ssd;
        assign uo_out[4:2] = ssel; 
    end


endmodule
