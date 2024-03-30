`timescale 1ns / 1ps

module pbit_tb();


    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in time units

    // Signals
    reg CLK, RST;
    wire m3, m2, m1;
    integer count [7 : 0];
    reg clk_div6;
    reg [2 : 0] count2;

    integer i;
    // wire signed [INT_SIZE-1:-FLOAT_SIZE] out1, out2, out3;

    // Define the flattened bitstreams for weights
    // reg signed [32*3-1:0] weight1;
    // reg signed [32*3-1:0] weight2;
    // reg signed [32*3-1:0] weight3;
    // wire [31 : 0] lfsr_out;
    // Instantiate the Top_level module
    // Top_level #(FLOAT_SIZE, INT_SIZE) dut (
    //     .CLK(CLK),
    //     .EN(1'b1), // Always enable for simplicity in this testbench
    //     .b1(8'h01), // Set bias b1 = +1
    //     .b2(-8'h01), // Set bias b2 = -1
    //     .b3(-8'h02), // Set bias b3 = -2
    //     .weight1(weight1), // Pass the flattened bitstream for the 1st row of J
    //     .weight2(weight2), // Pass the flattened bitstream for the 2nd row of J
    //     .weight3(weight3), // Pass the flattened bitstream for the 3rd row of J
    //     .out1(out1),
    //     .out2(out2),
    //     .out3(out3)
    // );
    // LFSR L1 (.clk(CLK), .rst(RST), .LFSROut(lfsr_out));
    // Clock generation
    always #((CLK_PERIOD)/2) CLK = ~CLK;

    always @(posedge CLK) begin
        if(RST) begin
            clk_div6 <= 0;
            count2 <= 0;
        end
        else if (count2 == 2) begin
            clk_div6 <= ~clk_div6;
            count2 <= 0;
        end
        else begin
            count2 <= count2 + 1;
        end
    end
    always @(posedge clk_div6) begin
        case({m1, m2, m3}) 
            3'b000: count[0] = count[0] + 1;
            3'b001: count[1] = count[1] + 1;
            3'b010: count[2] = count[2] + 1;
            3'b011: count[3] = count[3] + 1;
            3'b100: count[4] = count[4] + 1;
            3'b101: count[5] = count[5] + 1;
            3'b110: count[6] = count[6] + 1;
            3'b111: count[7] = count[7] + 1;
        endcase
    end
    // pbit pbit_inst(.CLK(CLK), .RST(RST), .en(EN), .z(z), .pbit_val(m_i));
    Top_level TT (.CLK(CLK), .RST(RST), .out1(m1), .out2(m2), .out3(m3));
    // Initial stimulus
    initial begin
        // Initialize inputs
        CLK = 1;
        RST = 1;
        for (i = 0 ; i < 8 ; i = i + 1) begin
            count[i] = 0;
        end
        // m_1 = 0;
        // m_2 = 0;
        // m_3 = 0;
        // Provide some stimulus


        // Apply reset
        #10 RST = 0;


        // Assign actual values for the J matrix
        // weight1 = {32'h0000_0000, 32'hFFFFFFFF, 32'h0000_0002};
        // weight2 = {32'hFFFFFFFF, 32'h0000_0000, 32'h0000_0002};
        // weight3 = {32'h0000_0002, 32'h0000_0002, 32'h0000_0000};

        // // Monitor signals
        // $monitor("Time=%0t z=%b out1=%b out2=%b out3=%b", $time, z, out1, out2, out3);

        // // End simulation
        // #1000;
        // $finish;
    end
endmodule