`timescale 1ns/1ps

module tb;

  // 1. Inputs and Outputs
  reg clk;
  reg reset;      // Active Low (0=Reset, 1=Run) based on your snippet
  reg serial_in;
  wire [3:0] q;

  // 2. Instantiate the Student's Module
  // Ensure students name their module 'dut' or change this line to match requirements
  dut DUT (
    .clk(clk),
    .reset(reset),
    .serial_in(serial_in),
    .q(q)
  );

  // 3. Variables for Auto-Grading
  integer errors = 0;
  reg [3:0] expected_q; // "Shadow" register to calculate correct answer

  // 4. Clock Generation (10ns period)
  initial clk = 0;
  always #5 clk = ~clk;

  // 5. Reference Model (The "Golden" Logic)
  // This calculates what the output *should* be.
  // Assuming LSB shift: q <= {q[2:0], serial_in}
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      expected_q <= 4'b0000;
    end else begin
      // Update this line if your lab requires MSB shift behavior
      expected_q <= {expected_q[2:0], serial_in}; 
    end
  end

  // 6. Test Procedure
  initial begin
    $dumpfile("grading_waveform.vcd");
    $dumpvars(0, tb);

    // --- Phase 1: Reset Test ---
    reset = 0;
    serial_in = 0;
    #12; // Hold reset for a bit
    
    // Check if reset worked (Asynchronous or Synchronous checks)
    if (q !== 4'b0000) begin
      $display("ERROR at time %0t: Reset failed. Expected 0000, got %b", $time, q);
      errors = errors + 1;
    end

    // --- Phase 2: Random Data Testing ---
    reset = 1; // Release reset (Active Low)
    
    // Helper task to drive inputs
    drive_input(1); // Shift in 1
    drive_input(0); // Shift in 0
    drive_input(1); // Shift in 1
    drive_input(1); // Shift in 1 (Pattern is now 1011 or similar)
    
    // Test a few more random cases
    drive_input(0);
    drive_input(0);
    drive_input(1);

    // --- Phase 3: Final Evaluation ---
    #10;
    if (errors == 0) begin
      $display("-----------------------------------------");
      $display("   ALL_TESTS_PASSED");
      $display("-----------------------------------------");
    end else begin
      $display("-----------------------------------------");
      $display("   TEST_FAILED: %0d errors detected", errors);
      $display("-----------------------------------------");
    end

    $finish;
  end

  // 7. Checker Task
  // This drives the input, waits for the clock, and checks the result
  task drive_input;
    input val;
    begin
      serial_in = val;
      @(posedge clk); // Wait for the student DUT to process
      #1;             // Small delay to allow 'q' to settle after clock edge
      
      if (q !== expected_q) begin
        $display("ERROR at time %0t: Input=%b. Expected q=%b, Got q=%b", 
                 $time, val, expected_q, q);
        errors = errors + 1;
      end
    end
  endtask

endmodule
