
class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
  uvm_analysis_imp#(alu_seq_item, alu_scoreboard) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void write(alu_seq_item item);
    bit [8:0] exp_result;
    bit exp_carry, exp_zero, exp_overflow, exp_negative;
    case (item.op)
      4'h0: {exp_carry, exp_result[7:0]} = item.a + item.b;
      4'h1: {exp_carry, exp_result[7:0]} = item.a - item.b;
      4'h2: exp_result = item.a & item.b;
      4'h3: exp_result = item.a | item.b;
      4'h4: exp_result = item.a ^ item.b;
      4'h5: exp_result = item.a << item.b[2:0];
      4'h6: exp_result = item.a >> item.b[2:0];
      4'h7: exp_result = $signed(item.a) >>> item.b[2:0];
      4'h8: {exp_carry, exp_result[7:0]} = item.a * item.b;
      default: exp_result = 8'h0;
    endcase
    exp_zero = (exp_result == 8'h0);
    exp_negative = exp_result[7];
    if (item.op == 4'h0) exp_overflow = (item.a[7] == item.b[7]) & (exp_result[7] != item.a[7]);
    if (item.op == 4'h1) exp_overflow = (item.a[7] != item.b[7]) & (exp_result[7] != item.a[7]);
    if (item.result != exp_result[7:0]) `uvm_error("SCB", "Result mismatch")
    // Similar checks for flags
  endfunction
endclass