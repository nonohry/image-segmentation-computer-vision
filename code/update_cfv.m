function new_c_fv = update_cfv(fv, cluster, c_fv)
% UPDATE_CFV : update new means
% TuanND
% 03/21

[K dim] = size(c_fv);
new_c_fv = zeros(K, dim);
for k = 1:K    
    fv_ind = fv(cluster == k, :);
    new_c_fv(k,:) = mean(fv_ind);
end
end