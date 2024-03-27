`timescale 1ns / 1ps

module pbit_test();


    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in time units

    // Signals
    reg CLK, RST;
    wire m1;
    reg [5 : 0] z;
    reg [5 : 0] i;
    integer count1 = 0;
    integer count0 = 0;
   
    always #((CLK_PERIOD)/2) CLK = ~CLK;

    pbit #(.INIT(2100000000)) my_pbit (.CLK(CLK), .RST(RST), .en(1'b1), .z(z), .pbit_val(m1)); 
    always @(posedge CLK) begin
        case(m1) 
            1'b1: count1 <= count1 + 1;
            1'b0: count0 <= count0 + 1;
        endcase
    end
    // Initial stimulus
    initial begin
        // Initialize inputs
        CLK = 1;
        RST = 0;
        z = 0;

        // Apply reset
//        #30 RST = 0;

        
        for (i = 1 ; i < 16 ; i = i + 1) begin
            #80 z = i;
        end
        for (i = 48 ; i < 64 ; i = i + 1) begin
            #80 z = i;
        end
       
    end
endmodule