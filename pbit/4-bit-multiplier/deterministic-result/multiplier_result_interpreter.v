`timescale 1ns / 1ps
// TBD: For every new request at this level module - reset count and take deterministic output/input as the result after running for a decisive number of clock cycles.
module multiplier_result_interpreter
#(
    parameter P = 7, // number of pbits - 1 = inputs+outputs-1
    parameter P2 = ((P+1)/2) - 1,
    parameter P3 = ((P+1)/4) - 1
)
(
    input CLK,
    input RST,
    input pending_request,
    input [P2:0] psl_out,
    output [P2:0] result,
    output reg valid_res = 0
);

    // Parameters
    localparam decision_point = 100; // Update cycles required to obtain deterministic result from the multiplier
    localparam no_of_deterministic_pbits = (P2+1);
    localparam cycles_per_pbit_update = 3;
    localparam no_of_update_cycles = no_of_deterministic_pbits * cycles_per_pbit_update;
    
    // Signals
    reg [P2:0] rev_psl_out;
    reg [P2:0] final_result = 0;
    integer count [2**(P2+1) - 1 : 0];
    integer upd_count = 0;
    integer decision_count = 0;
    integer greatest_count = 0;

   
    initial begin : result_count_array_init
        integer i;
        for (i = 0 ; i < 2**(P2+1) ; i = i + 1) begin
            count[i] = 0;
        end
    end




    always @(posedge CLK) begin
        if(RST) begin
            upd_count <= 0;
        end
        else if (upd_count == (no_of_update_cycles - 1)) begin
            upd_count <= 0;
        end
        else if (pending_request == 1) begin
            upd_count <= upd_count + 1;
        end
    end
    always @(*) begin : bit_reverse_block
        integer idx;
        for (idx = 0; idx < P2+1; idx = idx + 1) begin
            rev_psl_out[idx] = psl_out[P2-idx]; 
        end
    end 
    always @(posedge CLK) begin : result_array_update
        integer idx;
        if (decision_count == decision_point + 1) begin
            for (idx = 0 ; idx < 2**(P2+1) ; idx = idx + 1) begin
                count[idx] = 0;
            end
        end
        else if(upd_count == (no_of_update_cycles - 1)) begin
            for(idx = 0; idx < 2**(P2+1); idx = idx + 1) begin
                if (rev_psl_out == idx) begin
                    count[idx] <= count[idx] + 1;
                end
            end
        end
    end




    always @(posedge CLK) begin : decision_point_identifier
        if(RST) begin
            decision_count <= 0;
        end
        else if (decision_count == decision_point) begin 
            decision_count <= decision_count + 1;
        end
        else if (decision_count == decision_point + 1) begin
            decision_count <= 0;
        end
        else if (pending_request == 1 && upd_count == (no_of_update_cycles - 1)) begin
            decision_count <= decision_count + 1;
        end
    end
    always @(posedge CLK) begin : decision_valid_assert
        if (RST) begin
            valid_res <= 0;
        end
        else if (decision_count == decision_point) begin
            valid_res <= 1;
        end
        else begin
            valid_res <= 0;
        end
    end
    always @(posedge CLK) begin : decision_result_update
        integer idx;
        
        if (decision_count == decision_point + 1) begin
            greatest_count = 0;
        end
        else if (decision_count == decision_point) begin
            for(idx = 0; idx < 2**(P2+1); idx = idx + 1) begin
                if (count[idx] > greatest_count) begin
                    greatest_count = count[idx];
                    final_result = idx;
                end
            end
        end
    end
    assign result = final_result;
    

endmodule