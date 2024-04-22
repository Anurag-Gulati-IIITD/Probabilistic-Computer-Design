`timescale 1ns / 1ps
// TBD: For every new request at this level module - reset count and take deterministic output/input as the result after running for a decisive number of clock cycles.
module pbit_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in time units
    parameter P = 7; // = no_of_pbits - 1
    parameter P2 = 3;
    parameter P3 = 1;

    // Signals
    reg CLK, RST;
    reg MODE, valid_in;
    reg [P3:0] in1;
    reg [P3:0] in2;
    reg [P2:0] op;
    wire [P2:0] res;
    wire valid_res;

    task NewMulReq(input type, input [P2 : 0] fixed_bits); begin// 00, 01, 11
        if(type == 0) begin
            valid_in = 1'b1;
            {in2, in1} = fixed_bits;
            MODE = type;
        end else begin
            valid_in = 1'b1;
            op = fixed_bits;
            MODE = type;
        end
        #(CLK_PERIOD) valid_in = 1'b0;
    end
    endtask

    
    // Clock generation
    always #((CLK_PERIOD)/2) CLK = ~CLK;

    multiplier_two_bit multiplier_inst (.CLK(CLK), .RST(RST), .MODE(MODE), .valid_in(valid_in), .in1(in1), .in2(in2), .op(op), .res(res), .valid_res(valid_res));

    integer i;
    initial begin
        // Initialize inputs
        CLK = 1;
        RST = 1;
        valid_in = 0;
        MODE = 0;
        in1 = 0;
        in2 = 0;
        op = 0;
        

        // Apply reset
        #(CLK_PERIOD) RST = 0;
        #(CLK_PERIOD) NewMulReq(0, 4'he);     // 1110
        wait (valid_res == 1)
            #(CLK_PERIOD) NewMulReq(1, 4'h2); // 0010
        wait (valid_res == 1)
            #(CLK_PERIOD) NewMulReq(1, 4'h4); // 0100
        wait (valid_res == 1)
            #(CLK_PERIOD) NewMulReq(1, 4'h6); // 0110
        
    end
endmodule