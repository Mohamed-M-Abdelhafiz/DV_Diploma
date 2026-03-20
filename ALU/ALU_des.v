module alu (
  input clk,
  input rst,
  input signed [3:0] A,
  input signed [3:0] B,
  input [1:0] opcode,
  output reg signed [4:0] C
);

always @(posedge clk) begin
  if (rst)
    C <= 0;
  else begin
    case (opcode)
      2'b00: C <= A + B;
      2'b01: C <= A - B;
      2'b10: C <= ~A;
      2'b11: C <= |B;
    endcase
  end
end

endmodule
