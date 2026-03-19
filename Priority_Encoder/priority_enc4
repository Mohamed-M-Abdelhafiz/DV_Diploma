module priority_enc4 (
input  clk,
input  rst,
input  [3:0] D,	
output reg [1:0] Y,	
output reg valid
);

always @(posedge clk) begin

  if (rst) begin
     Y <= 2'b00;
     valid <= 0;
  end

  else begin

     // Priority Encoder
     casex (D)
        4'b0000: Y <= 2'bxx;
        4'b1000: Y <= 2'b00;
        4'bx100: Y <= 2'b01;
        4'bxx10: Y <= 2'b10;
        4'bxxx1: Y <= 2'b11;
     endcase

     // FIXED VALID LOGIC
     valid <= ( (D[3]&D[2]) |
                (D[3]&D[1]) |
                (D[3]&D[0]) |
                (D[2]&D[1]) |
                (D[2]&D[0]) |
                (D[1]&D[0]) );

  end

end

endmodule
