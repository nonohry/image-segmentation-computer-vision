function [cluster pcc] = k_means(fv, k, max_it, eps, truthImg)
% KMEAN
% TuanND
% 03/21
fprintf('K-Mean Steps...\n');
[rows cols] = size(truthImg);
%Step 1:Set Nc =1 (iteration number).
it = 1;
%Step 2: Choose randomly a set of K means
c_fv = init_kmeans(k, fv, 'rand');
%Step 3:For each vector x, compute for each k=1,2,…,K,  and assign x to the 
%cluster with the nearest distance
[cluster obj_fn] = k_classify(fv, c_fv);
%Step 4: Loop update center and classify
while (it < max_it)    
    it = it + 1;    
    %Update center (means)
    new_c_fv = update_cfv(fv, cluster, c_fv);    
    %Classify based on new means
    [new_cluster new_obj_fn] = k_classify(fv, new_c_fv);    
    %Stop if no significant change on objective function or centers
    delta_obj_fn = 100*abs(new_obj_fn - obj_fn)/obj_fn;       
    if (delta_obj_fn <= eps) 
        c_fv = new_c_fv;
        cluster = new_cluster;
        obj_fn = new_obj_fn;        
        break;
    else
        c_fv = new_c_fv;
        cluster = new_cluster;
        obj_fn = new_obj_fn;        
    end
    map = reshape(cluster, cols, rows);
    map = map';
    pcc = 100 * accuracy(truthImg,map);    
    fprintf('\tIteration:[%02u]---Delta_Obj_Fn:[%2.3f/100]---PCC:[%02.2f/100]\n', it, delta_obj_fn, pcc );
end
