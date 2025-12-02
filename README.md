# ALU UVM Testbench with RL Optimization

This repo provides an 8-bit ALU DUT, a SystemVerilog UVM testbench, and Python RL modules for stimulus optimization to minimize test time and accelerate coverage closure.

## Setup

- Install SV simulator: Cadence Xcelium or Synopsys VCS.
- For RL: `pip install -r rl/requirements.txt`
- Compile & run non-AI: `make run AI=0`
- Train RL: `python rl/train.py`
- Evaluate & compare: `python rl/evaluate.py`

## Options in Makefile

- AI=1: Enable AI mode (requires PIPE and RESP_PIPE plusargs if manual).
- ALGO=ppo: Choose algorithm (only ppo supported).
- WORKERS=4: Number of parallel simulators for training.
- Use `make compile` to build, `make run` to simulate.

See docs/ for architecture and diagrams.