`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2024 03:38:29
// Design Name: 
// Module Name: pbit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pbit_tb();

    parameter FLOAT_SIZE = 24;
    parameter INT_SIZE = 8;

    // Parameters
    parameter CLK_PERIOD = 0.05; // Clock period in time units
    
    // Signals
    reg CLK, RST;
    reg [INT_SIZE-1: -FLOAT_SIZE] z;
    wire pbit_val;
    
    // Instantiate the PBIT module
    pbit dut(
        .CLK(CLK),
        .RST(RST),
        .z(z),
        .pbit_val(pbit_val)
    );
    
    // Clock generation
    always #((CLK_PERIOD)/2) CLK = ~CLK;
    
    // Initial stimulus
    initial begin
        // Initialize inputs
        CLK = 0;
        RST = 0;
//        z = 32'h00_000000; // Example input, change as needed
        
//        // Apply reset
//        #5 RST = 1;
//        #5 RST = 0;
        
        // Provide some stimulus
        z = 32'b1111_0110_1100_1100_1100_1100_1100_1101;
        
        #5 RST = 1;
        #5 RST = 0; // Example input, change as needed
        
        // Monitor signals
        $monitor("Time=%0t z=%b pbit_val=%b", $time, z, pbit_val);
        
        // End simulation
        #1000;
        $finish;
    end
    
endmodule
