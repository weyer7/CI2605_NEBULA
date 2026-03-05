module lookuptable(
  input logic clk, n_rst, start_generation,
  input logic [31:0]mixer,
  input logic [31:0]state,
  output logic next_state_ready,
  output logic [31:0]next_state
);
  logic [5:0] unused_count;
  example_counter #(.SIZE(6)) ecstate(.clk(clk),.n_rst(n_rst),.rollover_val(37), .rollover_flag(next_state_ready),.count_enable(1),.clear(!started),
  /* verilator lint_off PINMISSING */
  .count_out(unused_count)
  /* verilator lint_on PINMISSING */);

  logic started, n_started;

  logic [31:0] internal_state;
  logic [31:0] n_internal_state;

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      internal_state <= 32'b0;
      started <= 0;
    end else begin
      internal_state <= n_internal_state;
      started <= n_started;
    end
  end

  always_comb begin
    n_started = started;
    if (!started && start_generation) begin
      n_started = 1'b1;
    end else if (started && next_state_ready) begin
      n_started = 1'b0;
    end
  end

  always_comb begin
      n_internal_state = internal_state;
      if (start_generation) begin
        n_internal_state = state;
      end else if (started) begin
        n_internal_state = {internal_state[30:0], internal_state[1] ^ internal_state[2] ^ internal_state[4] ^ internal_state[15]};
      end
  end

  assign next_state = internal_state ^ mixer ^ (internal_state[6] ? 32'h31415926 : 0);

endmodule