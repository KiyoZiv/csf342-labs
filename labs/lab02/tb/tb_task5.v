
`timescale 1ns/1ps
module tb;
  reg clk, reset;
  reg [1:0] op;
  reg dest;
  wire [1:0] R0, R1;
  dut DUT (.clk(clk), .reset(reset), .op(op), .dest(dest), .R0(R0), .R1(R1));
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; op=2'b00; dest=0;
    #12 reset=0;
    op=2'b01; dest=0; @(posedge clk); @(posedge clk);
    op=2'b10; dest=1; @(posedge clk); @(posedge clk);
    op=2'b11; @(posedge clk);
    op=2'b11; @(posedge clk);
    #20 $finish;
  end
  initial begin
    $dumpfile("tb_fsm.vcd");
    $dumpvars(0,tb);
  end
endmodule
