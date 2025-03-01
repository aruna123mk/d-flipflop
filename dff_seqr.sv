

class dff_seqr extends uvm_sequencer#(dff_seqitm);

  `uvm_component_utils(dff_seqr)

  // Constructor
  function new(string name = "dff_seqr", uvm_component parent = null);
    super.new(name, parent);

    // Log a message indicating the creation of the sequencer
    `uvm_info("SEQUENCER", $psprintf("Created sequencer: %s", name), UVM_LOW);
  endfunction

endclass
