from scipy.io import loadmat
import numpy as np 
import pandas as pd

mat = loadmat("aes_power_data.mat")

# df = pd.DataFrame(mat["sbox"])

# df.to_csv("sbox.csv")

print(mat)