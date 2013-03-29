function [new_alpha new_nuy new_sigma] = em_m_step(fv, I, nuy)
% EM_M_STEP: m-step in EM
% TuanND
% 03/26
[num_pixel num_class] = size(I);
dim = size(fv, 2);
new_alpha = zeros(num_class, 1);
new_nuy = zeros(num_class,dim);
new_sigma = cell(num_class, 1);
for m = 1:num_class
    sumIk = sum(I(:,m));
    new_alpha(m) = sumIk/num_pixel;    
    ts = zeros(dim,dim);
    tn =zeros(1, dim);
    for l = 1:num_pixel
        tn = tn + fv(l,:) * I(l,m);
        ts = ts + I(l,m) * (fv(l,:)-nuy(m,:))' * (fv(l,:)-nuy(m,:));        
    end
    new_nuy(m,:) = tn/sumIk;
    new_sigma{m} = ts/sumIk;    
end
end