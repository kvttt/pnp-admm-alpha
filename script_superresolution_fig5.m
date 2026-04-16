close all; clear; clc;
addpath(genpath('PlugPlay_v1'));

%read test image
z = im2double(imread('PlugPlay_v1/data/Barbara512.png'));

%blur kernel and downsampling factor
h = fspecial('gaussian',[9 9],1);
K = 4;
noise_level = 5/255;
rng(0)
%calculate the observed image
y = imfilter(z,h,'circular');
y = downsample2(y,K);
y = y + noise_level*randn(size(y));

%parameters
method = 'BM3D';
lambda = 0.001;
rhos = logspace(-5, 0, 11);
M_gammas = linspace(1, 2, 11);
A_gammas = linspace(1, 1.05, 11);

%initialize trackers
M = 11;
N = 11;
history_M = zeros(50, M*N);
history_A = zeros(50, M*N);

%main routine
parfor k = 1:(M*N)
    [m, n] = ind2sub([M, N], k);
    rho = rhos(m);
    M_gamma = M_gammas(n);
    A_gamma = A_gammas(n);
    [~, history_M(:,k)] = PlugPlayADMM_super_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho,'gamma',M_gamma), ...
        z);

    [~, history_A(:,k)] = PlugPlayADMM_super_alpha_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho,'gamma',A_gamma), ...
        z);
end

save('fig5_results.mat', 'history_M', 'history_A', 'rhos', 'M_gammas', 'A_gammas');
