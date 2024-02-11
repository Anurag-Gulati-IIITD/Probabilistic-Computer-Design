module pbit(CLK, RST, z, pbit_val);
    parameter FLOAT_SIZE = 24;
    parameter INT_SIZE = 8;
    
    input wire CLK, RST;
    input wire [INT_SIZE-1: -FLOAT_SIZE] z;
    output wire pbit_val;
    // Define scaling factor
    localparam SCALE_FACTOR = 255;
        
    wire [INT_SIZE+FLOAT_SIZE-1: 0] rand_no;
    wire [INT_SIZE-1: -FLOAT_SIZE] tanh_val;
    wire signed [INT_SIZE-1: -FLOAT_SIZE] true_rand;
    wire signed [INT_SIZE-1: -FLOAT_SIZE] temp_add;
    wire [INT_SIZE-1: -FLOAT_SIZE] tanh_out, out_scaled;
    reg temp_pbit;    
    
    RNG rand(
    .clk(CLK),
    .reset(RST),
    .randn(rand_no)
    );
    
    cordictanh tanh (
	.CLK(CLK), 
	.EN(RST), 
	.z(z),
	.out(tanh_out)
	);
	
    assign true_rand = {~(rand_no[7:0]-8'd127) + 8'b1, 24'b0};
    assign out_scaled = ((tanh_out+32'h01_000000)>>>1) * SCALE_FACTOR;
    assign tanh_val = out_scaled;
    assign temp_add = true_rand + tanh_val;
    
    always @(*)
    begin
        if(temp_add[7] == 1) temp_pbit <= 0;
        else temp_pbit <= 1;
    end
    
    assign pbit_val = temp_pbit;
    
endmodule