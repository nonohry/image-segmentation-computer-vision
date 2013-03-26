clc;
clear all;
close all;

%% PARAMETERS
ROOT = '../imgs/';
IMG_NAME = 'mosaicA.bmp';
MAP_NAME = 'mapA.bmp';

% for K-mean
NUM_INIT = 10; %Number of time doing K-Mean
MAX_IT = 10;%Max iteration number per time
EPS = 0.0001;
K = 4;%Number of class

% for EM
MAX_EM_IT = 20;

%% load image
fprintf('Loading image...\n');
img = imread([ROOT,IMG_NAME]);
truthImg = imread([ROOT,MAP_NAME]);
[rows cols] = size(img);
num_pixel = rows * cols;
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
k_cluster_best = cl_vt{idx_best};
k_map_best = reshape(k_cluster_best, cols, rows);
k_map_best = k_map_best';
figure;imshow(k_map_best,[]);
xik = map_label(truthImg, k_map_best, K);
%% Init for EM

alpha = cell(MAX_EM_IT,1);
nuy = cell(MAX_EM_IT, 1);
sigma = cell(MAX_EM_IT, 1);
I = cell(MAX_EM_IT, 1);
it = 1;
[alpha{1} nuy{1} sigma{1}] = init_em(fv, k_cluster_best, K);
%% E-STEP
[I{1} em_cluster in_log_lf cpl_log_lf] = em_e_step(fv, K, alpha{1}, nuy{1}, sigma{1}, xik);

%%
while (it < MAX_EM_IT)
    it = it + 1;
    %M-STEP
    [alpha{it} nuy{it} sigma{it}] = em_m_step(fv, I{it-1});
    %E-STEP
    [I{it} new_em_cluster new_in_log_lf new_cpl_log_lf] = em_e_step(fv, K, alpha{it}, nuy{it}, sigma{it}, xik);
    delta_log_lf = abs(100*(new_in_log_lf - in_log_lf)/in_log_lf);
    if delta_log_lf < EPS        
        break;
    else
        em_cluster = new_em_cluster;
        in_log_lf = new_in_log_lf;
        cpl_log_lf = new_cpl_log_lf;
    end
end

%% Show the final result
em_map = reshape(em_cluster, cols, rows);
em_map = em_map';
figure;imshow(em_map, []);









