% test 2D beamforming
clear;

[x, y] = meshgrid(-10:0.1:10,-10:0.1:10);
lambda = 2*pi;

x_target = -9;
y_target = -9;
x_sources = [0 5 -8];
y_sources = [0 -5 8];
nr_sources = size(x_sources, 2);
distance = sqrt((x_target-x_sources).^2+(y_target-y_sources).^2);
phaseshift = distance-floor(distance/lambda)*lambda;

for t = 0:0.1:10
    clf;
    
    all = 0;
    hold on
    for i = 1:nr_sources
        positions = sqrt((x-x_sources(i)).^2+(y-y_sources(i)).^2);
        part = sin(positions-t-phaseshift(i));
        all = all+part;
        %surf(x, y, part);
    end

    surf(x, y, all);
    plot3([x_target x_target], [y_target y_target], [-nr_sources nr_sources], 'r');
    axis([-10 10 -10 10 -nr_sources nr_sources]);
    view(3);
    hold off
    
    pause on;
    pause(1);
    pause off;
end