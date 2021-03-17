

% Load plaintext, ciphertext, traces, and sbox
load 'aes_power_data.mat';  
bytes_recovered = zeros (1,16);
n_traces = 200; 

traces = traces (1:n_traces, :); 
%% Launch DPA and compute DoM , size of DoM 256 x 40000
peaks = [];
for pos = 16:16  
    peaks = [];
    for k=0:255
        bins_0 = [];
        bins_1 = [];
        for t = 1:n_traces
            xored = bitxor(plain_text(t,pos),k);
            lsb_prediction = bitget(sbox(xored+1),1);
            if lsb_prediction == 0
                bins_0 = [bins_0;traces(t,:)];
            else
                bins_1 = [bins_1;traces(t,:)];
            end
        end
        avg_bins_0 = mean(bins_0);
        avg_bins_1 = mean(bins_1);
        peaks = [peaks; max(abs(avg_bins_0 - avg_bins_1))];
    end
    [max_peak, guess] = max(peaks);
    guessed_key = guess - 1; 
    res = compose('pos %d guess 0x%X',pos, guessed_key);
    disp(res)
end

%%
% dec2hex(bytes_recovered) 
%% Sampe code to  plots 
% OFFSSET= 192 ; % for N=64, 0 , 64. 128, 192
% N=8; % for an NxN plot
% for i = 1:N
%     for j  =1:N
%         subplot(N,N,(i-1)*N+j)
%         k = (i-1)*N+j+OFFSSET;
%         plot(DoM (k, :));
%         ylim([-10 10]);
%     end
% end