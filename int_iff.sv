interface int_iff (
  input logic clk,   // Clock signal
  input logic rst    // Reset signal
);
  // Signals
  logic d;           // Data input to the D flip-flop
  logic q;           // Main output of the D flip-flop
  logic qbar;        // Complement output of the D flip-flop
endinterface
