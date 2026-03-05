
module ssout(
  input logic clk, n_rst,
  input logic [31:0] state,
  output logic [2:0] ss_enable,
  output logic [7:0] ss_out
);

  logic [2:0] current_disp, next_disp;
  logic [3:0] current_data, next_data;
  logic rollover_flag;
  logic [3:0][3:0] datas;
  logic [3:0] unused_count;
  generate
    genvar i;
    for (i = 0; i < 4; i++) begin
      assign datas[i] = state[i*4+3:i*4];
    end
  endgenerate

  example_counter psc(
    .clk(clk), .n_rst(n_rst),
    .rollover_val(1),
    .clear(0),
    .count_out(unused_count),
    .rollover_flag(rollover_flag),
    .count_enable(1'b1)
  );
  ssdec ssd(.in(current_data),.enable(1),.out(ss_out[6:0]));
  
  // unused 
  assign ss_out[7] = 1'b0;
  
  always_comb begin
    next_disp = current_disp;
    next_data = current_data;

    if (rollover_flag == 1) begin
      next_disp = current_disp + 1;
      next_data = datas[current_disp];
    end 
  end

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      current_disp <= 'b0;
      current_data <= 'b0;
    end else begin
      current_disp <= next_disp;
      current_data <= next_data;
    end
  end

  

  always_comb begin
      ss_enable = current_disp;
  end
  

endmodule

 