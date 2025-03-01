import uvm_pkg::*;
//`timescale 1ns/1ns
`include "uvm_macros.svh"
`include "int_iff.sv"
`include "package.sv"

module top;

  //** Signal Declarations **//
  logic clk;   // Clock signal
  logic rst;   // Reset signal

  //** Interface Instantiation **//
  // Physical interface instance
  int_iff intf(clk, rst);

  // Virtual interface declaration
  virtual int_iff vif;

  //** DUT Instantiation **//
  // Connect DUT ports to physical interface
  d_ff dut (
    .d(intf.d),
    .clk(intf.clk),
    .rst(intf.rst),
    .q(intf.q),
    .qbar(intf.qbar)
  );

  //** Clock Signal Generation **//
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // 50 MHz clock with a period of 20ns
  end

  //** Reset Signal Generation **//
  initial begin
    rst = 0;   // Initialize reset
    #10 rst = 1;  // Assert reset after 15ns
    #10 rst = 0;  // Deassert reset after 20ns
  end

  //** Virtual Interface Setup **//
  initial begin
    vif = intf;  // Connect the virtual interface to the physical interface
    uvm_config_db#(virtual int_iff)::set(null, "*", "vif", vif);  // Add to UVM config database
  end

  //** Start UVM Test **//
  initial begin
    run_test("dff_test");  // Specify the UVM test name
  end

  //** Waveform Dumping **//
  initial begin
    $dumpfile("wave.vcd");  // Specify waveform dump file
    $dumpvars(0, top);      // Dump all signals in the top module
  end

  //** Simulation Termination **//
  initial begin
    #100 $finish;  // Terminate simulation after 100 time units
  end

endmodule
