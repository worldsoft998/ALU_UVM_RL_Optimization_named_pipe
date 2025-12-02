
class alu_base_seq extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(alu_base_seq)

  function new(string name = "alu_base_seq");
    super.new(name);
  endfunction
endclass