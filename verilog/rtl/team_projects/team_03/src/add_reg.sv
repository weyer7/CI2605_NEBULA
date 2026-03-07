`timescale 1ns / 10ps

module add_reg #() (
    input logic clk, n_rst,
    input logic ready,
    input logic clear,
    input logic [15:0] t1, t2, t3,
    output logic [16:0] sum
);
logic [16:0] n_sum;

always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 1'b0) begin
        sum <= 'b0;
    end else if (clear == 1'b1) begin
        sum <= 'b0;
    end else begin
        sum <= n_sum;
    end
end

always_comb begin : N_SUM_LOGIC
    if (ready) begin
        n_sum = t1 + t2 + t3;
    end else begin
        n_sum = sum;
    end
end


endmodule
