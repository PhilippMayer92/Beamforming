% test for interference
clear;

x = -20:0.1:120;
lambda = 2*pi;

x_target = 88;
x_sources = [0 10 26 57 78 100];
nr_sources = size(x_sources, 2);
distance = abs(x_target-x_sources);
phaseshift = distance-floor(distance/lambda)*lambda;

for t = 0:0.1:10
    clf;
    
    all = 0;
    hold on
    for i = 1:nr_sources
        part = sin(abs(x-x_sources(i))-t-phaseshift(i));
        all = all+part;
        plot(x, part);
    end

    plot(x, all);
    plot([x_target x_target], [-nr_sources nr_sources]);
    axis([-20 120 -nr_sources nr_sources]);
    hold off
    
    pause on;
    pause(1);
    pause off;
end