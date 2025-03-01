class dff_mon extends uvm_monitor;
  `uvm_component_utils(dff_mon)

  // Analysis port to send captured data to other components (e.g., scoreboard)
  uvm_analysis_port#(dff_seqitm) item_collected_port;

  // Sequence item to hold monitored values
  dff_seqitm item;

  // Virtual interface for observing DUT signals
  virtual int_iff vif;

  // Constructor
  function new(string name = "dff_mon", uvm_component parent = null);
    super.new(name, parent);

    // Initialize the analysis port
    item_collected_port = new("item_collected_port", this);

    `uvm_info("MONITOR", "Monitor created", UVM_LOW);
  endfunction

  // Build phase to retrieve the virtual interface
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual int_iff)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MONITOR", "Failed to get virtual interface from config DB");
    end
  endfunction

  // Run phase to continuously monitor DUT signals
  task run_phase(uvm_phase phase);
    // Create an instance of the sequence item for storing captured values
    item = dff_seqitm::type_id::create("item");

    forever begin
      // Wait for the rising edge of the clock
      @(posedge vif.clk);

      // Capture DUT signals
      item.d = vif.d;
      item.q = vif.q;
      item.qbar = vif.qbar;

      // Log captured values for debugging
      `uvm_info("MONITOR_DEBUG", $psprintf("Captured: d=%0b, q=%0b, qbar=%0b", item.d, item.q, item.qbar), UVM_HIGH);

      // Only write to the analysis port if reset is inactive
      if (vif.rst) begin
        `uvm_info("MONITOR_DEBUG", "Reset is active, skipping this cycle", UVM_LOW);
      end else begin
        item_collected_port.write(item);
        `uvm_info("MONITOR", "Data sent to analysis port", UVM_LOW);
      end
    end
  endtask

endclass
