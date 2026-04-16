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
rhos   = logspace(-5, -2, 7);

%optional parameters
% opts.max_itr = 50;
% opts.tol     = 0;
% opts.print   = true;

%initialize trackers
history_1f = zeros(50, length(rhos));
history_2m = zeros(50, length(rhos));
history_3a = zeros(50, length(rhos));

%main routine
parfor i = 1:length(rhos)
    rho_i = rhos(i);

    % Baseline 1: fixed rho schedule
    [~, history_1f(:,i)] = PlugPlayADMM_super_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho_i,'gamma',1.0), ...
        z);

    % Baseline 2: monotone rho schedule
    [~, history_2m(:,i)] = PlugPlayADMM_super_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho_i,'gamma',1.1), ...
        z);

    % Proposed: alpha schedule
    [~, history_3a(:,i)] = PlugPlayADMM_super_alpha_log_output( ...
        y, h, K, lambda, method, ...
        struct('max_itr',50,'tol',0,'print',true,'rho',rho_i,'gamma',1.005), ...
        z);
end

save('fig3_results.mat', 'history_1f', 'history_2m', 'history_3a', 'rhos');

fig = figure;
semilogx(rhos, history_1f(end,:), '-o'); hold on;
semilogx(rhos, history_2m(end,:), '-s'); hold on;
semilogx(rhos, history_3a(end,:), '-d'); hold on;
legend('Fixed \rho schedule', 'Monotone \rho schedule', 'Proposed \alpha schedule', 'Location', 'southeast');
xlabel('\rho_0');
ylabel('PSNR (dB)');
grid on;
exportgraphics(fig, 'fig_3.png', 'Resolution', 600);
