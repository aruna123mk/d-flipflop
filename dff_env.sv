class dff_env extends uvm_env;  
`uvm_component_utils(dff_env)

  dff_agt agt;      // Agent
  dff_scbd scbd;    // Scoreboard

  // Virtual interface
  virtual int_iff vif;

  // Constructor
  function new(string name = "dff_env", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("ENVIRONMENT_CLASS", "Constructor called", UVM_MEDIUM);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create agent and scoreboard
    agt = dff_agt::type_id::create("agt", this);
    if (agt == null) begin
      `uvm_fatal("BUILD_PHASE", "Failed to create agent (agt) in dff_env");
    end

    scbd = dff_scbd::type_id::create("scbd", this);
    if (scbd == null) begin
      `uvm_fatal("BUILD_PHASE", "Failed to create scoreboard (scbd) in dff_env");
    end

    // Virtual interface setup: get the virtual interface from config DB
    if (!uvm_config_db#(virtual int_iff)::get(this, "", "vif", vif)) begin
      `uvm_fatal("BUILD_PHASE", "No virtual interface specified for this environment instance");
    end

    // Pass virtual interface to the agent's components (driver, monitor)
    uvm_config_db#(virtual int_iff)::set(this, "agt", "vif", vif);

    `uvm_info("ENVIRONMENT_CLASS", "Virtual interface passed to agent", UVM_LOW);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Check if agent and monitor exist
    if (agt == null) begin
      `uvm_fatal("CONNECT_PHASE", "Agent (agt) is null in connect_phase");
    end
    if (agt.mon == null) begin
      `uvm_fatal("CONNECT_PHASE", "Monitor (mon) is null in agent (agt)");
    end
    if (agt.mon.item_collected_port == null) begin
      `uvm_fatal("CONNECT_PHASE", "item_collected_port is null in monitor (mon)");
    end

    // Connect agent's monitor to scoreboard
    agt.mon.item_collected_port.connect(scbd.item_collected_export);
    `uvm_info("CONNECT_PHASE", "Connected monitor to scoreboard", UVM_LOW);
  endfunction

endclass

