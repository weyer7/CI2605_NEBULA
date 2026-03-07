`timescale 1ns / 10ps 

module pid_top(
    input logic clk, n_rst,
    //MCU stuff
    input logic [1:0] ctrl,
    input logic [15:0] mcu_in,
    output logic [14:0] mcu_out,
    output logic busy
    );
    logic error_flag;
    logic read_busy, write_busy;
    logic [3:0] lc;
    logic [15:0] k1, k2, k3;
    logic [16:0] sum_out;

    logic clear;
    assign clear = 0;

    //Initialize the fsm
    pid_state_machine pid(
        .clk(clk),
        .n_rst(n_rst),
        .start(ctrl[0]),
        .start_coeff(ctrl[1]),
        .read_busy(read_busy),
        .load_coeff(lc),
        .write_busy(write_busy),
        .error_flag(error_flag)    
    );

    k1_reg k1_calc(
        .clk(clk),
        .n_rst(n_rst),
        .clear(clear),
        .lc(lc[0]),
        .ren(read_busy),
        .error(mcu_in),
        .k1(k1)
    );

    k2_reg k2_calc(
        .clk(clk),
        .nrst(n_rst),
        .clear(clear),
        .lc(lc[1]),
        .ren(read_busy),
        .error_coeff(mcu_in),
        .k2(k2),
        .overflow(error_flag)
    );

    k3_reg k3_calc(
        .clk(clk),
        .n_rst(n_rst),
        .clear(clear),
        .ren(read_busy),
        .lc(lc[2]),
        .lt(lc[3]),
        .inputs(mcu_in),
        .k3(k3)
    );

    add_reg add_three(
        .clk(clk),
        .n_rst(n_rst),
        .ready(write_busy),
        .clear(clear),
        .t1(k1),
        .t2(k2),
        .t3(k3),
        .sum(sum_out)
    );

    assign mcu_out = sum_out[15:1];
    assign busy = (read_busy == 1'b1 || lc > 'd0 || write_busy == 1'b1);

endmodule    
