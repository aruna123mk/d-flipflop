class dff_scbd extends uvm_scoreboard;
  `uvm_component_utils(dff_scbd)

  // Analysis port to receive items
  uvm_analysis_imp#(dff_seqitm, dff_scbd) item_collected_export;

  // Queue to store received items
  dff_seqitm item_queue[$];

  // Constructor
  function new(string name = "dff_scbd", uvm_component parent = null);
    super.new(name, parent);

    // Initialize the analysis port
    item_collected_export = new("item_collected_export", this);

    `uvm_info("SCOREBOARD", $psprintf("Scoreboard created: %s", name), UVM_LOW);
  endfunction

  // Write method to handle items received from the analysis port
  function void write(dff_seqitm item);
    // Log the received item for debugging
    `uvm_info("SCOREBOARD_WRITE", $psprintf("Received item: d=%0b, q=%0b, qbar=%0b", item.d, item.q, item.qbar), UVM_HIGH);

    // Push the received item to the queue
    item_queue.push_back(item);
  endfunction

  // Run phase to process items from the queue
  task run_phase(uvm_phase phase);
    dff_seqitm received_data;

    forever begin
      // Wait until the queue has at least one item
      wait(item_queue.size() > 0);

      // Retrieve the next item from the queue
      received_data = item_queue.pop_front();

      // Validate the received data
      validate_item(received_data);
    end
  endtask

  // Validation task to check DUT behavior
  task validate_item(dff_seqitm item);
    // Ensure q and qbar are valid values (no X or Z states)
    if ((item.q === 1'bx) || (item.qbar === 1'bx)) begin
      `uvm_error("SCOREBOARD", $psprintf("Uninitialized values detected: d=%0b, q=%0b, qbar=%0b", item.d, item.q, item.qbar));
      return;
    end

    // Check if qbar is the complement of q
    if (item.qbar !== ~item.q) begin
      `uvm_error("SCOREBOARD", $psprintf("Mismatch detected: d=%0b, q=%0b, qbar=%0b", item.d, item.q, item.qbar));
    end else begin
      // Log a success message if the values match
      `uvm_info("SCOREBOARD", $psprintf("Validation passed: d=%0b, q=%0b, qbar=%0b", item.d, item.q, item.qbar), UVM_LOW);
    end
  endtask

endclass
