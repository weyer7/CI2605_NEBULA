// $Id: $
// File name:   team_04.sv
// Created:     
// Author:      
// Description: 

`default_nettype none

module team_04 (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.
    
    // Logic Analyzer - Grant access to all 128 LA
    // input logic [31:0] la_data_in,
    // output logic [31:0] la_data_out,
    // input logic [31:0] la_oenb,


    // Wishbone master interface
    // output wire [31:0] ADR_O,
    // output wire [31:0] DAT_O,
    // output wire [3:0]  SEL_O,
    // output wire        WE_O,
    // output wire        STB_O,
    // output wire        CYC_O,
    // input wire [31:0]  DAT_I,
    // input wire         ACK_I,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  logic [33:0] gpio_in, // Breakout Board Pins
    output logic [33:0] gpio_out, // Breakout Board Pins
    output logic [33:0] gpio_oeb // Active Low Output Enable
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */

    // You can also have input registers controlled by the Caravel Harness's on chip processor
);

    intro_2_stopwatch STOPWATCH_INST (
        .BTN(gpio_in[3:0]),
        .CLK_10MHZ(clk), .n_rst(nrst),
        .D0_AN_0(gpio_out[4]),
        .D0_AN_1(gpio_out[5]),
        .D0_AN_2(gpio_out[6]),
        .D0_AN_3(gpio_out[7]),
        .D0_SEG(gpio_out[15:8])
        // add other input/output as necessary
    );

    assign {gpio_out[3:0], gpio_out[33:16]} = '0;
    assign gpio_oeb = 34'h0000FFF0;

endmodule