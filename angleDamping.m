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