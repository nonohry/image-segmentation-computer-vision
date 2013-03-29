function [I em_map icLogLF cLogLF psa] = em_e_step(fv, K, alpha, nuy, sigma, truthImg, cur_map)
% EM_E_STEP: do e_step in EM
% TuanND
% 03/23
fprintf('E-Steps:[4/4]');
[num_pixel dim] = size(fv);
[rows cols] = size(truthImg);
xik = zeros(num_pixel, K);
for i = 1:rows
    for j = 1:cols
        k = cur_map(i,j);
        xik((i-1)*cols + j, k) = 1;
    end
end
I = zeros(num_pixel, K);
pLF  = zeros(num_pixel, K);
for m = 1:K
    fprintf('\b\b\b\b\b');
    fprintf('[%1u/%1u]',m, K);
    sk = sigma{m};
    det_sigma = det(sk);
    denominator = ((2*pi)^(dim/2)) * sqrt(det_sigma);        
    for l = 1:num_pixel          
        dif = fv(l,:) - nuy(m,:);        
        pLF(l,m) = exp(-(1/2) * dif / sk * dif')/denominator;
    end    
end
icLogLF = 0;
cLogLF = 0;
for l = 1:num_pixel
    norm_denominator = sum(pLF(l,:).*alpha');
    icLogLF = icLogLF + log(norm_denominator);
    for m = 1:K
        I(l,m) = alpha(m) * pLF(l,m)/norm_denominator;
        if(alpha(m) * pLF(l,m) ~= 0)
            cLogLF = cLogLF + xik(l,m) * log(alpha(m) * pLF(l,m));
        end
        
    end
end
[max_prob em_map] = max(I,[],2);
em_map = reshape(em_map, cols, rows)';
psa = accuracy(truthImg, em_map, K);
end