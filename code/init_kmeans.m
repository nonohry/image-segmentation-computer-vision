function c_fv = init_kmeans(K, fv, type)
% INIT_KMEANS: initialize a set of k means
% TuanND
% 03/17

[num_pixel dim] = size(fv);
rng('shuffle');
c_fv = zeros(K, dim);
switch type
    case 'rand'
        init_pos = randi(num_pixel, K, 1);
        for i = 1:K
            c_fv(i,:) = fv(init_pos(i),:);
        end
    case 'furthest'
        init_pos = zeros(K,1);
        init_pos(1) = randi(num_pixel, 1);
        c_fv(1,:) = fv(init_pos(1),:);
        for i = 2:K
            d2c = dist2center(fv, c_fv(1:(i-1),:));
            [dummy idx] = max(max(d2c,[],2));
            c_fv(i,:) = fv(idx,:);
        end
    case 'plusplus'
        init_pos = zeros(K,1);
        init_pos(1) = randi(num_pixel, 1);
        c_fv(1,:) = fv(init_pos(1),:);
        for i = 2:K
            d2c = dist2center(fv, c_fv(1:(i-1),:));
            d2c = d2c.^2;            
            min_d2c = min(d2c,[],2);
            min_d2c = min_d2c./sum(min_d2c);
            idx = randsample(1:num_pixel, 1, true, min_d2c);
            c_fv(i,:) = fv(idx,:);
        end        
end
end