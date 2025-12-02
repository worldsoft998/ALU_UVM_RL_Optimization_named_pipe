
class alu_random_seq extends alu_base_seq;
  `uvm_object_utils(alu_random_seq)
  int num_items = 1000;

  function new(string name = "alu_random_seq");
    super.new(name);
  endfunction

  task body;
    alu_seq_item item;
    repeat (num_items) begin
      item = alu_seq_item::type_id::create("item");
      start_item(item);
      item.randomize();
      item.op = item.op % 9;  // Limit to 0-8
      finish_item(item);
    end
  endtask
endclass