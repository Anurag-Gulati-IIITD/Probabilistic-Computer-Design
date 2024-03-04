`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2024 02:49:18
// Design Name: 
// Module Name: LFSR
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


module LFSR #(parameter STAGES = 8, parameter INIT = 1)(
	input clk, input rst,
	output [STAGES - 1 : 0] LFSROut
);

	reg [STAGES - 1 : 0] Q = INIT, D = 0, Out = INIT;
	reg one_check = 1'b0;

	always @(posedge clk) begin
		if(rst)
			Out <= INIT;
		else if(D == 8'h4 & ~one_check)
			Out <= 8'h0;
		else 
			Out <= D;
	end

	always @(posedge clk) begin
		if(D == 8'h4 & ~one_check)
			one_check <= 1'b1;
		else 
			one_check <= 1'b0;
	end

	always @(posedge clk) begin
		if(rst)
			Q <= INIT;
		else if (D == 8'h4 & ~one_check)
			Q <= Q;
		else 
			Q <= D;
	end

	always@(*) begin
		D = {Q[6:0], Q[7]^Q[5]^Q[4]^Q[3]};
	end
	
	assign LFSROut = Out;

endmodule

module RNG #(parameter STAGES = 8) (
    input clk, reset,
    output [31 : 0] randn

);

    wire [STAGES - 1 : 0] out_lfsr;
    LFSR #(.STAGES(STAGES), .INIT(1)) LFSR_inst (.clk(clk), .rst(reset), .LFSROut(out_lfsr));
    assign randn = out_lfsr;

endmodule