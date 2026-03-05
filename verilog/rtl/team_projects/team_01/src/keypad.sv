module keypad(
  input logic clk, n_rst,
  input logic [3:0] state,
  input logic [3:0] keypad_row_async,
  output logic [1:0] keypad_col,
  output logic [31:0] mixing
);
  logic clk_psc;
  logic [3:0] keypad_row;
  logic [3:0] unused_count;
  ffsync2 sync_r0(.clk(clk), .n_rst(n_rst),.async_in(keypad_row_async[0]),.sync(keypad_row[0]));
  ffsync2 sync_r1(.clk(clk),.n_rst(n_rst),.async_in(keypad_row_async[1]),.sync(keypad_row[1]));
  ffsync2 sync_r2(.clk(clk),.n_rst(n_rst),.async_in(keypad_row_async[2]),.sync(keypad_row[2]));
  ffsync2 sync_r3(.clk(clk),.n_rst(n_rst),.async_in(keypad_row_async[3]),.sync(keypad_row[3]));

  example_counter psc(
    .clk(clk), .n_rst(n_rst),
    .count_enable(1'b1),
    .rollover_val(4'b1000),
    .rollover_flag(clk_psc),
    /* verilator lint_off PINMISSING */
    .count_out(unused_count),
    /* verilator lint_on PINMISSING */
    .clear(1'b0));

  logic [1:0] n_keypad_col;

  always_ff @(posedge clk_psc,negedge n_rst) begin
    if (n_rst == 0) begin
      keypad_col <= 0;
    end else begin
      keypad_col <= n_keypad_col;
    end
  end

  always_comb begin
    n_keypad_col = keypad_col + 1;
  end

  always_comb begin
    mixing = 'b0;
    if (keypad_row != 0) begin
      case (state) 
        4'h0: mixing  = {26'b0, keypad_col, keypad_row};
        4'h1: mixing  = {24'b0, keypad_col, keypad_row, 2'b0};
        4'h2: mixing  = {22'b0, keypad_col, keypad_row, 4'b0};
        4'h3: mixing  = {20'b0, keypad_col, keypad_row, 6'b0};
        4'h4: mixing  = {18'b0, keypad_col, keypad_row, 8'b0};
        4'h5: mixing  = {16'b0, keypad_col, keypad_row, 10'b0};
        4'h6: mixing  = {14'b0, keypad_col, keypad_row, 12'b0};
        4'h7: mixing  = {12'b0, keypad_col, keypad_row, 14'b0};
        4'h8: mixing  = {10'b0, keypad_col, keypad_row, 16'b0};
        4'h9: mixing  = {8'b0, keypad_col, keypad_row, 18'b0};
        4'ha: mixing  = {6'b0, keypad_col, keypad_row, 20'b0};
        4'hb: mixing  = {5'b0, keypad_col, keypad_row, 21'b0};
        4'hc: mixing  = {4'b0, keypad_col, keypad_row, 22'b0};
        4'hd: mixing  = {3'b0, keypad_col, keypad_row, 23'b0};
        4'he: mixing  = {2'b0, keypad_col, keypad_row, 24'b0};
        4'hf: mixing  = {keypad_col, keypad_row, 26'b0};
      endcase
    end
    mixing = keypad_row == 0 ? 0 : ({26'b0, keypad_col, keypad_row}) << state[3:0];

  end

endmodule