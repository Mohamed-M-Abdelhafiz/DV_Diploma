module tb_priority_enc4 ();

reg clk;
reg rst;
reg [3:0] D;
wire [1:0] Y;
wire valid;

integer pass_count = 0;
integer error_count = 0;
integer i;

priority_enc4 dut (
  .clk(clk),
  .rst(rst),
  .D(D),
  .Y(Y),
  .valid(valid)
);

always #5 clk = ~clk;

task reset_dut;
begin
  rst = 1;
  D   = 0;

  @(posedge clk);
  @(posedge clk);

  if (Y !== 2'b00 || valid !== 0) begin
    $display("RESET ERROR: Y=%b valid=%b", Y, valid);
    error_count = error_count + 1;
  end
  else begin
    $display("RESET PASS");
    pass_count = pass_count + 1;
  end

  rst = 0;
end
endtask

task check_output;
input [3:0] in;

reg [1:0] expected_Y;
reg expected_valid;

begin
  casex (in)
    4'b1000: expected_Y = 2'b00;
    4'bx100: expected_Y = 2'b01;
    4'bxx10: expected_Y = 2'b10;
    4'bxxx1: expected_Y = 2'b11;
    default: expected_Y = 2'bxx;
  endcase

  expected_valid = ( (in[3]&in[2]) |
                     (in[3]&in[1]) |
                     (in[3]&in[0]) |
                     (in[2]&in[1]) |
                     (in[2]&in[0]) |
                     (in[1]&in[0]) );

  if (in == 4'b0000) begin
    if (valid !== expected_valid) begin
      $display("ERROR: D=%b | valid=%b | Expected valid=%b",
                in, valid, expected_valid);
      error_count = error_count + 1;
    end
    else begin
      $display("PASS: D=%b", in);
      pass_count = pass_count + 1;
    end
  end
  else begin
    if (Y !== expected_Y || valid !== expected_valid) begin
      $display("ERROR: D=%b | Y=%b valid=%b | Expected Y=%b valid=%b",
                in, Y, valid, expected_Y, expected_valid);
      error_count = error_count + 1;
    end
    else begin
      $display("PASS: D=%b", in);
      pass_count = pass_count + 1;
    end
  end
end
endtask

initial begin
  clk = 0;
  rst = 0;
  D   = 0;

  reset_dut();

  for (i = 0; i < 16; i = i + 1) begin
    D = i;

    @(posedge clk);
    @(posedge clk);

    check_output(D);
  end

  $display("=================================");
  $display("PASS COUNT  = %0d", pass_count);
  $display("ERROR COUNT = %0d", error_count);
  $display("=================================");

  $finish;
end

endmodule
