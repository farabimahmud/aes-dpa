

% Load plaintext, ciphertext, traces, and sbox
load 'aes_power_data.mat';  
bytes_recovered = zeros (1,16);
n_traces = 10; 
pos = 16;
traces = traces (1:n_traces, :); 

%% Launch DPA and compute DoM , size of DoM 256 x 40000
disp(plain_text(1,pos))
% for k=1:256
%     for t = 1:n_traces
%         prediction = bitxor(plain_text(t,pos),k);
%         disp(prediction)
%     end
% end


%%
% dec2hex(bytes_recovered) 
% %% Sampe code to  plots 
% OFFSSET= 192 ; % for N=64, 0 , 64. 128, 192
% N=8; % for an NxN plot
% for i = 1:N
%     for j  =1:N
%         subplot(N,N,(i-1)*N+j)
%         plot(DoM ((i-1)*N+j+OFFSSET, :) )
%      
%     end
% end


