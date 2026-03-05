module ffsync2 (
  input logic async_in,
  input logic clk, n_rst,
  output logic sync
);
  logic [1:0] sr;
  logic [1:0] n_sr;

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      sr <= 'b0;
    end else begin
      sr <= n_sr;
    end
  end

  assign n_sr = {sr[0], async_in};
  assign sync = sr[1];
endmodule