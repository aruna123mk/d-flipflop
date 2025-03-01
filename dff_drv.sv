

class dff_drv extends uvm_driver#(dff_seqitm);
  `uvm_component_utils(dff_drv)

  // Virtual interface
  virtual int_iff vif;

  // Transaction handle
  dff_seqitm item;

  // Constructor
  function new(string name = "dff_drv", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase: Get the virtual interface from the UVM configuration database
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual int_iff)::get(this, "", "vif", vif)) begin
      `uvm_fatal("BUILD_PHASE", "Failed to get virtual interface from config DB");
    end
  endfunction

  // Run phase: Main driver loop
  task run_phase(uvm_phase phase);
    forever begin
      // Wait for the next transaction from the sequencer
      seq_item_port.get_next_item(item);

      // Drive the DUT using the received transaction
      drive(item);

      // Notify the sequencer that the transaction is complete
      seq_item_port.item_done();
    end
  endtask

  // Drive task: Perform signal driving on the DUT
  task drive(dff_seqitm item);
    if (vif == null) begin
      `uvm_fatal("DRIVE_TASK", "Virtual interface is null in driver");
    end

    // Drive the transaction onto the DUT
    @(posedge vif.clk);
    vif.d <= item.d;  // Drive the data signal

    // Handle reset if included in the transaction
   /* if (item.reset) begin
      @(posedge vif.clk);
      vif.rst < item.rst;
      `uvm_info("DRIVE_TASK", $psprintf("Driving reset: rst=%0b", item.rst), UVM_HIGH);
    end
*/
    // Log the driven transaction
    `uvm_info("DRIVE_TASK", $psprintf("Driving transaction: d=%0b", item.d), UVM_HIGH);
  endtask

endclass
