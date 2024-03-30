module seq_test (
    input CLK, RST
);
    integer arb_seq_count = 0;
    integer clk3_count = 0;
    reg [2:0] update_sequence;
    reg first = 0;
    
    always @(posedge CLK) begin

        if (RST) begin
            clk3_count <= 0;
            arb_seq_count <= 0;
            update_sequence <= 3'b000;
            first <= 1;
        end

        else if (first) begin
            clk3_count <= 0;
            arb_seq_count <= 0;
            update_sequence <= 3'b001;
            first <= 0;
        end

        else if(arb_seq_count == 0) begin
            if(clk3_count == 1) begin
                update_sequence <= 3'b000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 3'b010;
                arb_seq_count <= 1;
                clk3_count <= 0;
            end else begin
                update_sequence <= 3'b001;
                clk3_count <= clk3_count + 1;
            end
        end

        else if (arb_seq_count == 1) begin
            if(clk3_count == 1) begin
                update_sequence <= 3'b000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 3'b100;
                arb_seq_count <= 2;
                clk3_count <= 0;
            end else begin
                update_sequence <= 3'b010;
                clk3_count <= clk3_count + 1;
            end
        end

        else if (arb_seq_count == 2) begin
            if(clk3_count == 1) begin
                update_sequence <= 3'b000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 3'b001;
                arb_seq_count <= 0;
                clk3_count <= 0;
            end else begin
                update_sequence <= 3'b100;
                clk3_count <= clk3_count + 1;
            end
        end

        else begin
            update_sequence <= 3'b000;
            arb_seq_count <= 0;
            clk3_count <= 0;
        end
    end
endmodule