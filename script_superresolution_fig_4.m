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

save('fig4_results.mat', 'history_M', 'history_A', 'rhos', 'M_gammas', 'A_gammas');

% Visualization options
xtick_font_size = 6;
ytick_font_size = 6;
label_font_size = 6;
annotation_font_size = 6;
colorbar_tick_font_size = 6;

history_A = reshape(history_A, 50, 11, 11);
X_A = squeeze(history_A(end,:,:));
history_M = reshape(history_M, 50, 11, 11);
X_M = squeeze(history_M(end,:,:));
X_A_plot = X_A';
X_M_plot = X_M';

rho_labels = compose('%.1e', rhos(:));
A_gamma_labels = compose('%.3f', A_gammas(:));
M_gamma_labels = compose('%.3f', M_gammas(:));

% clim = [min(X_A(:)), max(X_M(:))];
clim = [23.10, 23.70];

figA = figure;
ax1 = axes(figA);
imagesc(ax1, X_A_plot);
axis(ax1, 'image');
colormap(ax1, parula);
caxis(ax1, clim);
cb1 = colorbar(ax1);
ylabel(cb1, 'PSNR (dB)', 'FontSize', label_font_size);
cb1.FontSize = colorbar_tick_font_size;
xlabel(ax1, '\rho', 'FontSize', label_font_size);
ylabel(ax1, '\gamma', 'FontSize', label_font_size);
set(ax1, 'XTick', 1:numel(rhos), 'XTickLabel', rho_labels, ...
    'YTick', 1:numel(A_gammas), 'YTickLabel', A_gamma_labels, 'XTickLabelRotation', 45);
ax1.XAxis.FontSize = xtick_font_size;
ax1.YAxis.FontSize = ytick_font_size;

for i = 1:size(X_A_plot, 1)
    for j = 1:size(X_A_plot, 2)
        if X_A_plot(i,j) > mean(clim)
            txt_color = 'k';
        else
            txt_color = 'w';
        end
        text(ax1, j, i, sprintf('%.2f', X_A_plot(i,j)), ...
            'HorizontalAlignment', 'center', 'Color', txt_color, 'FontSize', annotation_font_size);
    end
end

figM = figure;
ax2 = axes(figM);
imagesc(ax2, X_M_plot);
axis(ax2, 'image');
colormap(ax2, parula);
caxis(ax2, clim);
cb2 = colorbar(ax2);
ylabel(cb2, 'PSNR (dB)', 'FontSize', label_font_size);
cb2.FontSize = colorbar_tick_font_size;
xlabel(ax2, '\rho', 'FontSize', label_font_size);
ylabel(ax2, '\gamma', 'FontSize', label_font_size);
set(ax2, 'XTick', 1:numel(rhos), 'XTickLabel', rho_labels, ...
    'YTick', 1:numel(M_gammas), 'YTickLabel', M_gamma_labels, 'XTickLabelRotation', 45);
ax2.XAxis.FontSize = xtick_font_size;
ax2.YAxis.FontSize = ytick_font_size;

for i = 1:size(X_M_plot, 1)
    for j = 1:size(X_M_plot, 2)
        if X_M_plot(i,j) > mean(clim)
            txt_color = 'k';
        else
            txt_color = 'w';
        end
        text(ax2, j, i, sprintf('%.2f', X_M_plot(i,j)), ...
            'HorizontalAlignment', 'center', 'Color', txt_color, 'FontSize', annotation_font_size);
    end
end

exportgraphics(figA, 'fig_4_a.png', 'Resolution', 600);
exportgraphics(figM, 'fig_4_b.png', 'Resolution', 600);
