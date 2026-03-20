module tb;

reg clk, reset;
reg signed [3:0] A;
reg signed [3:0] B;
wire signed [4:0] C;

integer error_count;
integer correct_count;

localparam Add = 2'b00,
           Sub = 2'b01,
           Not_A = 2'b10,
           ReductionOR_B = 2'b11;

localparam MAXPOS = 7,
           ZERO   = 0,
           MAXNEG = -8;

reg [1:0] Opcode;

ALU_4_bit DUT (.*);

initial begin
    clk = 0;
    forever #1 clk = !clk;
end

initial begin
    error_count = 0;
    correct_count = 0;
    A = 0;
    B = 0;
    Opcode = 0;

    assert_reset;

    A=MAXNEG; B=MAXNEG;
    Opcode = Add;
    check_result(Opcode, A, B, -16);
    Opcode = Sub;
    check_result(Opcode, A, B, ZERO);

    A=MAXNEG; B=ZERO;
    Opcode = Add;
    check_result(Opcode, A, B, MAXNEG);
    Opcode = Sub;
    check_result(Opcode, A, B, MAXNEG);

    A=MAXNEG; B=MAXPOS;
    Opcode = Add;
    check_result(Opcode, A, B, -1);
    Opcode = Sub;
    check_result(Opcode, A, B, -15);

    A=ZERO; B=MAXNEG;
    Opcode = Add;
    check_result(Opcode, A, B, MAXNEG);
    Opcode = Sub;
    check_result(Opcode, A, B, 8);

    A=ZERO; B=ZERO;
    Opcode = Add;
    check_result(Opcode, A, B, ZERO);
    Opcode = Sub;
    check_result(Opcode, A, B, ZERO);

    A=ZERO; B=MAXPOS;
    Opcode = Add;
    check_result(Opcode, A, B, MAXPOS);
    Opcode = Sub;
    check_result(Opcode, A, B, -7);

    A=MAXPOS; B=MAXNEG;
    Opcode = Add;
    check_result(Opcode, A, B, -1);
    Opcode = Sub;
    check_result(Opcode, A, B, 15);

    A=MAXPOS; B=ZERO;
    Opcode = Add;
    check_result(Opcode, A, B, MAXPOS);
    Opcode = Sub;
    check_result(Opcode, A, B, MAXPOS);

    A=MAXPOS; B=MAXPOS;
    Opcode = Add;
    check_result(Opcode, A, B, 14);
    Opcode = Sub;
    check_result(Opcode, A, B, ZERO);

    Opcode = Not_A;
    A = 4'b0000;
    check_result(Opcode, A, B, 5'b11111);

    A = 4'b1111;
    check_result(Opcode, A, B, 5'b00000);

    Opcode = ReductionOR_B;

    B = 4'b0000;
    check_result(Opcode, A, B, 0);

    B = 4'b0001;
    check_result(Opcode, A, B, 1);

    B = 4'b0010;
    check_result(Opcode, A, B, 1);

    B = 4'b0100;
    check_result(Opcode, A, B, 1);

    B = 4'b1000;
    check_result(Opcode, A, B, 1);

    Opcode = Add;
    check_result(Opcode, A, B, -1);
    Opcode = Sub;
    check_result(Opcode, A, B, 13);
    Opcode = Not_A;
    check_result(Opcode, A, B, 5'b11010);
    Opcode = ReductionOR_B;
    check_result(Opcode, A, B, 1);

    assert_reset;

    $display("At end of test error count is %0d and correct count is %0d", error_count, correct_count);
    $stop;
end

task check_result(input [1:0] Opcode,
                  input signed [3:0] A,
                  input signed [3:0] B,
                  input signed [4:0] expected_result);
begin
    @(negedge clk);
    if (expected_result != C) begin
        error_count = error_count + 1;
        $display("Error: Opcode=%b A=%0d B=%0d Expected=%0d Got=%0d",
                  Opcode, A, B, expected_result, C);
    end
    else begin
        correct_count = correct_count + 1;
    end
end
endtask

task assert_reset;
begin
    reset = 1;
    @(negedge clk);
    if (C != 0) begin
        error_count = error_count + 1;
    end
    reset = 0;
end
endtask

endmodule
