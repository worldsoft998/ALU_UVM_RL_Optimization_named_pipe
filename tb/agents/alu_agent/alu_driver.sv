
class alu_driver extends uvm_driver#(alu_seq_item);
  `uvm_component_utils(alu_driver)
  virtual alu_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif);
  endfunction

  task run_phase(uvm_phase phase);
    alu_seq_item item;
    forever begin
      seq_item_port.get_next_item(item);
      vif.a = item.a;
      vif.b = item.b;
      vif.op = item.op;
      #0;  // Allow DUT to compute
      seq_item_port.item_done();
    end
  endtask
endclass