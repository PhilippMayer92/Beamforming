% heatmap for 2D beamforming
clear;

dx = 0.5;
x_min = -20;
x_max = 120;

dy = 0.5;
y_min = -20;
y_max = 120;

dt = 0.1;
t_min = 0;
t_max = 2*pi;

[x, y] = meshgrid(x_min:dx:x_max,y_min:dy:y_max);
lambda = 2*pi;

x_target = 50;
y_target = 50;
x_sources = [0 25 39 64 78 99];
y_sources = [45 12 78 64 91 8];
nr_sources = size(x_sources, 2);
distance = sqrt((x_target-x_sources).^2+(y_target-y_sources).^2);
phaseshift = distance-floor(distance/lambda)*lambda;

minimum = zeros(size(x, 1), size(y, 1));
maximum = zeros(size(x, 1), size(y, 1));
for t = t_min:dt:t_max+dt
    all = 0;
    for i = 1:nr_sources
        positions = sqrt((x-x_sources(i)).^2+(y-y_sources(i)).^2);
        part = sin(positions-t-phaseshift(i));
        all = all+part;
    end
    
    if t == 1
        minimum = all;
        maximum = all;
    else
        minimum = getMinMatrix(minimum, all);
        maximum = getMaxMatrix(maximum, all);
    end
end

amp = maximum-minimum;

hold on
surf(x, y, amp);
plot3([x_target x_target], [y_target y_target], [0 2*nr_sources+1], 'r');
axis([x_min x_max y_min y_max 0 2*nr_sources+1]);
hold off

k_x = (x_target-x_min)/dx+1;
k_y = (y_target-y_min)/dy+1;
amp_target = amp(k_x, k_y);
sprintf('Amplitude %f at target point (%d, %d)', amp_target, x_target, y_target)


function y = getMinMatrix(x1, x2)
    y = zeros(size(x1));
    
    for i = 1:size(x1, 1)
        for j = 1:size(x1, 2)
           y(i, j) = min(x1(i, j), x2(i, j)); 
        end
    end
end

function y = getMaxMatrix(x1, x2)
    y = zeros(size(x1));
    
    for i = 1:size(x1, 1)
        for j = 1:size(x1, 2)
           y(i, j) = max(x1(i, j), x2(i, j)); 
        end
    end
end