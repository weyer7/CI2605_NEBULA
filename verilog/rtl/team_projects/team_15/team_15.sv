// $Id: $
// File name:   team_15.sv
// Created:     
// Author:      
// Description: 

`default_nettype none

module team_15 (
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
    logic [31:0] io_in, io_out, io_oeb;
    fpga #(
        .BUS_WIDTH(16)
    ) FPGA_INST (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),
        .vssd1(vssd1),
    `endif
        //CRAM signals
        .clk(gpio_in[0]), .nrst(nrst), .config_en(gpio_in[1]),
        .config_data_in(gpio_in[2]),
        .config_data_out(gpio_out[3]), .cfg_done(gpio_out[4]),
        .cfg_error(gpio_out[6:5]),

        //configurable logic signals
        .le_en(gpio_in[7]), .le_nrst(gpio_in[8]),
        //NORTH
        .io_north_in(io_in),
        .io_north_out(io_out),
        .io_north_oeb(io_oeb)
        
        //SOUTH
        // input logic [BUS_WIDTH * 2 - 1:0] io_south_in,
        // output logic [BUS_WIDTH * 2 - 1:0] io_south_out,
        // output logic [BUS_WIDTH * 2 - 1:0] io_south_oeb,

        // //EAST
        // input logic [BUS_WIDTH * 2 - 1:0] io_east_in,
        // output logic [BUS_WIDTH * 2 - 1:0] io_east_out,
        // output logic [BUS_WIDTH * 2 - 1:0] io_east_oeb,
        
        // //WEST
        // input logic [BUS_WIDTH * 2 - 1:0] io_west_in,
        // output logic [BUS_WIDTH * 2 - 1:0] io_west_out
        // output logic [BUS_WIDTH * 2 - 1:0] io_west_oeb,
    );

    assign gpio_out[33:9] = io_out[24:0];
    assign {gpio_out[2:0], gpio_out[8:7]} = '0;
    assign io_in[24:0] = gpio_in[33:9];
    assign io_in[31:25] = '0;
    assign gpio_oeb[33:9] = io_oeb[24:0];
    assign gpio_oeb[8:0] = 9'h1F8;

endmodule