
`timescale 1ns/1ps
module tb;
  reg clk, reset;
  reg [3:0] d;
  wire [3:0] q;
  dut DUT (.clk(clk), .reset(reset), .d(d), .q(q));
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=0; d=4'b0000;
    #12 reset=1; d=4'b1010;
    #20 $finish;
  end
  initial begin
    $dumpfile("tb_register.vcd");
    $dumpvars(0,tb);
  end
endmodule
