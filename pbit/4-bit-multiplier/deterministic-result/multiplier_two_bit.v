
module multiplier_two_bit
#(
    parameter P = 7, // number of pbits - 1 = inputs+outputs-1
    parameter P2 = ((P+1)/2) - 1,
    parameter P3 = ((P+1)/4) - 1
)
(
    input wire CLK, RST, MODE, valid_in,
    input [P3:0] in1,
    input [P3:0] in2,
    input [P2:0] op,
    output [P2:0] res,
    output valid_res
);
wire [P2:0] psl_out;
reg pending_request = 0;

always @(posedge CLK) begin
    if(valid_in == 1) begin
        pending_request = 1;
    end
    else if (valid_res == 1) begin
        pending_request = 0;
    end
end

psl psl_inst (.CLK(CLK), .RST(RST), .MODE(MODE), .in1(in1), .in2(in2), .op(op), .psl_out(psl_out), .pending_request(pending_request));
multiplier_result_interpreter mri_inst (.CLK(CLK), .RST(RST), .pending_request(pending_request), .psl_out(psl_out), .result(res), .valid_res(valid_res));

endmodule