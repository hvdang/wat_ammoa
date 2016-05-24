% grnn.m version 11

% Regression neural networks 

% Feb 01, 2014
% Written by Hieu V. Dang

function [Out weight error_sumsqr] = grnn(input,target,variance)

[M,N] = size(input);
[L,M] = size(target);

number_of_training_inputs=M; % number of vector in the inputs
number_of_points=N;         % dimension of input -> number of input neurons
number_of_hidden_unit = 8;  % number of pattern neurons
sigma = variance;

[data dS] = mapminmax(input);
[targetS TS] = mapminmax(target);
center = mean(data);

%S1=0;
%S2=0;
for i=1:number_of_training_inputs
   for j=1:number_of_hidden_unit
       for k=1:number_of_points
            d(k)=(data(i,k)-center(k))^2;
            dt(k) = (-d(k))/(2*sigma^2);
            ds1(k) = exp(dt(k));
            ds2(k) = ds1(k)*targetS(i);
        end
        S1(j) = sum(ds1);
        S2(j) = sum(ds2);
    end
    out(i) = S2/S1; % out put of the predictor
end
Out = mapminmax('reverse',out,TS);
weight = target;
% compute the error of the training
error = Out - target;
error_sumsqr = sumsqr(error)/number_of_training_inputs;
