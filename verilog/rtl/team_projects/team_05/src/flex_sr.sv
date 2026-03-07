// $Id: $
// File name:   clock_divider.sv
// Created:     4/10/2025
// Author:      Nicha Muninnimit
// Description: clock divider

`timescale 1ns / 10ps

module flex_sr #(
    parameter SIZE = 8,
    parameter MSB_FIRST = 1 // shifts right
) (
    input logic clk, n_rst, shift_enable, load_enable,
    input logic serial_in,
    input logic [SIZE-1:0] parallel_in,
    
    output logic [SIZE-1:0] parallel_out,
    output logic serial_out
);
    logic [SIZE-1:0] n_parallel_out;

    always_ff @(posedge clk, negedge n_rst) begin
        if (~n_rst) begin
            parallel_out <= 0;
        end else begin
            parallel_out <= n_parallel_out;
        end
    end

    always_comb begin
        n_parallel_out = parallel_out;
        if (load_enable) begin
            n_parallel_out = parallel_in;
        end else if (shift_enable) begin
            n_parallel_out = (MSB_FIRST)? {parallel_in[SIZE-2:0], serial_in} : {serial_in, parallel_in[SIZE-1:1]};
        end
    end

    assign serial_out = (MSB_FIRST)? parallel_out[SIZE-1]: parallel_out[0];

endmodule