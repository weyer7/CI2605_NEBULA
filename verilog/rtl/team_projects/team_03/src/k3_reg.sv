`timescale 1ns / 10ps 

module k3_reg (
    input logic clk, n_rst,
    input logic [15:0] inputs,
    input logic ren, clear, lc, lt,
    output logic [15:0] k3
);

    logic [15:0] prev_error;
    logic [15:0] kd_term, n_kd_term;
    logic [15:0] error_term, n_error_term;
    logic [15:0] timescaling_term, n_timescaling_term;
    logic [31:0] intermed0, intermed1, intermed2, intermed3, intermed4, intermed;

    always_ff @(posedge clk, negedge n_rst) begin
        if (n_rst == 1'b0) begin
            error_term <= 16'b0;
            prev_error <= 16'b0;
            kd_term <= 16'b0;
            timescaling_term <= 16'b0;
        end
        else begin
            error_term <= n_error_term;
            prev_error <= error_term;
            kd_term <= n_kd_term;
            timescaling_term <= n_timescaling_term;
        end
    end

    always_comb begin
        if(clear == 1'b1) begin
            n_error_term = 16'b0;
            n_kd_term = 16'b0;
            n_timescaling_term = 16'b0;
        end
         
        n_timescaling_term = timescaling_term;
        n_error_term = error_term;

        n_kd_term = kd_term;
        if(lc == 1'b1) begin
            n_kd_term = inputs;
        end

        if(ren == 1'b1) begin
            n_error_term = inputs;
        end

        if(lt == 1'b1) begin
            n_timescaling_term = inputs;
        end
    end
    
    dadda d1 (
      .x(prev_error + error_term),
      .y(n_kd_term),
      .z0(intermed0),
      .z1(intermed1)  
    );

    dadda d2 (
        .x(intermed2[24:9]),
        .y(n_timescaling_term),
        .z0(intermed3),
        .z1(intermed4)
    );
    assign intermed2 = intermed0 + intermed1;
    assign intermed = intermed3 + intermed4;
    assign k3 = intermed[24:9];

endmodule
