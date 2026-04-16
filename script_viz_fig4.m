load('fig4_results.mat');

X = zeros(3, 14);
X(1,1:end-1) = history_1f(end,:);
X(2,1:end-1) = history_2m(end,:);
X(3,1:end-1) = history_3a(end,:);
X(1,end) = mean(history_1f(end,:));
X(2,end) = mean(history_2m(end,:));
X(3,end) = mean(history_3a(end,:));

T = array2table(X', 'VariableNames', {'Fixed_rho_schedule', 'Monotone_rho_schedule', 'Proposed_alpha_schedule'});
disp(T);

fig = figure;
boxplot(X', 'Labels', {'Fixed \rho schedule', 'Monotone \rho schedule', 'Proposed \alpha schedule'});
ylabel('PSNR (dB)');
grid on;
exportgraphics(fig, 'fig_4.pdf');

% fig = figure;
% semilogx(rhos, history_1f(end,:), '-o'); hold on;
% semilogx(rhos, history_2m(end,:), '-s'); hold on;
% semilogx(rhos, history_3a(end,:), '-d'); hold on;
% legend('Fixed \rho schedule', 'Monotone \rho schedule', 'Proposed \alpha schedule', 'Location', 'southeast');
% xlabel('\rho_0');
% ylabel('PSNR (dB)');
% grid on;
% exportgraphics(fig, 'fig_3.pdf');
