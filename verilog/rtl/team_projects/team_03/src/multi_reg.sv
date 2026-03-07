`timescale 1ns / 10ps 

module multi_reg #() (
    input logic clk, n_rst,
    input logic [15:0] term1,
    input logic [15:0] term2,
    output logic [31:0] out
);
    always_ff @(posedge clk, negedge n_rst) begin
        if (n_rst == 1'b0) begin
            out <= 32'b0;
        end else begin
            out <= term1 * term2;
        end
    end

endmodule
