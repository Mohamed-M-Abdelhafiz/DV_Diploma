module DSP_tb;

logic [17:0] A, B, D, adder_out;
logic [47:0] C;
logic clk, rst_n;
logic [47:0] P, mult_out, P_exp;

integer error_count;
integer correct_count;

DSP DUT(.*);

// Create the clock
initial begin
    clk = 0;
    forever #1 clk = !clk;
end

// Stimulus Generation
initial begin
    error_count = 0;
    correct_count = 0;

    A = 0;
    B = 0;
    C = 0;
    D = 0;

    assert_reset;

    repeat (10000) begin
        A = $random();
        B = $random();
        C = $random();
        D = $random();

        adder_out = B + D;
        mult_out  = adder_out * A;
        P_exp     = mult_out + C;

        check_result;
    end

    check_reset;

    $display("%t: At end of test error count is %0d and correct count is %0d",
              $time, error_count, correct_count);
    $stop;
end

// Checker
task check_result();
begin
    repeat (4) @(negedge clk);
    if (P_exp != P) begin
        error_count = error_count + 1;
        $display("Error: P_exp=%0d P=%0d A=%0d B=%0d",
                  P_exp, P, A, B);
    end
    else begin
        correct_count = correct_count + 1;
    end
end
endtask

task check_reset;
begin
    rst_n = 0;
    @(negedge clk);
    if (P != 0) begin
        error_count = error_count + 1;
        $display("Error: Reset value is asserted");
    end
    else begin
        correct_count = correct_count + 1;
    end
    rst_n = 1;
end
endtask

task assert_reset;
begin
    rst_n = 0;
    @(negedge clk);
    rst_n = 1;
end
endtask

endmodule
