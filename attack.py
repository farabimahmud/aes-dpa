import pandas as pd
import numpy as np
import matplotlib.pyplot as plt 


N_TRACES = 200
BYTE_TO_ATTACK = 16 
BYTE_POS = BYTE_TO_ATTACK -1


def get_dom(bins_0, bins_1):
    avg_0 = np.mean(bins_0, axis=0)
    avg_1 = np.mean(bins_1, axis=0)
    dom =  np.abs(avg_0 - avg_1)
    return dom


def plot_dom(dom, k):
    '''
    dom = Difference of Mean Array
    k = key
    '''
    plt.plot(dom)
    plt.title("key={}".format(k))
    plt.ylim([-10,10])
    plt.savefig("outputs/key_{}.png".format(k))
    plt.cla()


ciphers = pd.read_csv("cipher.csv",nrows=N_TRACES, index_col=0).to_numpy()
plains = pd.read_csv("plain.csv",nrows=N_TRACES, index_col=0).to_numpy()
sbox = pd.read_csv("sbox.csv", index_col=0).to_numpy()
traces = pd.read_csv("traces.csv", nrows=N_TRACES, index_col=0).to_numpy()
results = []
for k in range(256):
    bins_0 = np.zeros((1,40000))
    bins_1 = np.zeros((1,40000))
    for j in range(N_TRACES):
        key_guess = k 
        plaintext = first_byte = plains[j][BYTE_POS]
        xored_input = key_guess ^ plaintext 
        predicted_output = sbox[0][xored_input]
        lsb_predicted = predicted_output & 0x01 
        # print(lsb_predicted, j) 
        t_add = np.array(traces[j])
        if (lsb_predicted == 1):
            bins_0 = np.vstack([bins_0, t_add])
        else:
            bins_1 = np.vstack([bins_1, t_add])

    bins_0 = bins_0[1:]            
    bins_1 = bins_1[1:]

    peak = np.max(np.abs(get_dom(bins_0, bins_1)), axis=0)
    results.append((k, peak))
print(results)
print(np.argmax(results,))
# print(get_dom(bins_0, bins_1))

