function obj_fn = obj_func(d2c, cluster)
%OBJ_FUNC: compute objective function value
%TuanND
%03/17
obj_fn = 0;
num_pixel = length(cluster);
for i = 1:num_pixel
    k = cluster(i);
    obj_fn = obj_fn + d2c(i,k)^2;
end
end