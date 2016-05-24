% amoma_wat_main_run.m
% This program for optimal watermarking using AMOMA

% August 22, 2014
% Written by Hieu V. Dang

close all
clear all
clc

tic

%% Read the input image and watermark

I = imread('lena_color_512.tiff');
%I = imread('baboon_color_512.tiff');
%I = imread('airplane_F16_color_512.tiff');
%I = imread('house_color_512.tiff');
[M,N,K] = size(I);
%figure(1), imshow(I); title('Original Image');
YCbCr = rgb2ycbcr(I);
Y = YCbCr(:,:,1);
Y = double(Y);

%Read the watermark image
WM = imread('winnipeg64.tif');
[Mw,Nw] = size(WM); MNW = Mw*Nw;
Wm_b = ~im2bw(WM,0.6);
%figure(2), imshow(Wm_b);

% Scan the watermark bits to a sequence
iw = 0;
for i=1:Mw
    for j=1:Nw
        iw=iw+1;
        Wbits(iw) = Wm_b(i,j);
    end
end

%% 4-level Wavelet Decomposition 

nlevel = 4;
[C,S,HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1,DT0,A1] = wave_transform(Y,nlevel);

%% Segment Wavelet Subbands HL4,LH4,HH4,HL3,LH3,HH3,HL2,LH2,HH2,HL1,LH1 into 3x3 non-overlapping blocks
block = block_segment(HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1);

%% Generate the random numbers for embedding positions  
posi_key = rng_fibo(1,4);

%% Parameters for AMOMA
% population size
Npop = 100;
% number of generation
maxIters =200;
% number of objectives
Nfun = 2;
% number of decision variables
Nvar = 4097;
K = Nvar + Nfun;

pool = Npop;%round(pop/2); % size of mating pool
tour = 30; % tournament size.

% distribution indices for crossover and mutation operators 
mu = 20;
mum = 20;

%tabu_loop = gen/2; % the number of loof of local search

% The min and max values for each decision variable
min_range(1) = 0.1;
max_range(1) = 3;
for i=2:Nvar
    rnd = rand(1);
    min_range(i) = 4+ 2*rnd;   
    max_range(i) = 46 + 2*rnd;
end

%% Intitialize the population
% population is initialized with random values which are within the specified range

population = initialize_variables(Npop,Nvar,Nfun,min_range,max_range,I,Wbits,MNW,posi_key);

%% Find the pareto ranks and crowding distance
population = pareto_rank(population,Nvar,Nfun);
% Crowding distance
population = crowd_distance(population,Nvar,Nfun);

%% Compute the Renyi entropy

population = RRSE(population,Nvar,Nfun);



%% Start the Evolutionary process
population_array = cell(1,maxIters);
Pt=1; % probability for select parent population

IQ = zeros(1,maxIters);
IQ0=IQ;
t0 = 5;

for i=1:maxIters
    % Select paretns for reproduction
    parent_population = Selection(population,pool,tour,Pt);
    
    % perform crossover and mutaiton
     offspring_population = realcrossover(parent_population,Nfun,Nvar,mu,min_range,max_range,I,Wbits,MNW,posi_key);
  
     offspring_population = realmutation(offspring_population,Nfun,Nvar,mum,min_range,max_range,I,Wbits,MNW,posi_key);
     N_offs = size(offspring_population,1);
     
     % Combine and update populations
     inter0_population(1:Npop,1:K) = population(:,1:K);
     inter0_population(Npop+1:Npop+N_offs,1:K) = offspring_population(:,1:K);
     inter0_population = pareto_rank(inter0_population,Nvar,Nfun);
     inter0_population = crowd_distance(inter0_population,Nvar,Nfun);
     population0 = replace_population(inter0_population,Nvar,Nfun,Npop);
     population0 = RRSE(population0,Nvar,Nfun);
     Npop0 = size(population0,1);
     
     % Doing clustering for local search
     [CLuster,IQ(i)] = clustering(population0,K,10,100,0.000000001);
     
     if i > t0
        temp=0;
        for j=i-t0:i-1
            temp = temp + IQ(j)/(2*(i-j));
        end
        IQ0(i) = temp/(t0);
     end
    
     if IQ(i) >= IQ0(i)
         % Perform Tabu local search stage 1
         improved_population = tabu_search_stage1(CLuster,Nvar,Nfun,min_range,max_range,I,Wbits,MNW,posi_key);
         N_impr = size(improved_population,1);
         
         % Intermediate population
         inter_population(1:Npop0,1:K) = population0(:,1:K);
         inter_population(Npop0+1:Npop0+N_impr,1:K) = improved_population;
         Ninter = size(inter_population,1);
         
         % Pareto ranks & Crowding distance
         inter_population = pareto_rank(inter_population,Nvar,Nfun);
         inter_population = crowd_distance(inter_population,Nvar,Nfun);
     
         % Chromosomes replacement 
         population1 = replace_population(inter_population,Nvar,Nfun,Npop);
         
         % local search stage 2 
         impr_pop1 = tabu_search_stage2(population1,Nvar,Nfun,min_range,max_range,I,Wbits,MNW,posi_key); 
         Nimpr1 = size(impr_pop1,1);
         
         % inter pop 
         inter_pop1(1:Npop,1:K) = population1(:,1:K); 
         inter_pop1(Npop+1:Npop+Nimpr1,1:K) = impr_pop1(:,1:K);
         
         % Pareto ranks and crowdistance
         inter_pop1 = pareto_rank(inter_pop1,Nvar,Nfun);
         inter_pop1 = crowd_distance(inter_pop1,Nvar,Nfun);
         
         % Replacement
         population = replace_population(inter_pop1,Nvar,Nfun,Npop);
         
         % compute RRSE values 
         population = RRSE(population,Nvar,Nfun);
     else
         Pt=Pt-0.05
     end
     population_array{i} = population;
end
    
   savefile = 'pop100_150Iter.mat';
   save(savefile,'population_array');


toc
