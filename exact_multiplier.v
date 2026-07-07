// ============================================================
// Exact 4-bit x 4-bit Multiplier
// Inputs : A[3:0], B[3:0]
// Output : P[7:0]
// Method : Standard partial-product accumulation
// ============================================================
module exact_multiplier (
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] P
);
    // Generate all 4 partial products
    wire [7:0] pp0 = B[0] ? {4'b0000, A}       : 8'b0;
    wire [7:0] pp1 = B[1] ? {3'b000,  A, 1'b0} : 8'b0;
    wire [7:0] pp2 = B[2] ? {2'b00,   A, 2'b0} : 8'b0;
    wire [7:0] pp3 = B[3] ? {1'b0,    A, 3'b0} : 8'b0;

    assign P = pp0 + pp1 + pp2 + pp3;

endmodule
