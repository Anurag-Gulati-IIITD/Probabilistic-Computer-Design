module Top_level #(
    parameter FLOAT_SIZE = 24,
    parameter INT_SIZE = 8
) (
    input wire CLK, RST,
    output wire out1, out2, out3
);
localparam N = 7;
localparam Q = 2;
localparam I = 4;


// pbit outputs
wire signed [N-1:0] z1, z2, z3;
reg signed [N-1:0] z1_t, z2_t, z3_t;

reg signed [N-1 : 0] w1[2:0],w2[2:0],w3[2:0];
reg signed [N-1 : 0] b1, b2, b3;
reg [2:0] update_sequence;
reg [N-1:0] m_3 = 0, m_2 = 0, m_1 = 0;


integer count = 0;
reg CLK_DIV2;
always @(posedge CLK) begin
    if (RST) 
        CLK_DIV2 <= 0;
    else
        CLK_DIV2 <= ~CLK_DIV2;
end

always @(posedge CLK_DIV2) begin
    if(count == 0) begin
        update_sequence <= 3'b001;
        count <= count + 1;
    end
    else if (count == 1) begin
        update_sequence <= 3'b010;
        count <= count + 1;
    end
    else if (count == 2) begin
        update_sequence <= 3'b100;
        count <= 0;
    end
    else begin
        update_sequence <= 3'b000;
        count <= 0;
    end
end

// change these for 7 bits
always @(*) begin
    if(out1 == 1) begin
        m_1 = 7'b100;
    end
    else begin
        m_1 = 7'b1000100;
    end
end

always @(*) begin
    if(out2 == 1) begin
        m_2 = 7'h4;
    end
    else begin
        m_2 = 7'h44;
    end
end

always @(*) begin
    if(out3 == 1) begin
        m_3 = 7'h4;
    end
    else begin
        m_3 = 7'h44;
    end
end

// pbit instances with sequencer control
pbit  #(.INIT(1000000000)) bit1 (.CLK(CLK), .RST(RST), .z(z1), .pbit_val(out1), .en(update_sequence[0]));
pbit  #(.INIT(2000000000)) bit2 (.CLK(CLK), .RST(RST), .z(z2), .pbit_val(out2), .en(update_sequence[1]));
pbit  #(.INIT(3000000000)) bit3 (.CLK(CLK), .RST(RST), .z(z3), .pbit_val(out3), .en(update_sequence[2]));


initial begin
    w1[2] = 7'b0_0010_00 //  2;
    w1[1] = 7'b1_0001_00 // -1;
    w1[0] = 7'b0_0000_00 //  0;

    w2[2] = 7'b0_0010_00 //  2;
    w2[1] = 7'b0_0000_00 //  0;
    w2[0] = 7'b1_0001_00 // -1;

    w3[2] = 7'b0_0000_00 //  0;
    w3[1] = 7'b0_0010_00 //  2;
    w3[0] = 7'b0_0010_00 //  2;
     
    b1 = 7'b0_0001_00    //  1;
    b2 = 7'b0_0001_00    //  1;
    b3 = 7'b1_0010_00    // -2;
end

// using qadd and qmult to compute each z means declaring 2 adder instances (with dependency) and 2 independent multiplier instances:

// multiplier signals:
wire [N-1:0] mult1_res_z3, mult2_res_z3;
reg mult1_ovr_z3, mult2_ovr_z3;

wire [N-1:0] add1_res_z3;

// z3 = ((w1[2]*m_1) + (w2[2]*m_2) + b3) ----> for your reference
// A + B -> C                            ----> for your reference
qmult #(.Q(Q), .N(N)) mult1_z3 (.i_multiplicand(w1[2]), .i_multiplier(m_1), .o_result(mult1_res_z3), .ovr(mult1_ovr_z3));
qmult #(.Q(Q), .N(N)) mult2_z3 (.i_multiplicand(w2[2]), .i_multiplier(m_2), .o_result(mult2_res_z3), .ovr(mult2_ovr_z3));

