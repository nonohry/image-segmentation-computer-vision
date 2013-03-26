clc;
clear all;
close all;

%% PARAMETERS
ROOT = '../imgs/';
IMG_NAME = 'mosaicA.bmp';
MAP_NAME = 'mapA.bmp';

NUM_INIT = 10; %Number of time doing K-Mean
MAX_IT = 20;%Max iteration number per time
EPS = 0.000001;
K = 4;%Number of class

%% load image
fprintf('Loading image...\n');
img = imread([ROOT,IMG_NAME]);
truthImg = imread([ROOT,MAP_NAME]);
[rows cols] = size(img);
fprintf('Done loading image.\n');

%% Compute normalized feature vectors
fv = fv_space(img);

%% K-MEAN STEPS
cl_vt = cell(NUM_INIT, 1);
pcc_vt = zeros(NUM_INIT,1);
for t = 1:NUM_INIT
    fprintf('K-Means: [%02u/%02u]\n', t, NUM_INIT);
    [cluster pcc] = k_means(fv, K, MAX_IT, EPS, truthImg);
    cl_vt{t} = cluster;
    pcc_vt(t) = pcc;
end

%% Show best results
[pcc_best idx_best] = max(pcc_vt);
cluster_best = cl_vt{idx_best};
fprintf('Showing the result...\n');
map = reshape(cluster_best, cols, rows);
map = map';
figure; imshow(map, []);








