
`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_pkg::*;

module tb_top;
  bit clk = 0;
  always #5 clk = ~clk;

  alu_if alu_vif();

  alu dut (
    .a(alu_vif.a),
    .b(alu_vif.b),
    .op(alu_vif.op),
    .result(alu_vif.result),
    .carry(alu_vif.carry),
    .zero(alu_vif.zero),
    .overflow(alu_vif.overflow),
    .negative(alu_vif.negative)
  );

  initial begin
    uvm_config_db#(virtual alu_if)::set(null, "*", "vif", alu_vif);
    run_test();
  end
endmodule