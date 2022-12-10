%% Use FFT to move to frequency domain
% Remove cyclic prefix extension and shift from serial to parallel
x_p = reshape(x_s_noise_fading,nfft+n_cpe,length(x_s_noise_fading)/(nfft+n_cpe));
x_p_cpr = x_p(n_cpe+1:end,:);

% Move to frequency domain
X_hat_blocks = fft(x_p_cpr);
%% Channel estimation

 G = X_hat_blocks(:,1)./X_blocks(:,1);
 X_hat_blocks = X_hat_blocks./repmat(G,1,size(X_hat_blocks,2));
%% Symbol demodulation
% remove fft padding 
X_hat = X_hat_blocks(:);
X_hat = X_hat(1:end-fft_rem);

dem_symbol = qamdemod(X_hat,4);

sym_rem = 0;

rec_syms_cons = de2bi(dem_symbol);
rec_im_bin = reshape(rec_syms_cons',numel(rec_syms_cons),1);
rec_im_bin = rec_im_bin(1:end-sym_rem);
ber = sum(abs(rec_im_bin-data_bits))/length(data_bits);
