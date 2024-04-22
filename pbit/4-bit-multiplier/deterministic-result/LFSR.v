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


module LFSR #(parameter STAGES = 32, parameter [31 : 0] INIT = 32'd1)(
	input clk, input rst, input en,
	output [STAGES - 1 : 0] LFSROut
);

	reg [STAGES - 1 : 0] Q = INIT, D = 0, Out = INIT;
	reg one_check = 1'b0;

	always @(posedge clk) begin
		if(rst)
			Out <= INIT;
		else if(D == 32'h3 & ~one_check)
			Out <= 32'h0;
		else 
			Out <= D;
	end

	always @(posedge clk) begin
		if(D == 32'h3 & ~one_check)
			one_check <= 1'b1;
		else 
			one_check <= 1'b0;
	end

	always @(posedge clk) begin
		if(rst)
			Q <= INIT;
		else if(~en) // Synchronous enable and reset
			Q <= Q;
		else if (D == 32'h3 & ~one_check)
			Q <= Q;
		else 
			Q <= D;
	end

	always@(*) begin
		D = {Q[30:0], ~(Q[31]^Q[21]^Q[1]^Q[0])};
	end
	
	assign LFSROut = Out;

endmodule

