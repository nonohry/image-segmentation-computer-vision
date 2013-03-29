function fv = fv_space(img)
% FV_SPACE: compute the feature vectors
% TuanND
% 03/17
fprintf('Computing feature vectors...\n');
nscale = 4;%Number of scale
norient = 6;%Number of orientation
minWaveLength = 3;% Wavelength of smallest scale filter.
mult = 2;%Scaling factor between successive filters.
sigmaOnf =0.65;%Ratio of the standard deviation of the Gaussian describing the log Gabor filter's transfer function
%	                       in the frequency domain to the filter center
%	                       frequency.
dThetaOnSigma = 1.5;%Ratio of angular interval between filter orientations
%			       and the standard deviation of the angular Gaussian
%			       function used to construct filters in the
%                              freq. plane.
% Gabor filtered images
[rows cols] = size(img);
N = rows * cols;
num_layer = nscale * norient;
layer = gaborconvolve(img, nscale, norient, minWaveLength, mult, sigmaOnf, dThetaOnSigma);
%Extract feature vector for each pixel
layer = reshape(layer, 1, []);
temp = zeros(rows, cols, num_layer);
for k = 1:num_layer
    temp(:,:,k) = abs(layer{k});
end
fv = zeros(N, num_layer);
for i = 1:rows
    for j = 1:cols
        fv((i-1)*cols + j, :) = squeeze(temp(i,j,:));
    end
end
min_fv = min(fv);
max_fv = max(fv);
for n = 1:N
    fv(n,:) = (fv(n,:) - min_fv)./(max_fv - min_fv);
end
fprintf('Done computing feature vector.\n');
end