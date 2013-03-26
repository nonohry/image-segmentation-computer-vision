function c_fv = init_kmeans(K, fv, type)
% INIT_KMEANS: initialize a set of k means
% TuanND
% 03/17

[num_pixel num_layer] = size(fv);
rng('shuffle');
switch type
    case 'rand'
        init_pos = randi(num_pixel, K, 1);
    case 'adapt'
        rc = randi(128, 4 , 2);
        init_pos = [rc(1,1) * 256 + rc(1,2), (rc(2,1) + 128) * 256 + rc(2,2), rc(3,1) * 256 + rc(3,2) + 128, (rc(4,1)+128) * 256 + rc(4,2)+128];
    case 'fix'
        init_pos = [64 * 256 + 64, (64+128)*256+64, 64*256+64+128, (64+128) * 256 + 64+128];
end
c_fv = zeros(K, num_layer);
for i = 1:K
    c_fv(i,:) = fv(init_pos(i),:);
end
end