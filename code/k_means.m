function [cluster psa map_vt objfn_vt psa_vt] = k_means(fv, k, max_it, eps, truthImg, init_type)
% KMEAN
% TuanND
% 03/21
km_startTime = tic;
fprintf('K-Mean Steps...\n');

[rows cols] = size(truthImg);
map_vt = cell(max_it, 1);
objfn_vt = zeros(max_it, 1);
psa_vt = zeros(max_it, 1);

%Step 1:Set Nc =1 (iteration number).
it = 1;
%Step 2: Choose randomly a set of K means
c_fv = init_kmeans(k, fv, init_type);
%Step 3:For each vector x, compute for each k=1,2,…,K,  and assign x to the
%cluster with the nearest distance
[cluster objfn_vt(1)] = k_classify(fv, c_fv);
map = reshape(cluster, cols, rows);
map = map';
psa_vt(1) = accuracy(truthImg, map);
map_vt{1} = map;
%Step 4: Loop update center and classify
while (it < max_it)
    it_startTime = tic;
    it = it + 1;
    %Update center (means)
    new_c_fv = update_cfv(fv, cluster, c_fv);
    %Classify based on new means
    [new_cluster objfn_vt(it)] = k_classify(fv, new_c_fv);
    %Stop if no significant change on objective function or centers
    delta_obj_fn = abs(objfn_vt(it) - objfn_vt(it-1));
    if (delta_obj_fn < eps) %encounter stop condition
        map = reshape(new_cluster, cols, rows);
        map = map';
        psa_vt(it) = accuracy(truthImg, map);
        map_vt{it} = map;
        it_elapsedTime = toc(it_startTime);
        fprintf('\tIteration:[%02u]---Obj_Fn:[%5.4f]---Accuracy:[%02.2f]---Duration:[%3.3f(s)]\n', it, objfn_vt(it), psa_vt(it), it_elapsedTime );
        break;
    else
        c_fv = new_c_fv;
        map = reshape(new_cluster, cols, rows);
        map = map';
        psa_vt(it) = accuracy(truthImg, map);
        map_vt{it} = map;
        cluster = new_cluster;
        it_elapsedTime = toc(it_startTime);
        fprintf('\tIteration:[%02u]---Obj_Fn:[%5.4f]---Accuracy:[%02.2f]---Duration:[%3.3f(s)]\n', it, objfn_vt(it), psa_vt(it), it_elapsedTime );
    end
    
end
psa = psa_vt(it);
km_elapsedTime = toc(km_startTime);
fprintf('Done K-means with one initialization in %3.3f (s).\n', km_elapsedTime);
end
