
class alu_seq_item extends uvm_sequence_item;
  rand bit [7:0] a;
  rand bit [7:0] b;
  rand bit [3:0] op;
  bit [7:0] result;
  bit carry;
  bit zero;
  bit overflow;
  bit negative;

  `uvm_object_utils_begin(alu_seq_item)
    `uvm_field_int(a, UVM_ALL_ON)
    `uvm_field_int(b, UVM_ALL_ON)
    `uvm_field_int(op, UVM_ALL_ON)
    `uvm_field_int(result, UVM_ALL_ON)
    `uvm_field_int(carry, UVM_ALL_ON)
    `uvm_field_int(zero, UVM_ALL_ON)
    `uvm_field_int(overflow, UVM_ALL_ON)
    `uvm_field_int(negative, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "alu_seq_item");
    super.new(name);
  endfunction
endclass