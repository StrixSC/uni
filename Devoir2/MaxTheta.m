function [best] = MaxTheta()
    theta = 0;
    max_theta = 0;
    while (theta <= 2*pi);
        printf("Testing with theta = %f\n", theta);
        [Vf t x y z] = Devoir2(theta);
        d = x(end)^2 + y(end)^2 + z(end)^2;
        if (d >= 10^14)
            max_theta = theta;
        end
        theta = theta + 0.01;
    end
    best = max_theta;
end
