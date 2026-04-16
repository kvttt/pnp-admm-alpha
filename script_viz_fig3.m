load('fig3_results.mat');

fig = figure;
semilogx(rhos, history_1f(end,:), '-o'); hold on;
semilogx(rhos, history_2m(end,:), '-s'); hold on;
semilogx(rhos, history_3a(end,:), '-d'); hold on;
legend('Fixed \rho schedule', 'Monotone \rho schedule', 'Proposed \alpha schedule', 'Location', 'southeast');
xlabel('\rho_0');
ylabel('PSNR (dB)');
grid on;
exportgraphics(fig, 'fig_3.pdf');
