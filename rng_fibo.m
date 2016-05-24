% rng_fibo.m

% This function implement the Fibonacci-p code algorithm to generate a
% number sequence.

% Written by Hieu V. Dang


function rng = rng_fibo(key1,key2)

% Create the P-Fibonacci sequence
p=key2;
i = key1;

f = zeros(1,40);

f(1) = 1;
f(2) = 2;
f(3) = 4;
f(4) = 5;
f(5) = 30;
f(6) = 40;
f(7) = 50;
f(8) = 51;
f(9) = 54;
f(10) = 61;
f(11) = 70;
for k = p+2:40
    f(k) = f(k-1) + f(k-p-1);
end

%p - Fibonacci sequence
for kk = 1:4096
    Tp(kk) = mod(kk*(f(29)+i),f(30));
end
rng = Tp;
