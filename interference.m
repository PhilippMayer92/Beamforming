% test for interference

x = -20:0.1:120;
lambda = 2*pi;

for t = 0:0.1:10
    f = sin(abs(x)-t-(30-4*lambda));        % origin at 0
    g = sin(abs(x-100)-t-(70-11*lambda));   % origin at 100
    h = sin(abs(x-20)-t-(10-lambda));       % origin at 20
    k = sin(abs(x-50)-t-(20-3*lambda));     % origin at 50
    gesamt = f+g+h+k;
    plot(x, f);
    hold on
    plot(x, g);
    plot(x, h);
    plot(x, k);
    plot(x, gesamt);
    plot([30 30], [-4 4]);
    hold off
    
    axis([-20 120 -4 4]);
    
    pause on;
    pause(1);
    pause off;
end