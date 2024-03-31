module seq_test (
    input CLK, RST
);
    integer arb_seq_count = 0;
    integer clk3_count = 0;
    reg [4:0] update_sequence;
    reg first = 0;
    
    always @(posedge CLK) begin

        if (RST) begin
            clk3_count <= 0;
            arb_seq_count <= 0;
            update_sequence <= 5'b00000;
            first <= 1;
        end

        else if (first) begin
            clk3_count <= 0;
            arb_seq_count <= 0;
            update_sequence <= 5'b00001;
            first <= 0;
        end

        else if(arb_seq_count == 0) begin
            if(clk3_count == 1) begin
                update_sequence <= 5'b00000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 5'b00010;
                arb_seq_count <= 1;
                clk3_count <= 0;
            end else begin
                update_sequence <= 5'b00001;
                clk3_count <= clk3_count + 1;
            end
        end

        else if (arb_seq_count == 1) begin
            if(clk3_count == 1) begin
                update_sequence <= 5'b00000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 5'b00100;
                arb_seq_count <= 2;
                clk3_count <= 0;
            end else begin
                update_sequence <= 5'b00010;
                clk3_count <= clk3_count + 1;
            end
        end

        else if (arb_seq_count == 2) begin
            if(clk3_count == 1) begin
                update_sequence <= 5'b00000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 5'b01000;
                arb_seq_count <= 3;
                clk3_count <= 0;
            end else begin
                update_sequence <= 5'b00100;
                clk3_count <= clk3_count + 1;
            end
        end

        else if (arb_seq_count == 3) begin
            if(clk3_count == 1) begin
                update_sequence <= 5'b00000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 5'b10000;
                arb_seq_count <= 4;
                clk3_count <= 0;
            end else begin
                update_sequence <= 5'b01000;
                clk3_count <= clk3_count + 1;
            end
        end

        else if (arb_seq_count == 4) begin
            if(clk3_count == 1) begin
                update_sequence <= 5'b00000;
                clk3_count <= clk3_count + 1;
            end 
            else if (clk3_count == 2) begin
                update_sequence <= 5'b00001;
                arb_seq_count <= 0;
                clk3_count <= 0;
            end else begin
                update_sequence <= 5'b10000;
                clk3_count <= clk3_count + 1;
            end
        end

        else begin
            update_sequence <= 5'b00000;
            arb_seq_count <= 0;
            clk3_count <= 0;
        end
    end
endmodule