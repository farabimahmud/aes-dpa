


% Load plaintext, ciphertext, traces, and sbox
load 'aes_power_data.mat';  
bytes_original = [0x00 0x11 0x22 0x33 0x44 0x55 0x66 0x77 0x88 0x99 0xAA 0xBB 0xCC 0xDD 0xEE 0xFF];


bytes_recovered = zeros (1,16);
n_traces = 200; 
n_trace_options = [200];
%% launch DPA
for nt = 1:length(n_trace_options)
    n_traces = n_trace_options(nt);
    disp(n_traces);
    c_traces = traces (1:n_traces, :); 
    for pos = 1:16  
        peaks = [];
        %% calculte peaks from pos 
        for k=0:255
            bins_0 = [];
            bins_1 = [];
            %% calculate the peaks from each bins
            for t = 1:n_traces
                xored = bitxor(plain_text(t,pos),k);
                lsb_prediction = bitget(sbox(xored+1),1);
                if lsb_prediction == 0
                    bins_0 = [bins_0;c_traces(t,:)];
                else
                    bins_1 = [bins_1;c_traces(t,:)];
                end
            end
            avg_bins_0 = mean(bins_0);
            avg_bins_1 = mean(bins_1);
            peaks = [peaks; max(abs(avg_bins_0 - avg_bins_1))];
        end
        [max_peak, guess] = max(peaks);
        bytes_recovered(pos)  = guess - 1; 
        disp(guess-1);
    end
    key = sprintf('%s ',dec2hex(bytes_recovered));
    disp(key);
    res = sprintf('n_traces %d accuracy %f', n_trace_options(nt), getAccuracy(bytes_original, bytes_recovered));
    disp(res);
end


% %%
% % dec2hex(bytes_recovered) 
% %% Sampe code to  plots 
% % OFFSSET= 192 ; % for N=64, 0 , 64. 128, 192
% % N=8; % for an NxN plot
% % for i = 1:N
% %     for j  =1:N
% %         subplot(N,N,(i-1)*N+j)
% %         k = (i-1)*N+j+OFFSSET;
% %         plot(DoM (k, :));
% %         ylim([-10 10]);
% %     end
% % end


function acc = getAccuracy(original, guess)
    correct = 0;    
    for i =1:length(original)
        org_byte = dec2bin(original(i),8);
        guess_byte = dec2bin(guess(i),8);
        for j = 1:8
            if org_byte(j) == guess_byte(j)
                correct = correct +1;
            end           
        end
    end
    acc =100.0 * correct / length(original) / 8;
end 