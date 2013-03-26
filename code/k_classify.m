function [cluster obj_fn] = k_classify(fv, c_fv)
%K_CLASSIFY classify each pixel to the nearest center
% TuanND
% 03/17
num_pixel = size(fv, 1);
cluster = zeros(num_pixel, 1);
d2c = dist2center(fv, c_fv);%D(i,j,k) is the distance from (i,j) to center k
for i = 1:num_pixel
    [dij idx] = min(d2c(i,:));
    cluster(i) = idx;
end
%Compute objective function
obj_fn = obj_func(d2c, cluster);
end