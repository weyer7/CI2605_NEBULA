// $Id: $
// File name:   top.sv
// Created:     4/13/2025
// Author:      Nicha Muninnimit
// Description: top level module.

`timescale 1ns / 10ps

module t05_top (
    input logic [13:0] keypad_i,
    input logic clk, n_rst,

    output logic pwm
);

    logic [3:0] keycode;
    logic modekey, done, sample_now;
    logic [15:0] divider, count;
    logic [1:0] mode;
    logic [7:0] sample;
    logic pwm1;

    t05_keypad_encoder keypad (.*);

    t05_frequency_LUT freq_div (.*);

    t05_FSM state_machine (.*);

    t05_oscillator oscill (.*);

    t05_clock_divider sample_rate (.*);

    t05_waveshaper_wrap waveshape (.*);
    
    t05_pwm pwm_counter (
        .clk(clk),
        .n_rst(n_rst),
        .sample(sample),
        .done(done),

        .pwm(pwm1)
    );

    assign pwm = (keypad_i == 0) ? 0 : pwm1;


endmodule