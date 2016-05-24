% Mo_water_enc_psnr.m version V22

% This function implement the algorithmn of embedding the watermark to the
% image and evaluate the PSNR measure.

% Feb 1, 2014
% Written by Hieu V. Dang

function [psnr, grnn_weight,watermarked_image] = Mo_water_enc_psnr(chromosome,I,Wbits,V,MNW,posi_key)

% Convert RGB to YCbCr
YCbCr = rgb2ycbcr(I);
Y = double(YCbCr(:,:,1));
Y = double(Y);

% Wavelet decomposition, DB-4 4 levels
[C,S,HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1,DT0,A1] = wave_transform(Y,4);
%clear C,S;
% Segment wavelet coefficients into 3-by-3 blocks
%% Segment Wavelet Subbands HL4,LH4,HH4,HL3,LH3,HH3,HL2,LH2,HH2,HL1,LH1 into 3x3 non-overlapping blocks
block = block_segment(HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1);

%% Embedding process
  
target = []; x1=[];x2=[];x3=[];x4=[];x5=[];x6=[];x7=[];x8=[];
  for i=1:MNW
      W_block(:,:,i) = block(:,:,posi_key(i));
      target = [target W_block(2,2,i)];
      x1 = [x1 W_block(1,1,i)];
      x2 = [x2 W_block(1,2,i)];
      x3 = [x3 W_block(1,3,i)];
      x4 = [x4 W_block(2,1,i)];
      x5 = [x5 W_block(2,3,i)];
      x6 = [x6 W_block(3,1,i)];
      x7 = [x7 W_block(3,2,i)];
      x8 = [x8 W_block(3,3,i)];
  end
  % form the imput vector to PNN
  sigma = chromosome(1);
  
  inputs = [x1;x2;x3;x4;x5;x6;x7;x8];
  P=inputs'; 
  T = target;
  [Out,grnn_weight,error_sqr] = grnn(P,T,sigma);
  ac = Out;  
  clear error_sqr; 
  
  % Embedding
  water_factor = chromosome(2:V);
  
    
  %embeded_blocks = block;
  % compare and embedd
 
  for i=1:MNW
      if Wbits(i)==1
         block(2,2,posi_key(i)) = ac(i) + water_factor(i);
      else
         block(2,2,posi_key(i)) = ac(i) - water_factor(i);
      end
  end
  
%% Image Reconstruction
w_image = wave_reconstruct(block,C,S,HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1,DT0,A1);
Y = uint8(w_image);
YCbCr(:,:,1) = Y;
RGB = ycbcr2rgb(YCbCr);
watermarked_image = RGB;

Err = watermarked_image - I;
MSE = std2(Err);
psnr = 20*log10(255/MSE);
  
  