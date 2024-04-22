module seq_test_v2 (
    input CLK, RST
);
    localparam P = 15;
    integer arb_seq_count = 0, clk3_count = 0;
    reg [P:0] update_sequence = 0;
    reg first = 0;
    always @(posedge CLK) begin
        if (RST) begin
            update_sequence <= {P{1'b0}};
            clk3_count <= 0;
            arb_seq_count <= 0;
            first <= 1'b1;
        end
        else if (first) begin
            clk3_count <= 0;
            arb_seq_count <= 0;
            update_sequence <= 1;
            first <= 1'b0;
        end
        else if (arb_seq_count < P + 1) begin
            if (clk3_count < 3) begin
                if (clk3_count == 0) begin
                    update_sequence <= 1 << arb_seq_count;
                    clk3_count <= clk3_count + 1;
                end
                else if (clk3_count == 1) begin
                    update_sequence <= {P{1'b0}};
                    clk3_count <= clk3_count + 1;
                end
                else if (clk3_count == 2) begin
                    update_sequence <= (arb_seq_count == P) ? 1 : 1 << (arb_seq_count + 1);
                    clk3_count <= 0;
                    arb_seq_count <= (arb_seq_count == P) ? 0 : arb_seq_count + 1;
                end
            end
        end
    end
endmodule