
from stable_baselines3 import PPO
from stable_baselines3.common.evaluation import evaluate_policy
from alu_env import AluEnv
import numpy as np

model = PPO.load("alu_ppo_model")
env = AluEnv()

# Evaluate RL policy
rl_rewards, rl_lengths = evaluate_policy(model, env, n_eval_episodes=10, return_episode_rewards=True)
print(f"RL: Avg steps to closure: {np.mean(rl_lengths)}, Avg reward: {np.mean(rl_rewards)}")

# Evaluate random
random_lengths = []
for _ in range(10):
    obs, _ = env.reset()
    steps = 0
    terminated = False
    while not terminated:
        action = env.action_space.sample()
        obs, reward, terminated, _, _ = env.step(action)
        steps += 1
    random_lengths.append(steps)
print(f"Random: Avg steps to closure: {np.mean(random_lengths)}")

env.close()