function [I em_cluster in_log_lf cpl_log_lf] = em_e_step(fv, K, alpha, nuy, sigma, xik)
% EM_E_STEP: do e_step in EM
% TuanND
% 03/23
fprintf('\t EM E-Steps...\n');
[num_pixel dim] = size(fv);
I = zeros(num_pixel, K);
lf  = zeros(num_pixel, K);
fprintf('\t\tLikelihood Function:[4/4]');
for k = 1:K
    fprintf('\b\b\b\b\b[%1u/%1u]-',k, K);
    sk = sigma{k};
    detsigma = det(sk);
    if(detsigma == 0)
        fprintf('\n det(sk) = 0\n');
        return;
    end
    dem = ((2*pi)^(dim/2)) * sqrt(detsigma);
    fprintf('[65536/65536]');
    for i = 1:num_pixel        
        fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b[%05u/%05u]', i, num_pixel);
        dif = fv(i,:) - nuy(k,:);        
        lf(i,k) = exp(-(1/2) * dif / sk * dif')/dem;
    end
    fprintf('\n');
end
fprintf('\n');
in_log_lf = 0;
cpl_log_lf = 0;
for i = 1:num_pixel
    norm_dem = sum(lf(i,:).*alpha');
    in_log_lf = in_log_lf + log(norm_dem);
    for k = 1:K
        I(i,k) = alpha(k) * lf(i,k)/norm_dem;
        cpl_log_lf = cpl_log_lf + xik(i,k) * log(alpha(k) * lf(i,k));
    end
end
[dummy em_cluster] = max(I,[],2);
end