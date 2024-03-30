`timescale 1ns/1ps
module seq_test_tb(

);
    parameter CLK_PERIOD = 10; // Clock period in time units

    // Signals
    reg CLK, RST;

    seq_test seq1(.CLK(CLK), .RST(RST));
   
    always #((CLK_PERIOD)/2) CLK = ~CLK;

    initial begin
        CLK = 0; 
        RST = 1;
        #10 RST = 0;
        #120 RST = 1;
        #30 RST = 0;

    end
endmodule