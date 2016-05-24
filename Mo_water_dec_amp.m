% Mo_water_dec_amp.m version 22

% This function implement amplitude scaling attack to the watermarked imagethen extract the
% watermark from the attacked watermarked image for WAR evaluation

% Feb 01, 2014
% Written by Hieu V. Dang

function Wbits_2 = Mo_water_dec_amp(watermarked_image,grnn_weight,sigma,hvs_kw)

I = watermarked_image;
%[m,n,k] = size(I);
I = double(I);
% Amplitude scaling attack
I = I/0.3;

% Convert RGB to YCbCr
YCbCr = rgb2ycbcr(I);
Y = YCbCr(:,:,1);

% Wavelet decomposition
[C,S,HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1,DT0,A1] = wave_transform(Y,4);
clear C; clear S; clear DT0;

%% Segment Wavelet Subbands HL4,LH4,HH4,HL3,LH3,HH3,HL2,LH2,HH2,HL1,LH1 into 3x3 non-overlapping blocks
block = block_segment(HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1);

%% Extraction

x1=[];x2=[];x3=[];x4=[];x5=[];x6=[];x7=[];x8=[];
for i=1:64*64
      W_block(:,:,i) = block(:,:,hvs_kw(i));
      %target = [target W_block(2,2,i)];
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
  inputs = [x1;x2;x3;x4;x5;x6;x7;x8];
  P=inputs'; 
  [Out, ~, ~] = grnn(P,grnn_weight,sigma);
  ac = Out;
  %clear weight; clear error;
  
  % Compare and extracting
  for i=1:64*64
      if block(2,2,hvs_kw(i)) >= ac(i)
         Wbits_2(i) = 1;
      elseif block(2,2,hvs_kw(i)) < ac(i) 
         Wbits_2(i) = 0;
      end
  end