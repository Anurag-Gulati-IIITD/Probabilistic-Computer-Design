`timescale 1ns / 1ps

module pbit_tb();


    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in time units
    parameter P = 4; // = no_of_pbits - 1
    // Signals
    reg CLK, RST;
    wire [P:0] p_out;
    integer count [2**(P+1) - 1 : 0];
    reg clk_div15 = 1; // no_of_pbits * cycles_per_pbit_update = 5 * 3
    reg [3 : 0] count2;


    
    // Clock generation
    always #((CLK_PERIOD)/2) CLK = ~CLK;

    always @(posedge CLK) begin
        
        if (count2 == 14) begin
            clk_div15 <= ~clk_div15;
            count2 <= 0;
        end
        else begin
            count2 <= count2 + 1;
        end
    end

    always @(negedge CLK) begin
        if(RST) begin
            clk_div15 <= 1;
            count2 <= 0;
        end
        else if (count2 == 14) begin
            clk_div15 <= ~clk_div15;
            count2 <= 0;
        end
        else begin
            count2 <= count2 + 1;
        end
    end

    integer hmm;
    always @(posedge clk_div15) begin
        for(hmm = 0; hmm < 2**(P+1); hmm = hmm + 1) begin
            if (p_out == hmm) begin
                count[hmm] <= count[hmm] + 1;
            end
        end
    end
    // pbit pbit_inst(.CLK(CLK), .RST(RST), .en(EN), .z(z), .pbit_val(m_i));
    Top_level TT (.CLK(CLK), .RST(RST), .out(p_out));
    // Initial stimulus

    integer i;
    initial begin
        // Initialize inputs
        CLK = 1;
        RST = 1;
        for (i = 0 ; i < 2**(P+1) ; i = i + 1) begin
            count[i] = 0;
        end
        


        // Apply reset
        #10 RST = 0;

        // // Monitor signals
        // $monitor("Time=%0t z=%b out1=%b out2=%b out3=%b", $time, z, out1, out2, out3);

        // // End simulation
        // #1000;
        // $finish;
    end
endmodule