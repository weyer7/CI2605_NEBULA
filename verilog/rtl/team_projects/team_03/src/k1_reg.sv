
module k1_reg (
    input logic clk, n_rst,
    input logic clear, lc, ren,
    input logic [15:0] kp,
    input logic [15:0] error,
    output logic [15:0] k1 // Return Q4.12
);
    logic [15:0] kp_term, n_kp_term; // This register is Q2.14
    logic [15:0] err_term, n_err_term; // This register is Q9.7
    /* verilator lint_off UNUSEDSIGNAL */
    logic [31:0] intermed0, intermed1, intermed;
    /* verilator lint_on UNUSEDSIGNAL */

    always_ff @(posedge clk, negedge n_rst) begin
        if (n_rst == 1'b0) begin
            kp_term <= 0;
            err_term <= 0;
        end else begin
            kp_term <= n_kp_term;
            err_term <= n_err_term;
        end
    end

    /*else if (clear == 1'b1) begin 
            kp_term <= 0;
            err_term <= 0;
        end */

    always_comb begin : UPDATE_PARAMS
        n_kp_term = kp_term;
        n_err_term = err_term; //default
        if (clear == 1'b1) begin
            n_err_term = 0;
            n_kp_term = 0;
        end else begin
            if (lc == 1'b1) begin
                n_kp_term = kp;
            end

            if (ren == 1'b1) begin
                n_err_term = error;
            end
        end
    end


    dadda d1(
        .x(err_term),
        .y(kp_term),
        .z0(intermed0),
        .z1(intermed1)
    );
    
    assign intermed = intermed0 + intermed1;
    /* verilator lint_off UNUSEDSIGNAL */
    assign k1 = intermed[24:9]; // Result is Q4.12 
    /* verilator lint_on UNUSEDSIGNAL */
      
endmodule
