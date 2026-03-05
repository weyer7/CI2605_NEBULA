module ssdec(
  input logic [3:0] in,
  input logic enable,
  output logic [6:0] out
);

  reg [6:0] map [15:0];

  always_comb begin
    if (enable == 1'b1) begin
      case (in)
        4'd0: out = 7'h3F;
        4'd1: out = 7'h06;
        4'd2: out = 7'h5B;
        4'd3: out = 7'h4F;
        4'd4: out = 7'h66;
        4'd5: out = 7'h6D;
        4'd6: out = 7'h7D;
        4'd7: out = 7'h07;
        4'd8: out = 7'h7F;
        4'd9: out = 7'h67;
        4'd10: out = 7'h77;
        4'd11: out = 7'h7C;
        4'd12: out = 7'h39;
        4'd13: out = 7'h5E;
        4'd14: out = 7'h79;
        4'd15: out = 7'h71;
      endcase
    end
    else begin
      out = 7'b0;
    end
  end

endmodule