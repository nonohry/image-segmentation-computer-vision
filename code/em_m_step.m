function [new_alpha new_nuy new_sigma] = em_m_step(fv, I)
[num_pixel num_class] = size(I);
dim = size(fv, 2);
new_alpha = zeros(num_class, 1);
new_nuy = zeros(num_class,dim);
new_sigma = cell(num_class, 1);
for k = 1:num_class
    sumIk = sum(I(:,k));
    new_alpha(k) = sumIk/num_pixel;    
    ts = zeros(dim,dim);
    tn =zeros(1, dim);
    for i = 1:num_pixel
        tn = tn + fv(i,:) * I(i,k);
        ts = ts + I(i,k) * (fv(i,:)-new_nuy(k,:))' * (fv(i,:)-new_nuy(k,:));        
    end
    new_nuy(k,:) = tn/sumIk;
    new_sigma{k} = ts/sumIk;    
end
end