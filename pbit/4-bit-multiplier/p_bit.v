module pbit #(parameter [31:0] INIT = 32'd1) (
    input wire CLK, RST, en,
    input [6 : 0] z, // clamped bias from weight to tanh
    output reg pbit_val

);
    
    
    // Define scaling factor
    localparam STAGES = 32;
        
    wire signed [31 : 0] rand_no;
    wire signed[31 : 0] temp_sum;
    wire signed [31 : 0] tanh_out;
    reg signed [31 : 0] tanh_out_reg;
    wire overflow;
    
    // rng block
    LFSR #(.STAGES(STAGES), .INIT(INIT)) LFSR_inst (.clk(CLK), .rst(RST), .en(en), .LFSROut(rand_no));
    
    // tanh block
    tanh_LUT tanh (
	.bias(z),
	.tanh_out(tanh_out)
	);

    always @(posedge CLK) begin
        if(~en) begin
            tanh_out_reg <= tanh_out_reg;
        end
        else begin
            tanh_out_reg <= tanh_out;
        end
    end
	
    assign temp_sum = rand_no + tanh_out_reg;

    assign overflow = (rand_no[31] == tanh_out_reg[31]) && (temp_sum[31] == ~rand_no[31]);
    
    always @(*) begin
        if (overflow) begin
            pbit_val = temp_sum[31];
        end
        else begin
            pbit_val = temp_sum[31] ? 0 : 1;
        end
    end
endmodule