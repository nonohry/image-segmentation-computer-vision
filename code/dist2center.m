function d2c = dist2center(fv, c_fv)
%dist2center: distance between each pixel to K means
%TuanND
%03/17
K = size(c_fv, 1);
num_pixel= size(fv, 1);
d2c = zeros(num_pixel, K);
for i = 1:num_pixel
    for k = 1:K
        d2c(i,k) = norm(fv(i,:) - c_fv(k,:));
    end
end
end