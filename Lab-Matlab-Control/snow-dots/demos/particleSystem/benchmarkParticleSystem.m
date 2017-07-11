% Measure rendering times for CPU vs GPU particle system rendering.
%
% @ingroup dotsDemos
function benchmarkParticleSystem()


nParticles = round(linspace(1e2, 5e4, 10));
nFrames = 100;
openArg = -1;

nConditions = numel(nParticles);
updateCPU = zeros(nConditions, nFrames);
updateGPU = zeros(nConditions, nFrames);
drawCPU = zeros(nConditions, nFrames);
drawGPU = zeros(nConditions, nFrames);
renderCPU = zeros(nConditions, nFrames);
renderGPU = zeros(nConditions, nFrames);
for ii = 1:nConditions
    data = demoParticleSystem(nParticles(ii), nFrames, openArg);
    updateCPU(ii,:) = data.updateTimeCPU;
    updateGPU(ii,:) = data.updateTimeGPU;
    drawCPU(ii,:) = data.drawTimeCPU;
    drawGPU(ii,:) = data.drawTimeGPU;
    renderCPU(ii,:) = data.renderTimeCPU;
    renderGPU(ii,:) = data.renderTimeGPU;
end

%%
close all
f = figure();
ax = axes( ...
    'Parent', f, ...
    'XLim', [nParticles(1)-1, nParticles(end)+1], ...
    'XTick', nParticles, ...
    'XTickLabel', nParticles);
xlabel(ax, 'nParticles')
ylabel(ax, sprintf('median of %d times (s)', nFrames))
line(nParticles, median(renderCPU, 2), ...
    'Parent', ax, ...
    'Marker', 'v', ...
    'LineStyle', 'none', ...
    'Color', [0 0 1]);
line(nParticles, median(drawCPU, 2), ...
    'Parent', ax, ...
    'Marker', '.', ...
    'LineStyle', 'none', ...
    'Color', [0 0 1]);
line(nParticles, median(updateCPU, 2), ...
    'Parent', ax, ...
    'Marker', '^', ...
    'LineStyle', 'none', ...
    'Color', [0 0 1]);
line(nParticles, median(renderGPU, 2), ...
    'Parent', ax, ...
    'Marker', 'v', ...
    'LineStyle', 'none', ...
    'Color', [0 1 0]);
line(nParticles, median(drawGPU, 2), ...
    'Parent', ax, ...
    'Marker', '.', ...
    'LineStyle', 'none', ...
    'Color', [0 1 0]);
line(nParticles, median(updateGPU, 2), ...
    'Parent', ax, ...
    'Marker', '^', ...
    'LineStyle', 'none', ...
    'Color', [0 1 0]);
legend(ax, 'CPU render', 'CPU draw', 'CPU update', ...
    'GPU render', 'GPU draw', 'GPU update', ...
    'Location', 'northwest')