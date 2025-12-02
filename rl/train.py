
import gymnasium as gym
from stable_baselines3 import PPO
from stable_baselines3.common.vec_env import SubprocVecEnv
from stable_baselines3.common.env_util import make_vec_env
from alu_env import AluEnv

num_workers = 4  # Parallel simulators
vec_env = SubprocVecEnv([lambda: AluEnv() for i in range(num_workers)])
model = PPO("MlpPolicy", vec_env, verbose=1)
model.learn(total_timesteps=100000)  # Adjust as needed
model.save("alu_ppo_model")
vec_env.close()