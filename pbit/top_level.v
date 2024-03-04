module Top_level #(parameter FLOAT_SIZE = 24, INT_SIZE = 8) (
    input wire CLK, EN,
    input wire signed [INT_SIZE-1:-FLOAT_SIZE] b1, b2, b3,
    input reg signed [3*(INT_SIZE+FLOAT_SIZE)-1: 0] weight1,
    input reg signed [3*(INT_SIZE+FLOAT_SIZE)-1: 0] weight2,
    input reg signed [3*(INT_SIZE+FLOAT_SIZE)-1: 0] weight3,
    output wire signed [INT_SIZE-1:-FLOAT_SIZE] out3, out2, out1
);
localparam ele = INT_SIZE+FLOAT_SIZE;

wire signed [INT_SIZE-1:-FLOAT_SIZE] z1, z2;
wire [INT_SIZE-1:-FLOAT_SIZE] z3_;

reg [INT_SIZE-1 : -FLOAT_SIZE] w1 [2:0], w2[2:0], w3[2:0];

integer i, j, k;

always @(*) begin
    for (i = 0; i < 3 ; i = i + 1) begin
        w1[i] = weight1[i*ele +: ele];
    end
end
always @(*) begin
    for (j = 0; j < 3 ; j = j + 1) begin
        w2[j] = weight2[j*ele +: ele];
    end
end
always @(*) begin
    for (k = 0; k < 3 ; k = k + 1) begin
        w3[k] = weight3[k*ele +: ele];
    end
end


pbit bit1(.CLK(CLK), .RST(EN), .z(z1), .pbit_val(out1));
pbit bit2(.CLK(CLK), .RST(EN), .z(z2), .pbit_val(out2));
pbit bit3(.CLK(CLK), .RST(EN), .z(z3_), .pbit_val(out3));

assign z3_ = w1[2]*out1 + w2[2]*out2 + b1 + b2;

    // A + C -> B
assign z2 = w1[1]*out1 + w3[1]*out3 + b1 + b3;
    
    // B + C -> A    
assign z1 = w2[0]*out2 + w3[0]*out3 + b2 + b3;


endmodule
