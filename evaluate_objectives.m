% evaluate_objectives.m version 22
% Feburary 01, 2014
% Written by Hieu V. Dang

function f = evaluate_objectives(chromosome,V,I,Wbits,NMW,posi_key)

% Objective function 1: PSNR
[psnr,grnn_weight,watermarked_image] = Mo_water_enc_psnr(chromosome,I,Wbits,V,NMW,posi_key);
f(1) = -psnr;

sigma = chromosome(1);
% Objective function 2: WAR for Gaussian attack
Wbits_1 = Mo_water_dec_gauss(watermarked_image,grnn_weight,sigma,posi_key);
WAR_G = 100*(sum(sum(Wbits_1.*Wbits))/sum(sum(Wbits.^2)));

% War for amplitude scaling attack
Wbits_2 = Mo_water_dec_amp(watermarked_image,grnn_weight,sigma,posi_key);
WAR_A = 100*(sum(sum(Wbits_2.*Wbits))/sum(sum(Wbits.^2)));

% WAR for cropping attack
%Wbits_3 = Mo_water_dec_crop_v21(watermarked_image,grnn_weight,sigma,posi_key);
%WAR3 = 100*(sum(sum(Wbits_3.*Wbits))/sum(sum(Wbits.^2)));

%Objective function: Jpeg compression
%imwrite(watermarked_image,'lena_watermarked_q20.jpg','jpg','Quality',20);
%imwrite(watermarked_image,'lena_watermarked_q20.jpg','jpg','Quality',20);

%I_jpg = imread('lena_watermarked_q20.jpg');
%Wbits_3 = Mo_water_dec_jpg(I_jpg,grnn_weight,sigma,posi_key);
%WAR_J = 100*(sum(sum(Wbits_3.*Wbits))/sum(sum(Wbits.^2)));

% Objective function 5: WAR for median filtering attack
Wbits_4 = Mo_water_dec_mf(watermarked_image,grnn_weight,sigma,posi_key);
WAR_MF = 100*(sum(sum(Wbits_4.*Wbits))/sum(sum(Wbits.^2)));

% Objective funtion 2
f(2) = -(WAR_G+WAR_A+WAR_MF)/3;




