module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,
      
  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);
	logic running;
	logic [3:0]prev_pb1;
  logic [14:0] angle; //example counter

logic[6:0] ten_ones; 
logic [6:0] hundreds;
logic [6:0] thousands;

logic[31:0] temp_ten_ones; 
logic [31:0] temp_hundreds;
logic [31:0] temp_thousands;

always_ff @( posedge hz100 or posedge pb[16] ) begin 
		/*if (pb[0]) begin
			count <= 180;
			running <= 1; //start running again
			prev_pb1 <= 0;
		end
		else begin
			if (pb[1] & ~prev_pb1)
				running <= ~running; //toggle
			
			prev_pb1 <= pb[1]; //save current state

			if (running) 
				count <= count + 1;
		end*/
    if (pb[16]) begin
      count <= 18000;
      prev_pb1 <= 4'b0;
    end
    else begin 
      if (pb[0] & ~prev_pb1[0]) count <= count + 100;
      if (pb[1] & ~prev_pb1[1]) count <= count + 200;
      if (pb[2] & ~prev_pb1[2]) count <= count - 100;
      if (pb[3] & ~prev_pb1[3]) count <= count - 200;

      prev_pb1[0] <= pb[0];
      prev_pb1[1] <= pb[1];
      prev_pb1[2] <= pb[2];
      prev_pb1[3] <= pb[3];
    end
end

always_comb begin
  temp_thousands = ({17'b0, count} / 10000);
  thousands = temp_thousands [6:0];
  temp_hundreds  = (({17'b0, count} % 10000) / 100);
  hundreds = temp_hundreds [6:0];
  temp_ten_ones  = ({17'b0, count} % 100);
  ten_ones = temp_ten_ones [6:0];

end
digit2Display disp_0(
    .value(ten_ones),
    .enable_point(1'b0),
    .left(ss1),
    .right(ss0)
);

digit2Display disp_1(
    .value(hundreds),
    .enable_point(1'b1),
    .left(ss3),
    .right(ss2)
);

digit2Display disp_2(
    .value(thousands),
    .enable_point(1'b0),
    .left(ss5),
    .right(ss4)
);

//turned off
assign ss7 = 0;
assign ss6 = 0;

  
endmodule