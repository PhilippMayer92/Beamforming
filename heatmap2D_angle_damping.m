% heatmap for 2D beamforming
% basic assumptions:
%   waves spread assymmetric to its source
%   there is no range damping
clear;
warning('off', 'MATLAB:singularMatrix');

% space and time parameters
dx = 0.2;
x_min = 0;
x_max = 50;

dy = 0.2;
y_min = 0;
y_max = 50;

dt = 0.05;
t_min = 0;
t_max = 2*pi;

[x, y] = meshgrid(x_min:dx:x_max,y_min:dy:y_max);
lambda = 2*pi;

% target coordinates
x_target = 25;
y_target = 25;
% coordinates of the wave sources
x_sources = [10 10 40 40 25 25 10 40];
y_sources = [10 40 10 40 10 40 25 25];
nr_sources = size(x_sources, 2);

% compute distance between target and each source thereby the
% necessary phaseshift for each source to get an interference maximum
% at the target
distance = sqrt((x_target-x_sources).^2+(y_target-y_sources).^2);
phaseshift = distance-floor(distance/lambda)*lambda;

% compute angle between connection from source to target and the
% x-axis
phi = zeros(nr_sources, 1);
for i = 1:nr_sources
    phi(i) = computeAngle(x_sources(i), y_sources(i), x_target, y_target);
end

minimum = zeros(size(x, 1), size(y, 1));
maximum = zeros(size(x, 1), size(y, 1));
for t = t_min:dt:t_max+dt
    all = 0;
    % compute wave for each source and overlay
    for i = 1:nr_sources
        % compute distance relative to wave source
        positions = sqrt((x-x_sources(i)).^2+(y-y_sources(i)).^2);
        % compute angle relativ to wave source
        psi = computeAngle(x_sources(i), y_sources(i), x, y);
        % compute angle gain
        gain = angleDamping(psi, phi(i));
        
        % compute actual wave
        part = sin(positions-t-phaseshift(i)).*gain;
        all = all+part;
    end
    
    % check for each point, whether the overlay reaches a new min/max
    if t == t_min
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
% print heatmap
surf(x, y, amp);
%print target marker
plot3([x_target x_target], [y_target y_target], [0 2*nr_sources+1], 'r');
% print source marker
for i = 1:nr_sources
    plot3([x_sources(i) x_sources(i)], [y_sources(i) y_sources(i)], ...
        [0 2*nr_sources+1], 'g');
end
axis([x_min x_max y_min y_max 0 2*nr_sources+1]);
xlabel('x');
ylabel('y');
hold off

% find amplitude at target point
k_x = (x_target-x_min)/dx+1;
k_y = (y_target-y_min)/dy+1;
amp_target = amp(k_x, k_y);
sprintf('Amplitude %f at target point (%d, %d)', amp_target, x_target, y_target)

warning('on', 'MATLAB:singularMatrix');

% find minimum for each position
function y = getMinMatrix(x1, x2)
    y = zeros(size(x1));
    
    for i = 1:size(x1, 1)
        for j = 1:size(x1, 2)
           y(i, j) = min(x1(i, j), x2(i, j)); 
        end
    end
end

% find maximum for each position
function y = getMaxMatrix(x1, x2)
    y = zeros(size(x1));
    
    for i = 1:size(x1, 1)
        for j = 1:size(x1, 2)
           y(i, j) = max(x1(i, j), x2(i, j)); 
        end
    end
end

% compute angle between x-axis and line segment from source to target
% in the range from -pi to pi for each point of the target matrix
function phi = computeAngle(x_source, y_source, x_target, y_target)
    s = size(x_target);

    phi = zeros(s);
    for i = 1:s(1)
        for j = 1:s(2)
            delta_x = x_target(i, j)-x_source;
            delta_y = y_target(i, j)-y_source;

            phi(i, j) = atan(delta_y/delta_x);

            if delta_x <0
                if delta_y < 0
                    phi(i, j) = phi(i, j)-pi;
                else
                    phi(i, j) = pi+phi(i, j);
                end
            end
        end
    end
end

% calculate the damping of the signal for each point depending on its
% angle relativ to the signal source and the target
% for all points in target direction phi +- pi/2 the gain is calulated
% as (1+cos(2*w))/2 with w = psi-phi
% otherwise the gain is zero
function gain = angleDamping(psi, phi)
    piH = pi/2;
    s = size(psi);
    
    gain = zeros(s);
    
    for i = 1:s(1)
        for j = 1:s(2)
            if (phi <= piH) && (phi >= -piH)
                if (psi(i, j) <= phi+piH) && (psi(i, j) >= phi-piH)
                    gain(i, j) = (1+cos(2*(psi(i, j)-phi)))/2;
                end
            elseif phi > piH
                if (psi(i, j) >= phi-piH) || (psi(i, j) <= -(2*pi-piH-phi))
                    gain(i, j) = (1+cos(2*(psi(i, j)-phi)))/2;
                end
            else
                if (psi(i, j) <= phi+piH) || (psi(i, j) >= (2*pi-pi/2-phi))
                    gain(i, j) = (1+cos(2*(psi(i, j)-phi)))/2;
                end
            end
        end
    end
end