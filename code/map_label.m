function xik = map_label(truthImg,resultMap,K)
truthImg = double(truthImg);
[rows cols]=size(truthImg);
Z=zeros(256,256);
for i=1:rows
    for j=1:cols
        p=truthImg(i,j)+1;
        q=resultMap(i,j);
        Z(p,q)=Z(p,q)+1;
    end
end
num_pixel = rows * cols;
xik = zeros(num_pixel, K);
[C I] = max(Z);
for k = 1:K
    mk = I(k)-1;
    [r c] = find(truthImg == mk);
    idx = (r-1)*cols + c;
    xik(idx,k) = 1;
end