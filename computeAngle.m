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