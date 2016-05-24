%wave_transform.m

% This function implement wavelet tranformation in 4 level

% Written by Hieu  V. Dang



function [C,S,HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1,DT0,A1] = wave_transform(I,nlevel)

[C,S] = wavedec2(I,nlevel,'sym2');
NC = size(C,2);

%Form matrix A1
A1 = zeros(S(1));
k=0;
for i=1:S(1)
    for j=1:S(1)
        A1(j,i) = C(k+j);
    end
    k = k+S(1);
end

%Form matrices H,V,D
k1=k;
for ilevel = 2:nlevel+1
    %Form matrices H
    for i=1:S(ilevel)
        for j=1:S(ilevel)
            H1(j,i) = C(k1+j);
        end
        k1=k1+j;
    end
    H{ilevel-1} = H1;
    
    %Form matrices V
    k2 = k1;
    for i=1:S(ilevel)
        for j=1:S(ilevel)
            V1(j,i) = C(k2+j);
        end
        k2 = k2+j;
    end
    V{ilevel-1} = V1;
    
    %Form matrix D
    k3 = k2;
    for i=1:S(ilevel)
        for j=1:S(ilevel)
            D1(j,i) = C(k3+j);
        end
        k3 = k3+j;
    end
    k1=k3;
    D{ilevel-1} = D1;
end

HT3 = H{1}; HT2 = H{2}; HT1 = H{3}; HT0 = H{4};
VT3 = V{1}; VT2 = V{2}; VT1 = V{3}; VT0 = V{4};
DT3 = D{1}; DT2 = D{2}; DT1 = D{3}; DT0 = D{4};

%% Display wavelet decomposition in tree

%cod_cA = wcodemat(A1,255);
%for i=1:nlevel-2
 %   cod_cH{i} = wcodemat(H{i},750,'mat',1);
  %  cod_cV{i} = wcodemat(V{i},750,'mat',1);
   % cod_cD{i} = wcodemat(D{i},750,'mat',1);
%end

% Decode mat for nlevel-1
%cod_cH{nlevel-1}= wcodemat(H{nlevel-1},550,'mat',1);
%cod_cV{nlevel-1} = wcodemat(V{nlevel-1},550,'mat',1);
%cod_cD{nlevel-1} = wcodemat(D{nlevel-1},550,'mat',1);

%Decode mat for nlevel
%cod_cH{nlevel} = wcodemat(H{nlevel},350,'mat',1);
%cod_cV{nlevel} = wcodemat(V{nlevel},350,'mat',1);
%cod_cD{nlevel} = wcodemat(D{nlevel},350,'mat',1);

%image = cod_cA;
%for i=1:nlevel
 %   cod_cH{i} = cod_cH{i} + 150;
  %  cod_cV{i} = cod_cV{i} + 150;
   % cod_cD{i} = cod_cD{i} + 150;
    %image = cat(1,cat(2,image,cod_cH{i}),cat(2,cod_cV{i},cod_cD{i}));
%end

%figure(3), imshow(uint8(image));