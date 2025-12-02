
class alu_random_test extends alu_base_test;
  `uvm_component_utils(alu_random_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_random_seq seq = alu_random_seq::type_id::create("seq");
    int ai_mode;
    $value$plusargs("ai_mode=%d", ai_mode);
    phase.raise_objection(this);
    if (!ai_mode) seq.start(env.agt.seqr);
    phase.drop_objection(this);
  endtask

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
endclass