qadd #(.Q(Q), .N(N)) add1_z3 (.a(mult1_res_z3), .b(mult2_res_z3), .c(add1_res_z3));
qadd #(.Q(Q), .N(N)) add2_z3 (.a(add1_res_z3), .b(b3), .c(z3_t));



// CLAMPING CIRCUIT FOR z3
always @(z3_t) begin

    if(z3_t[N-1] == 1'b1 && z3_t[N-2:0] > 6'b100000) begin      // if z3 is -ve and its abs mag is greater than 8
        z3_t = 7'b1100000; // -8
    end
    else if (z3_t[N-1] == 1'b0 && z3_t[N-2:0] > 6'b011111) begin // if z3 is +ve and its abs mag is greater than 7.75
        z3_t = 7'b0011111; // 7.75
    end
    else z3_t = z3_t;      // no change
end
assign z3 = z3_t;



// multiplier signals:
wire [N-1:0] mult1_res_z2, mult2_res_z2;
reg mult1_ovr_z2, mult2_ovr_z2;

wire [N-1:0] add1_res_z2;

// C + A -> B                            ----> for your reference
qmult #(.Q(Q), .N(N)) mult1_z2 (.i_multiplicand(w3[1]), .i_multiplier(m_3), .o_result(mult1_res_z2), .ovr(mult1_ovr_z2));
qmult #(.Q(Q), .N(N)) mult2_z2 (.i_multiplicand(w1[1]), .i_multiplier(m_1), .o_result(mult2_res_z2), .ovr(mult2_ovr_z2));

qadd #(.Q(Q), .N(N)) add1_z2 (.a(mult1_res_z2), .b(mult2_res_z2), .c(add1_res_z2));
qadd #(.Q(Q), .N(N)) add2_z2 (.a(add1_res_z2), .b(b2), .c(z2_t));


// CLAMPING CIRCUIT FOR z2
always @(z2_t) begin

    if(z2_t[N-1] == 1'b1 && z2_t[N-2:0] > 6'b100000) begin 
        z2_t = 7'b1100000; // -8
    end
    else if (z2_t[N-1] == 1'b0 && z2_t[N-2:0] > 6'b011111) begin
        z2_t = 7'b0011111; // 7.75
    end
    else z2_t = z2_t;      // no change
end
assign z2 = z2_t;



// multiplier signals:
wire [N-1:0] mult1_res_z1, mult2_res_z1;
reg mult1_ovr_z1, mult2_ovr_z1;

wire [N-1:0] add1_res_z1;

// B + C -> A                           ----> for your reference
qmult #(.Q(Q), .N(N)) mult1_z1 (.i_multiplicand(w2[0]), .i_multiplier(m_2), .o_result(mult1_res_z1), .ovr(mult1_ovr_z1));
qmult #(.Q(Q), .N(N)) mult2_z1 (.i_multiplicand(w3[0]), .i_multiplier(m_3), .o_result(mult2_res_z1), .ovr(mult2_ovr_z1));

qadd #(.Q(Q), .N(N)) add1_z1 (.a(mult1_res_z1), .b(mult2_res_z1), .c(add1_res_z1));
qadd #(.Q(Q), .N(N)) add2_z1 (.a(add1_res_z1), .b(b1), .c(z1_t));


// CLAMPING CIRCUIT FOR z1
always @(z1_t) begin

    if(z1_t[N-1] == 1'b1 && z1_t[N-2:0] > 6'b100000) begin    
        z1_t = 7'b1100000; // -8
    end
    else if (z1_t[N-1] == 1'b0 && z1_t[N-2:0] > 6'b011111) begin 
        z1_t = 7'b0011111; // 7.75
    end
    else z1_t = z1_t;      // no change
end  
assign z1 = z1_t;

endmodule




// always @(*) begin
//     for (i = 0; i < 3 ; i = i + 1) begin
//         w1[i] = weight1[i*ele +: ele];
//     end
// end

// always @(*) begin
//     for (j = 0; j < 3 ; j = j + 1) begin
//         w2[j] = weight2[j*ele +: ele];
//     end
// end

// always @(*) begin
//     for (k = 0; k < 3 ; k = k + 1) begin
//         w3[k] = weight3[k*ele +: ele];
//     end
// end
