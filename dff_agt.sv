
class dff_agt extends uvm_agent;
  `uvm_component_utils(dff_agt)

  // Agent sub-components
  dff_mon mon;                           // Monitor
  dff_drv driver;                        // Driver
  dff_seqr seqr;                         // Sequencer

  // Virtual interface
  virtual int_iff vif;

  // Constructor
  function new(string name = "dff_agt", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase: Create sub-components and get the virtual interface
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sub-components
    mon = dff_mon::type_id::create("mon", this);
    driver = dff_drv::type_id::create("driver", this);
    seqr = dff_seqr::type_id::create("seqr", this);

    // Get the virtual interface from the configuration database
    if (!uvm_config_db#(virtual int_iff)::get(this, "", "vif", vif)) begin
      `uvm_fatal("BUILD_PHASE", "No virtual interface specified for this agent instance");
    end

    // Pass the virtual interface to the driver and monitor
    driver.vif = vif;
    mon.vif = vif;
  endfunction

  // Connect phase: Connect driver and sequencer
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect the sequencer to the driver's sequence item port
    driver.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
