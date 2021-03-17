import pandas as pd 


sbox = pd.read_csv("sbox.csv", index_col=0).to_numpy()
predicted_output = sbox[0][0]

print(predicted_output)