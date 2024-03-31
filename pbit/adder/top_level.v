`timescale 1ns / 1ps
module Top_level #(
    parameter P = 4 // number of pbits - 1 = inputs+outputs-1
)
(
    input wire CLK, RST,
    output wire [P:0] out
);
localparam N = 7;
localparam Q = 2;
localparam I = 4;

// pbit outputs
// wire signed [N-1:0] z[P:0];
reg [N-1:0] z[P:0];

reg [N-1 : 0] w[P:0][P:0];
reg [P:0] update_sequence;
reg [N-1:0] m [P:0];


integer arb_seq_count = 0;
integer clk3_count = 0;

reg first = 0;

integer t;
initial begin
    for(t = 0; t < P+1; t = t + 1) begin
        m[t] = 0;
    end
end

always @(posedge CLK) begin

    if (RST) begin
        clk3_count <= 0;
        arb_seq_count <= 0;
        update_sequence <= 5'b00000;
        first <= 1;
    end

    else if (first) begin
        clk3_count <= 0;
        arb_seq_count <= 0;
        update_sequence <= 5'b00001;
        first <= 0;
    end

    else if(arb_seq_count == 0) begin
        if(clk3_count == 1) begin
            update_sequence <= 5'b00000;
            clk3_count <= clk3_count + 1;
        end 
        else if (clk3_count == 2) begin
            update_sequence <= 5'b00010;
            arb_seq_count <= 1;
            clk3_count <= 0;
        end else begin
            update_sequence <= 5'b00001;
            clk3_count <= clk3_count + 1;
        end
    end

    else if (arb_seq_count == 1) begin
        if(clk3_count == 1) begin
            update_sequence <= 5'b00000;
            clk3_count <= clk3_count + 1;
        end 
        else if (clk3_count == 2) begin
            update_sequence <= 5'b00100;
            arb_seq_count <= 2;
            clk3_count <= 0;
        end else begin
            update_sequence <= 5'b00010;
            clk3_count <= clk3_count + 1;
        end
    end

    else if (arb_seq_count == 2) begin
        if(clk3_count == 1) begin
            update_sequence <= 5'b00000;
            clk3_count <= clk3_count + 1;
        end 
        else if (clk3_count == 2) begin
            update_sequence <= 5'b01000;
            arb_seq_count <= 3;
            clk3_count <= 0;
        end else begin
            update_sequence <= 5'b00100;
            clk3_count <= clk3_count + 1;
        end
    end

    else if (arb_seq_count == 3) begin
        if(clk3_count == 1) begin
            update_sequence <= 5'b00000;
            clk3_count <= clk3_count + 1;
        end 
        else if (clk3_count == 2) begin
            update_sequence <= 5'b10000;
            arb_seq_count <= 4;
            clk3_count <= 0;
        end else begin
            update_sequence <= 5'b01000;
            clk3_count <= clk3_count + 1;
        end
    end

    else if (arb_seq_count == 4) begin
        if(clk3_count == 1) begin
            update_sequence <= 5'b00000;
            clk3_count <= clk3_count + 1;
        end 
        else if (clk3_count == 2) begin
            update_sequence <= 5'b00001;
            arb_seq_count <= 0;
            clk3_count <= 0;
        end else begin
            update_sequence <= 5'b10000;
            clk3_count <= clk3_count + 1;
        end
    end

    else begin
        update_sequence <= 5'b00000;
        arb_seq_count <= 0;
        clk3_count <= 0;
    end
end

always @(*) begin : pbit_outputs
    integer i;
    for (i = 0; i < P+1; i = i + 1) begin
        if(out[i] == 1) begin
            m[i] = 7'b100;
        end
        else begin
            m[i] = 7'b1000100;
        end
    end
end


// pbit instances with sequencer control
pbit  #(.INIT(32'd1000000000)) bit1 (.CLK(CLK), .RST(RST), .z(z[0]), .pbit_val(out[0]), .en(update_sequence[0]));
pbit  #(.INIT(32'd2000000000)) bit2 (.CLK(CLK), .RST(RST), .z(z[1]), .pbit_val(out[1]), .en(update_sequence[1]));
pbit  #(.INIT(32'd3000000000)) bit3 (.CLK(CLK), .RST(RST), .z(z[2]), .pbit_val(out[2]), .en(update_sequence[2]));
pbit  #(.INIT(32'd1)) bit4 (.CLK(CLK), .RST(RST), .z(z[3]), .pbit_val(out[3]), .en(update_sequence[3]));
pbit  #(.INIT(32'd56878)) bit5 (.CLK(CLK), .RST(RST), .z(z[4]), .pbit_val(out[4]), .en(update_sequence[4]));

initial begin

    w[0][0] = 7'b0;
    w[0][1] = 7'b1000100;
    w[0][2] = 7'b1000100;
    w[0][3] = 7'b0000100;
    w[0][4] = 7'b0001000;

    w[1][0] = 7'b1000100;
    w[1][1] = 7'b0;
    w[1][2] = 7'b1000100;
    w[1][3] = 7'b0000100;
    w[1][4] = 7'b0001000;

    w[2][0] = 7'b1000100;
    w[2][1] = 7'b1000100;
    w[2][2] = 7'b0;
    w[2][3] = 7'b0000100;
    w[2][4] = 7'b0001000;

    w[3][0] = 7'b0000100;
    w[3][1] = 7'b0000100;
    w[3][2] = 7'b0000100;
    w[3][3] = 7'b0;
    w[3][4] = 7'b1001000;

    w[4][0] = 7'b0001000;
    w[4][1] = 7'b0001000;
    w[4][2] = 7'b0001000;
    w[4][3] = 7'b1001000;
    w[4][4] = 7'b0;

end


// multiplier-adder signals:
wire [N-1:0] mult_res_z [P:0][P:0]; // (P+1) * (P+1) = 5 * 5 products, therefore, 4 : 0, 4 : 0 dim product output
wire [P:0] mult_ovr_z [P:0];

wire [N-1:0] add_res_z [P:0][P-1:0]; // (P+1) * ((P+1)-1) = 5 * 4 products, therefore, 4 : 0, 3 : 0 dim sum output
wire [P-1:0] add_ovr_z [P:0];
reg [P:0] sum_overflow; // to be used as a logic to check if |(add_ovr_z[i]) == 1

genvar j, k;
generate // : generates 5 * 5 = 25 qmults
    for (j=0; j<P+1; j=j+1) begin : multipliers 
        // integer p = 0;
        for(k=0; k<P+1; k=k+1) begin
            // always @(*)
            //     p = (j != k) ? p + 1 : p;
            qmult #(.Q(Q), .N(N)) mult_z (.i_multiplicand(w[j][k]), .i_multiplier(m[k]), .o_result(mult_res_z[j][k]), .ovr(mult_ovr_z[j][k]));
        end
    end 
endgenerate

genvar u, n;
generate // : generates 5 * 4 = 20 qadds
    for(u = 0; u < P+1; u = u + 1) begin : adders
        for(n = 0; n < P; n = n + 1) begin
            if(n == 0) begin
                qadd #(.Q(Q), .N(N)) add0_z (.a(mult_res_z[u][n]), .b(mult_res_z[u][n+1]), .c(add_res_z[u][n]), .ovr(add_ovr_z[u][n]));
            end
            else begin
                qadd #(.Q(Q), .N(N)) add_z (.a(add_res_z[u][n-1]), .b(mult_res_z[u][n+1]), .c(add_res_z[u][n]), .ovr(add_ovr_z[u][n]));
            end
        end
    end
endgenerate

integer d;
always @(*) begin
    for(d = 0; d < P+1; d = d + 1) begin : adders_overflows
        sum_overflow[d] = |(add_ovr_z[d]);
    end
end

integer q;
always @(*) begin
    for(q = 0; q < P+1; q = q + 1) begin
        z[q] = add_res_z[q][P-1];
        if(z[q][N-1] == 1'b1 && ((z[q][N-2:0] > 6'b100000) || (sum_overflow[q] == 1'b1))) begin      // if z3 is -ve and its abs mag is greater than 8
            z[q] = 7'b1100000; // -8
        end
        else if (z[q][N-1] == 1'b0 && ((z[q][N-2:0] > 6'b011111) || (sum_overflow[q] == 1'b1))) begin // if z3 is +ve and its abs mag is greater than 7.75
            z[q] = 7'b0011111; // 7.75
        end
        else z[q] = z[q];  
    end
end

endmodule

