
import gymnasium as gym
from gymnasium import spaces
import os
import subprocess
import time
import select
import numpy as np
import uuid

class AluEnv(gym.Env):
    def __init__(self):
        self.action_space = spaces.MultiDiscrete([9, 256, 256])  # op 0-8, a 0-255, b 0-255
        self.observation_space = spaces.Box(low=0, high=1, shape=(81,), dtype=np.float32)  # 81 coverage bins
        self.unique_id = str(uuid.uuid4())[:8]
        self.pipe_name = f"stim_pipe_{self.unique_id}"
        self.resp_pipe_name = f"resp_pipe_{self.unique_id}"
        self.current_cov = np.zeros(81, dtype=np.float32)
        self.prev_num_covered = 0
        self.sim_process = None
        self.stim_fd = None
        self.resp_fd = None

    def reset(self, seed=None, options=None):
        super().reset(seed=seed)
        if self.sim_process:
            self.sim_process.terminate()
            os.unlink(self.pipe_name)
            os.unlink(self.resp_pipe_name)
        os.mkfifo(self.pipe_name)
        os.mkfifo(self.resp_pipe_name)
        # Assume Makefile compiles once; run with AI=1
        self.sim_process = subprocess.Popen([
            "xrun", "-R", "-xmlibdirname", "xcelium.d", "-run",
            "+ai_mode=1", f"+pipe_name={self.pipe_name}", f"+resp_pipe_name={self.resp_pipe_name}"
        ])
        time.sleep(1)  # Wait for SV to open pipes
        self.stim_fd = open(self.pipe_name, 'w')
        self.resp_fd = open(self.resp_pipe_name, 'r')
        self.current_cov = np.zeros(81, dtype=np.float32)
        self.prev_num_covered = 0
        return self.current_cov, {}

    def step(self, action):
        op, a, b = action
        print(f"{op:x} {a:x} {b:x}", file=self.stim_fd)
        self.stim_fd.flush()
        r, _, _ = select.select([self.resp_fd], [], [], 5.0)  # Timeout 5s
        if not r:
            return self.current_cov, -1, True, {}  # Timeout, terminate
        line = self.resp_fd.readline().strip()
        parts = line.split()
        cov_perc = float(parts[0])
        covered_str = parts[1]
        # Ignore other fields for now
        covered_list = [int(c) for c in covered_str]
        self.current_cov = np.array(covered_list, dtype=np.float32)
        num_covered = np.sum(self.current_cov)
        reward = (num_covered - self.prev_num_covered) + 0.01 * (81 - num_covered)  # Shaping: small bonus for unfinished
        self.prev_num_covered = num_covered
        terminated = (num_covered == 81)
        truncated = False
        return self.current_cov, reward, terminated, truncated, {}

    def close(self):
        if self.sim_process:
            self.sim_process.terminate()
        if self.stim_fd: self.stim_fd.close()
        if self.resp_fd: self.resp_fd.close()
        os.unlink(self.pipe_name)
        os.unlink(self.resp_pipe_name)