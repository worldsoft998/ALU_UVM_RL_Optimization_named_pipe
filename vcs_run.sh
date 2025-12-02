#!/bin/bash
# VCS run script
AI=${1:-0}
PIPE=${2:-stim_pipe}
RESP_PIPE=${3:-resp_pipe}

vcs -full64 -sverilog +v2k -timescale=1ns/1ps +incdir+tb +incdir+tb/agents/alu_agent +incdir+tb/env +incdir+tb/sequences +incdir+tb/tests \
dut/alu.sv tb/*.sv tb/agents/alu_agent/*.sv tb/env/*.sv tb/sequences/*.sv tb/tests/*.sv -top tb_top -uvm -debug_access+all

./simv +ai_mode=$AI +pipe_name=$PIPE +resp_pipe_name=$RESP_PIPE