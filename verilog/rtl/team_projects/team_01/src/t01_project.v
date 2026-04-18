/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_purdue_socet_intro2_f25t4 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  intro_2_rng TOP(
    .clk(clk),
    .n_rst(rst_n),
    .ui_in(ui_in),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uo_out(uo_out)
  );

  assign uio_oe = 8'hFF; // all set to output


  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule
