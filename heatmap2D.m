% heatmap for 2D beamforming
% basic assumptions:
%   waves spread symmetric to its source
%   there is no damping
clear;

% space and time parameters
dx = 0.5;
x_min = -20;
x_max = 120;

dy = 0.5;
y_min = -20;
y_max = 120;

dt = 0.05;
t_min = 0;
t_max = 2*pi;

[x, y] = meshgrid(x_min:dx:x_max,y_min:dy:y_max);
lambda = 2*pi;

% target coordinates
x_target = 50;
y_target = 50;
% coordinates of the wave sources
x_sources = [0 25 39 64 78 99 23 71 10 81];
y_sources = [45 12 78 64 91 8 11 49 51 23];
nr_sources = size(x_sources, 2);

% compute distance between target and each source thereby the
% necessary phaseshift for each source to get an interference maximum
% at the target
distance = sqrt((x_target-x_sources).^2+(y_target-y_sources).^2);
phaseshift = distance-floor(distance/lambda)*lambda;

minimum = zeros(size(x, 1), size(y, 1));
maximum = zeros(size(x, 1), size(y, 1));
for t = t_min:dt:t_max+dt
    all = 0;
    % compute each wave and overlay
    for i = 1:nr_sources
        % compute positions relative to wave source
        positions = sqrt((x-x_sources(i)).^2+(y-y_sources(i)).^2);
        part = sin(positions-t-phaseshift(i));
        all = all+part;
    end
    
    % check for each point, whether the overlay reaches a new min/max
    if t == 1
        minimum = all;
        maximum = all;
    else
        minimum = getMinMatrix(minimum, all);
        maximum = getMaxMatrix(maximum, all);
    end
end
% compute amplitude at each point
amp = maximum-minimum;

hold on
surf(x, y, amp);
plot3([x_target x_target], [y_target y_target], [0 2*nr_sources+1], 'r');
axis([x_min x_max y_min y_max 0 2*nr_sources+1]);
hold off

% find amplitude at target point
k_x = (x_target-x_min)/dx+1;
k_y = (y_target-y_min)/dy+1;
amp_target = amp(k_x, k_y);
sprintf('Amplitude %f at target point (%d, %d)', amp_target, x_target, y_target);