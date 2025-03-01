
class dff_test extends uvm_test;
  `uvm_component_utils(dff_test)

  dff_env env;  // Environment handle

  // Constructor
  function new(string name = "dff_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create the environment instance
    env = dff_env::type_id::create("env", this);

    // Check if environment creation is successful
    if (env == null) begin
      `uvm_fatal("BUILD_PHASE", "Failed to create environment instance")
    end
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    dff_seq dff_seq1;  // Declare the sequence handle

    // Raise objection to ensure simulation continues during the test
    phase.raise_objection(this);
    `uvm_info("DFF_TEST", "Starting DFF sequence", UVM_LOW);

    // Create the sequence instance
    dff_seq1 = dff_seq::type_id::create("dff_seq1", this);

    // Start the sequence on the sequencer (connected in the environment)
    if (env != null) begin
      dff_seq1.start(env.agt.seqr);  // Start the sequence on the agent's sequencer
    end else begin
      `uvm_fatal("RUN_PHASE", "Environment handle is null. Cannot start sequence.");
    end

    // Log completion message
    `uvm_info("DFF_TEST", "DFF sequence completed", UVM_LOW);

    // Drop objection to allow simulation to end
    phase.drop_objection(this);
  endtask

  // End of elaboration phase
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
    `uvm_info("DFF_TEST", "Topology printed", UVM_LOW);
  endfunction

endclass
