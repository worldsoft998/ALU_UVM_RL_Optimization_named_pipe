
class alu_coverage extends uvm_component;
  `uvm_component_utils(alu_coverage)
  uvm_analysis_imp#(alu_seq_item, alu_coverage) ap;
  alu_seq_item item;
  bit [80:0] covered_bins = 0;
  covergroup cg;
    op: coverpoint item.op { bins ops[] = {0 to 8}; }
    a_bin: coverpoint get_bin(item.a) { bins bins[] = {0,1,2}; }
    b_bin: coverpoint get_bin(item.b) { bins bins[] = {0,1,2}; }
    cross op, a_bin, b_bin;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg = new();
    ap = new("ap", this);
  endfunction

  function int get_bin(bit [7:0] val);
    if (val < 64) return 0;
    else if (val < 192) return 1;
    else return 2;
  endfunction

  function void write(alu_seq_item itm);
    item = itm;
    cg.sample();
    int index = item.op * 9 + get_bin(item.a) * 3 + get_bin(item.b);
    covered_bins[index] = 1;
  endfunction

  function real get_cov();
    return cg.get_coverage();
  endfunction

  function bit [80:0] get_covered_bins();
    return covered_bins;
  endfunction
endclass