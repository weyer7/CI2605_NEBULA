`default_nettype none

module intro_2_rng (
  // I/O ports
  input logic clk, n_rst,

  input logic [7:0] ui_in,
  input logic [7:0] uio_in,
  output logic [7:0] uio_out,
  output logic [7:0] uo_out
);
    logic [20:0] pb_unused;
    logic [7:0] left_unused,
              right_unused,
              ss7_unused,
              ss6_unused,
              ss5_unused,
              ss4_unused,
              ss3_unused,
              ss2_unused,
              ss1_unused,
              ss0_unused;

    top_rng #(.FPGA_USED(0)) top_rng_inst (
        .clk(clk), .n_rst(n_rst),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_in(uio_in),
        .ss7(ss7_unused),
        .ss6(ss6_unused),
        .ss5(ss5_unused),
        .ss4(ss4_unused),
        .ss3(ss3_unused),
        .ss2(ss2_unused),
        .ss1(ss1_unused),
        .ss0(ss0_unused)
    );
endmodule
