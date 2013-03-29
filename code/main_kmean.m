clc;
clear all;
close all;

%% PARAMETERS
ROOT = '../imgs/';
IMG_NAME = 'mosaicA.bmp';
MAP_NAME = 'mapA.bmp';

NUM_INIT = 10; %Number of time doing K-Mean
MAX_IT = 20;%Max iteration number per time
EPS = 0.0001;
K = 4;%Number of class
init_type = 'rand';%init_type: 'rand'; 'furthest', 'plusplus'

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
    [final_cluster_vt{t} final_psa_vt(t) map_series_vt{t} objfn_series_vt{t} psa_series_vt{t}] = k_means(fv, K, MAX_IT, EPS, truthImg, init_type);
end

%% Show best results
[pcc_sort idx_sort] = sort(final_psa_vt, 'descend');
cluster_best = final_cluster_vt{idx_sort(1)};
map_best = reshape(cluster_best, cols, rows);
map_best = map_best';
cluster_worse = final_cluster_vt{idx_sort(end)};
map_worse = reshape(cluster_worse, cols, rows);
map_worse = map_worse';
fprintf('The best accuracy: %1.2f\n', pcc_sort(1));
fprintf('The worse accuracy: %1.2f\n', pcc_sort(end));
figure; subplot(2,2,1);imshow(img,[]);title('Original image');
subplot(2,2,2); imshow(truthImg, []);title('Ground-truth map');
subplot(2,2,3); imshow(map_best, []);title(['Best map with accuracy = ', num2str(pcc_sort(1))]);
subplot(2,2,4); imshow(map_worse, []);title(['worst map with accuracy = ', num2str(pcc_sort(end))]);
% Plot objective function vs. iteration number of best case/worse
% case/medidum case
figure;
plot(20*log10(objfn_series_vt{idx_sort(1)}), '-ro','LineWidth',2);xlabel('Interation Number');ylabel('Objective Function');hold on;
plot(20*log10(objfn_series_vt{idx_sort(end)}),'-gs','LineWidth',2);xlabel('Interation Number');ylabel('Objective Function');hold on;
plot(20*log10(objfn_series_vt{idx_sort(4)}),'-b.','LineWidth',2);xlabel('Interation Number');ylabel('Objective Function');legend('Best case','Worse case','Average case');

%% Plot accuracy vs. iteration number of best case/worse case/m. case
figure;
plot(psa_series_vt{idx_sort(1)}, '-ro','LineWidth',2);xlabel('Interation Number');ylabel('Accuracy');hold on;
plot(psa_series_vt{idx_sort(end)},'-gs','LineWidth',2);xlabel('Interation Number');ylabel('Accuracy');hold on;
plot(psa_series_vt{idx_sort(4)},'-b.','LineWidth',2);xlabel('Interation Number');ylabel('Accuracy');legend('Best case','Worse case','Average case');
%% Write to video the best case
best_frames = map_series_vt{idx_sort(1)};
for i = 1:MAX_IT
    if best_frames{i}
        frame(:,:,1) = best_frames{i};
        frame(:,:,2) = best_frames{i};
        frame(:,:,3) = best_frames{i};
        frame = floor(255*frame/4);
        img_seg_movie(i) = im2frame(uint8(frame));
    else
        break;
    end
    
end
movie2avi(img_seg_movie,'kmean.avi','fps',1, 'compression', 'none');





