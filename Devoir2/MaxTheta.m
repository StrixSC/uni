%{
    Utility script allowing us to compute several trajectories into the same table and increment the theta used
    for the computation each time. This is the script that was used to generate the information in Table 2 of
    the report.
%}
function [best] = MaxTheta()
    clear;
    RT=6.371e6;
    angle=0:0.002:2*pi;
    xTerre=RT*cos(angle);
    yTerre=RT*sin(angle);
    fill(xTerre,yTerre,'b');
    axis equal;
        hold;
        xlabel('y(m)');
        ylabel('z(m)');
    
    theta = 0.000001;
    max_theta = 0;
    while (theta <= 2*pi);
        printf("Testing with theta = %f\n", theta);
        [Vf t x y z] = Devoir2(theta);
        d = x(end)^2 + y(end)^2 + z(end)^2;
        if (d >= 10^14)
            max_theta = theta;
        end
        sz=size(t,1);
        plot(y,z,'r')
        fprintf('Angle theta          %10.9f rad \n',theta);
        fprintf('Temps final          %10.6f s \n',t(sz));
        fprintf('Vitesse finale          %10.6f m/s \n',Vf);
        fprintf('Position finale        ( %10.0f   , %10.0f   ,%10.0f )m \n',x(sz),y(sz),z(sz));
        theta = theta + 0.000001;
    end
    best = max_theta;
end
