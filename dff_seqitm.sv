
class dff_seqitm extends uvm_sequence_item;
  `uvm_object_utils(dff_seqitm)

  // Input stimulus to DUT
  rand bit d;

  // Outputs from DUT (not randomized, as they are monitored by the scoreboard or monitor)
  bit q;
  bit qbar;

  // Constructor
  function new(string name = "dff_seqitm");
    super.new(name);
    `uvm_info("DFF_SEQITM", $psprintf("Sequence item '%s' created", name), UVM_LOW);
  endfunction

  // Display method for debugging
  function void display();
    `uvm_info("DFF_SEQITM_DISPLAY", $psprintf("Stimulus: d=%0b | Outputs: q=%0b, qbar=%0b", d, q, qbar), UVM_LOW);
  endfunction

  // Example constraints (if needed)
  // Constraint to randomize `d` with valid binary values
  constraint valid_stimulus {
    d inside {0, 1}; // Only 0 or 1 allowed
  }
endclass
