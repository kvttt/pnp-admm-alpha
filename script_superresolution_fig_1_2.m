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

%optional parameters
opts.rho     = 1e-3;
opts.max_itr = 50;
opts.tol     = 0;
opts.print   = true;

%main routine
% Baseline 1: fixed rho schedule
opts.gamma   = 1.0;
[out_1f, history_1f] = PlugPlayADMM_super_log_output(y,h,K,lambda,method,opts,z);
% Baseline 2: monotone rho schedule
opts.gamma   = 1.1;
[out_2m, history_2m] = PlugPlayADMM_super_log_output(y,h,K,lambda,method,opts,z);
% Proposed: alpha schedule
opts.gamma   = 1.005;
[out_3a, history_3a] = PlugPlayADMM_super_alpha_log_output(y,h,K,lambda,method,opts,z);

%display
fig = figure('Position', [0, 0, 4000, 1600]);
t = tiledlayout(2, 5, 'TileSpacing','tight');
nexttile(1);
imshow(z, [0 1]);
nexttile(2);
imshow(imresize(y,K,'nearest'), [0 1]);
nexttile(3);
imshow(out_1f, [0 1]);
nexttile(4);
imshow(out_2m, [0 1]);
nexttile(5);
imshow(out_3a, [0 1]);
nexttile(7);
imshow(imresize(y,K,'nearest') - z, [-0.5 0.5]);
nexttile(8);
imshow(out_1f - z, [-0.5 0.5]);
nexttile(9);
imshow(out_2m - z, [-0.5 0.5]);
nexttile(10);
imshow(out_3a - z, [-0.5 0.5]);
exportgraphics(fig, 'fig_1.pdf');

fig = figure;
plot(1:opts.max_itr, history_1f, '-o'); hold on;
plot(1:opts.max_itr, history_2m, '-s'); hold on;
plot(1:opts.max_itr, history_3a, '-d'); hold on;
legend('Fixed \rho schedule', 'Monotone \rho schedule', 'Proposed \alpha schedule', 'Location', 'southeast');
xlabel('Iteration number, k');
ylabel('PSNR (dB)');
grid on;
exportgraphics(fig, 'fig_2.pdf');
