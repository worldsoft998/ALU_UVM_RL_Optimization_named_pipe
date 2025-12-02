
class ai_bridge extends uvm_component;
  `uvm_component_utils(ai_bridge)
  uvm_sequencer#(alu_seq_item) seqr;
  uvm_analysis_imp#(alu_seq_item, ai_bridge) ap;
  virtual alu_if vif;
  alu_env env;  // Parent ref for cov access
  string pipe_name, resp_pipe_name;
  int fd, resp_fd;
  uvm_event rsp_event;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
    rsp_event = new("rsp_event");
    env = alu_env::type_id::cast(parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif);
  endfunction

  task run_phase(uvm_phase phase);
    bit [3:0] op;
    bit [7:0] a, b;
    $value$plusargs("pipe_name=%s", pipe_name);
    $value$plusargs("resp_pipe_name=%s", resp_pipe_name);
    fd = $fopen(pipe_name, "r");
    resp_fd = $fopen(resp_pipe_name, "w");
    if (fd == 0 || resp_fd == 0) `uvm_fatal("BRIDGE", "Pipe open failed")
    forever begin
      if ($fscanf(fd, "%h %h %h", op, a, b) != 3) break;
      alu_seq_item item = alu_seq_item::type_id::create("item");
      item.op = op;
      item.a = a;
      item.b = b;
      seqr.execute_item(item);
      rsp_event.wait_trigger();
      rsp_event.reset();
    end
    $fclose(fd);
    $fclose(resp_fd);
  endtask

  function void write(alu_seq_item rsp);
    real cov = env.cov.get_cov();
    bit [80:0] bins = env.cov.get_covered_bins();
    $fdisplay(resp_fd, "%f %b %h %b %b %b %b", cov, bins, rsp.result, rsp.carry, rsp.zero, rsp.overflow, rsp.negative);
    $fflush(resp_fd);
    rsp_event.trigger();
  endfunction
endclass