# Cocotb-friendly Makefile for Xcelium, with options for AI/ML

COMPILER = xrun
UVM_OPTS = -uvm -uvmhome CDNS-1.2
FILES = -f tb/filelist.f
BUILD_DIR = xcelium.d
AI ?= 0
PIPE ?= stim_pipe
RESP_PIPE ?= resp_pipe
ALGO ?= ppo
WORKERS ?= 4
TIMEOUT = 1000ns

compile:
	$(COMPILER) $(UVM_OPTS) $(FILES) -top tb_top -elaborate -xmlibdirname $(BUILD_DIR)

run:
	$(COMPILER) -R -xmlibdirname $(BUILD_DIR) -run -timescale 1ns/1ps -access +rwc \
	+ai_mode=$(AI) +pipe_name=$(PIPE) +resp_pipe_name=$(RESP_PIPE) \
	+algo=$(ALGO) +workers=$(WORKERS) -timeout $(TIMEOUT)

clean:
	rm -rf $(BUILD_DIR) *.log