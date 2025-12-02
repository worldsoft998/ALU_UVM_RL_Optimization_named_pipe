
class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)
  alu_agent agt;
  alu_scoreboard scb;
  alu_coverage cov;
  ai_bridge bridge;
  int ai_mode = 0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $value$plusargs("ai_mode=%d", ai_mode);
    agt = alu_agent::type_id::create("agt", this);
    scb = alu_scoreboard::type_id::create("scb", this);
    cov = alu_coverage::type_id::create("cov", this);
    if (ai_mode) bridge = ai_bridge::type_id::create("bridge", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap.connect(scb.ap);
    agt.mon.ap.connect(cov.ap);
    if (ai_mode) {
      agt.mon.ap.connect(bridge.ap);
      bridge.seqr = agt.seqr;
    }
  endfunction
endclass