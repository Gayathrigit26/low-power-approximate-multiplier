// ==============================================================================
// Module: tb_multiplier
// Description: Testbench for exhaustive verification of exact and approximate
//              4-bit × 4-bit multipliers across all 256 input combinations
// Author: M.Tech Mini-Project
// Date: 2025
// ==============================================================================

`timescale 1ns / 1ps

module tb_multiplier;

    // Signal declarations
    reg  [3:0] A, B;
    wire [7:0] exact_out, approx_out;
    integer i, j;
    integer error_distance;
    integer total_error = 0;
    integer error_count = 0;
    integer max_error = 0;
    integer file_handle;

    // Instantiate both multipliers
    exact_multiplier  u_exact  (.A(A), .B(B), .P(exact_out));
    approx_multiplier u_approx (.A(A), .B(B), .P(approx_out));

    initial begin
        // Enable VCD waveform dumping for GTKWave inspection
        $dumpfile("multiplier.vcd");
        $dumpvars(0, tb_multiplier);

        // Open output file for Python post-processing
        file_handle = $fopen("results.txt", "w");
        if (file_handle == 0) begin
            $display("ERROR: Could not open results.txt for writing");
            $finish;
        end

        // Print header to console and file
        $display("================================================================================");
        $display("EXHAUSTIVE VERIFICATION: EXACT vs APPROXIMATE 4x4 MULTIPLIER");
        $display("================================================================================");
        $display("Test#  |   A   |   B   | Exact | Approx | ErrorDist | Equal");
        $display("-------|-------|-------|-------|--------|-----------|------");
        $fwrite(file_handle, "A,B,Exact,Approx,ErrorDistance\n");

        // Exhaustive stimulus: iterate through all 256 test cases
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                A = i[3:0];
                B = j[3:0];
                
                // Allow combinational logic to settle
                #10;
                
                // Compute error distance
                if (exact_out >= approx_out)
                    error_distance = exact_out - approx_out;
                else
                    error_distance = approx_out - exact_out;
                
                // Accumulate statistics
                total_error = total_error + error_distance;
                if (error_distance > 0) error_count = error_count + 1;
                if (error_distance > max_error) max_error = error_distance;
                
                // Print result
                if (exact_out == approx_out)
                    $display("%5d  | %5d | %5d | %5d | %6d | %9d | %s",
                             (i*16 + j), A, B, exact_out, approx_out, error_distance, "YES");
                else
                    $display("%5d  | %5d | %5d | %5d | %6d | %9d | %s",
                             (i*16 + j), A, B, exact_out, approx_out, error_distance, "NO");
                
                // Write to results file for Python analysis
                $fwrite(file_handle, "%d,%d,%d,%d,%d\n", 
                        A, B, exact_out, approx_out, error_distance);
            end
        end

        // Close results file
        $fclose(file_handle);

        // Print summary statistics
        $display("-------|-------|-------|-------|--------|-----------|------");
        $display("================================================================================");
        $display("SUMMARY STATISTICS");
        $display("================================================================================");
        $display("Total test vectors         : 256");
        $display("Error cases (ED > 0)       : %d", error_count);
        $display("Exact-match cases (ED = 0) : %d", 256 - error_count);
        $display("Maximum Error Distance     : %d", max_error);
        $display("Sum of Error Distances     : %d", total_error);
        $display("Mean Error Distance (MED)  : %.2f", (total_error * 1.0) / 256.0);
        $display("Error Rate (ER)            : %.2f%%", (error_count * 100.0) / 256.0);
        $display("================================================================================");
        $display("Simulation completed. Results written to results.txt");
        $display("VCD file: multiplier.vcd (for GTKWave visualization)");
        $display("================================================================================");

        // End simulation
        $finish;
    end

endmodule
// ==============================================================================
// End of tb_multiplier module
// ==============================================================================
