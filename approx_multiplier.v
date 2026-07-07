// ============================================================
// Approximate 4-bit x 4-bit Multiplier
// Inputs : A[3:0], B[3:0]
// Output : P[7:0]
//
// Approximation Strategy:
//   - Full partial products pp2 and pp3 are kept (MSB-dominant)
//   - pp1 is kept but its LSB contribution is dropped (truncated)
//   - pp0  (least significant) is dropped entirely
//   This reduces adder tree depth and saves LUTs at the cost
//   of a small, bounded error in the lower bits.
// ============================================================
module approx_multiplier (
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] P
);
    // Keep MSB-side partial products fully
    wire [7:0] pp2 = B[2] ? {2'b00, A, 2'b0} : 8'b0;
    wire [7:0] pp3 = B[3] ? {1'b0,  A, 3'b0} : 8'b0;

    // Truncate pp1: zero out the lowest bit contribution
    wire [7:0] pp1_approx = B[1] ? {3'b000, A[3:1], 2'b0} : 8'b0;

    // pp0 is completely dropped (approximation)
    // Result: sum of the three retained partial products
    assign P = pp1_approx + pp2 + pp3;

endmodule
