close all; clear; clc;
addpath(genpath('PlugPlay_v1'));

%read test image
fns = dir('PlugPlay_v1/data/*.png');

%initialize trackers
history_1f = zeros(length(fns), 1);
history_2m = zeros(length(fns), 1);
history_3a = zeros(length(fns), 1);

%parameters
method = 'BM3D';
lambda = 0.001;

%main routine
parfor i = 1:length(fns)
    %read test image
    z = im2double(imread(fns(i).name));

    %blur kernel and downsampling factor
    h = fspecial('gaussian',[9 9],1);
    K = 4;
    noise_level = 5/255;
    rng(0)
    %calculate the observed image
    y = imfilter(z,h,'circular');
    y = downsample2(y,K);
    y = y + noise_level*randn(size(y));

    % Baseline 1: fixed rho schedule
    [~, history_1f(i,1)] = PlugPlayADMM_super_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho_i,'gamma',1.0), ...
        z);

    % Baseline 2: monotone rho schedule
    [~, history_2m(i,1)] = PlugPlayADMM_super_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho_i,'gamma',1.1), ...
        z);

    % Proposed: alpha schedule
    [~, history_3a(i,1)] = PlugPlayADMM_super_alpha_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho_i,'gamma',1.005), ...
        z);
end

save('fig4_results.mat', 'history_1f', 'history_2m', 'history_3a');

