module Top_level(
    input wire CLK, EN,
    input wire signed [INT_SIZE-1:-FLOAT_SIZE] z1, z2, b1, b2, b3,
    input wire signed [INT_SIZE-1:-FLOAT_SIZE] w1[2:0],
    input wire signed [INT_SIZE-1:-FLOAT_SIZE] w2[2:0],
    input wire signed [INT_SIZE-1:-FLOAT_SIZE] w3[2:0],
    output wire signed [INT_SIZE-1:-FLOAT_SIZE] out3, out2, out1
);

parameter FLOAT_SIZE = 24;
parameter INT_SIZE = 8;

wire [INT_SIZE-1:-FLOAT_SIZE] z3_;

pbit bit1(.CLK(CLK), .RST(EN), .z(z1), .pbit_val(out1));
pbit bit2(.CLK(CLK), .RST(EN), .z(z2), .pbit_val(out2));
pbit bit3(.CLK(CLK), .RST(EN), .z(z3_), .pbit_val(out3));

assign z3_ = w1[2]*out1 + w2[2]*out2 + b1 + b2;

always @ (*)
begin
    // A + C -> B
    z2 <= w1[1]*out1 + w3[1]*out3 + b1 + b3;
    
    // B + C -> A    
    z1 <= w2[0]*out2 + w3[0]*out3 + b2 + b3;
end

endmodule
