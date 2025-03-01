
class dff_seq extends uvm_sequence#(dff_seqitm);

  `uvm_object_utils(dff_seq)

  // Declare the sequence item to be used in the sequence
  dff_seqitm item;

  // Constructor
  function new(string name = "dff_seq");
    super.new(name);
    `uvm_info("SEQUENCE_CLASS", $psprintf("Sequence created: %s", name), UVM_LOW);
  endfunction

  // Sequence body where the sequence logic is defined
  task body();
    `uvm_info("SEQUENCE_BODY", "Starting sequence body", UVM_MEDIUM);

    repeat (5) begin
      // Create a new sequence item instance
      item = dff_seqitm::type_id::create("item");

      // Start a new transaction with the sequencer
      start_item(item);

      // Randomize the sequence item
      if (!item.randomize()) begin
        `uvm_error("SEQUENCE_RANDOMIZATION", "Failed to randomize sequence item");
      end

      // Log the randomized values
      `uvm_info("SEQUENCE_BODY", $psprintf("Randomized item: d=%0b", item.d), UVM_HIGH);

      // Send the sequence item to the driver
      finish_item(item);

      `uvm_info("SEQUENCE_BODY", "Item sent to driver", UVM_HIGH);
    end

    `uvm_info("SEQUENCE_BODY", "Sequence body completed", UVM_MEDIUM);
  endtask

endclass
