clc;
clear all;
close all;

%% PARAMETERS
ROOT = '../imgs/';
IMG_NAME = 'mosaicB.bmp';
MAP_NAME = 'mapB.bmp';

NUM_INIT = 10; %Number of time doing K-Mean
MAX_IT = 20;%Max iteration number per time
K_EPS = 0.00001;
K = 3;%Number of class
init_type = 'rand';%init_type: 'rand'; 'furthest', 'plusplus'
EM_MAX_IT = 10;
EM_EPS = 0.000001;

%% load image
fprintf('Loading image...\n');
img = imread([ROOT,IMG_NAME]);
truthImg = imread([ROOT,MAP_NAME]);
[rows cols] = size(img);
fprintf('Done loading image.\n');

%% Compute normalized feature vectors
fv = fv_space(img);

%% K-MEAN STEPS
final_cluster_vt = cell(NUM_INIT, 1);
final_psa_vt = zeros(NUM_INIT, 1);
map_series_vt = cell(NUM_INIT, 1);
psa_series_vt = cell(NUM_INIT, 1);
objfn_series_vt = cell(NUM_INIT, 1);
for t = 1:NUM_INIT
    fprintf('K-Means: [%02u/%02u]\n', t, NUM_INIT);
    [final_cluster_vt{t} final_psa_vt(t) map_series_vt{t} objfn_series_vt{t} psa_series_vt{t}] = k_means(fv, K, MAX_IT, K_EPS, truthImg, init_type);
end
fprintf('Done K-Means as Init. for EM\n');
%% Init for EM
fprintf('Begin EM process...\n');
fprintf('Initializing...');
emStartTime = tic;
% init variables
alpha = cell(EM_MAX_IT,1);
nuy = cell(EM_MAX_IT, 1);
sigma = cell(EM_MAX_IT, 1);

I = cell(EM_MAX_IT, 1);
em_map_vt = cell(EM_MAX_IT, 1);
icLogLF = zeros(EM_MAX_IT, 1);
cLogLF = zeros(EM_MAX_IT, 1);
psa_vt = zeros(EM_MAX_IT, 1);

it = 1;

[pcc_best idx_best] = max(final_psa_vt);
k_cluster_best = final_cluster_vt{idx_best};
k_map_best = reshape(k_cluster_best, cols, rows);
k_map_best = k_map_best';
% xik = map_label(truthImg, k_map_best, K);

[alpha{1} nuy{1} sigma{1}] = init_em(fv, k_cluster_best, K);
fprintf('EM params...');
% E-STEP
[I{1} em_map_vt{1} icLogLF(1) cLogLF(1) psa_vt(1)] = em_e_step(fv, K, alpha{1}, nuy{1}, sigma{1}, truthImg, k_map_best);
itElapsedTime = toc(emStartTime);
fprintf('\nDone Initializing EM.\n');
fprintf('Iteration [%02u]-icLogLF:[%4.4f]-cLogLF:[%4.4f]-Accuracy[%2.3f]-Duration[%3.3f(s)]\n', it, icLogLF(it), cLogLF(it), psa_vt(it), itElapsedTime);
fprintf('Begin iteration....\n');
while (it < EM_MAX_IT)
    
    itStartTime = tic;
    it = it + 1;
    fprintf('Iteration [%02u]...', it);
    %M-STEP
    [alpha{it} nuy{it} sigma{it}] = em_m_step(fv, I{it-1}, nuy{it-1});
    %E-STEP
    [I{it} em_map_vt{it} icLogLF(it) cLogLF(it) psa_vt(it)] = em_e_step(fv, K, alpha{it}, nuy{it}, sigma{it}, truthImg, em_map_vt{it-1});
    delta_icLogLF = abs(icLogLF(it) - icLogLF(it-1));
    itElapsedTime = toc(itStartTime);
    fprintf('-icLogLF:[%4.4f]-cLogLF:[%4.4f]-Accuracy[%2.3f]-Duration[%3.3f(s)]\n', icLogLF(it), cLogLF(it), psa_vt(it), itElapsedTime);
    if delta_icLogLF < K_EPS        
        break;
    end
end
emElapsedTime = toc(emStartTime);
fprintf('Done EM in %3.3f(s)\n', emElapsedTime);
%% Show the final result
close all;
fprintf('Showing the result...\n');
fprintf('The accuray of the final map: %4.4f', psa_vt(it));
figure;
subplot(2,2,1); imshow(img, []);title('Original Image');
subplot(2,2,2); imshow(truthImg, []); title('Ground-truth map');
subplot(2,2,3); imshow(k_map_best, []); title(['Init map with accuracy = ', num2str(pcc_best)]);
subplot(2,2,4); imshow(em_map_vt{it}, []); title(['Final EM map with accuracy = ', num2str(psa_vt(it))]);
%plot objective function vs. iteration
figure; 
plot(1:it, icLogLF, '-ro', 1:it, cLogLF, '-gs');xlabel('Iteration Number'); ylabel('Data log-likelihodd');legend('Incomplete log-likelihood', 'Complete log-likelihodd');
title('Data log-likelihood vs. Iteration number');
%plot accuracy vs. iteration
figure;
plot(1:it, psa_vt, '-ro');xlabel('Iteration Number'); ylabel('Accuracy');
title('Accuracy vs. Iteration number');
%% create video
for i = 1:it
    frame(:,:,1) = em_map_vt{i};
    frame(:,:,2) = em_map_vt{i};
    frame(:,:,3) = em_map_vt{i};
    frame = floor(255*frame/4);
    em_mv(i) = im2frame(uint8(frame));
end
movie2avi(em_mv,'emB.avi','fps',1, 'compression', 'none');






