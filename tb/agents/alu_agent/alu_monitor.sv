
class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)
  virtual alu_if vif;
  uvm_analysis_port#(alu_seq_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif);
  endfunction

  task run_phase(uvm_phase phase);
    alu_seq_item item;
    forever begin
      @(vif.a or vif.b or vif.op);  // Wait for change
      #1;  // Settle
      item = alu_seq_item::type_id::create("item");
      item.a = vif.a;
      item.b = vif.b;
      item.op = vif.op;
      item.result = vif.result;
      item.carry = vif.carry;
      item.zero = vif.zero;
      item.overflow = vif.overflow;
      item.negative = vif.negative;
      ap.write(item);
    end
  endtask
endclass