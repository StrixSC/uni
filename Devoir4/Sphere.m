classdef Sphere
    methods
        function sphere = Sphere(center, radius)
            sphere.center = center;
            sphere.radius = radius;
        end

        function collision = check_collision_with_ray(sphere,ray)
            collision = -1;
            cx = sphere.center(1);
            cy = sphere.center(2);
            cz = sphere.center(3);
            P0 = ray.origin;
            P1 = ray.direction;
            dP = P1 - P0;
            x0 = P0(1);
            y0 = P0(2);
            z0 = P0(3);
            dx = dP(1);
            dy = dP(2);
            dz = dP(3);

            a = dx*dx + dy*dy + dz*dz;
            b = 2*dx*(x0-cx)+2*dy*(y0-cy) + 2*dz*(z0-cz);
            c = cx*cx + cy*cy + cz*cz + x0 * x0 + y0*y0 + z0*z0 + -2*(cx*x0 + cy*y0 + cz*z0) - sphere.radius*sphere.radius;

            discriminant = (b^2) - (4*a*c);
            if (discriminant < 0)
                collision = -1;
            elseif (discriminant == 0)
                collision = 0;
            else
                collision = (-b - sqrt(b^2 - 4*a*c))/(2*a);
            end
        end
    end
    properties
        center = [];
        radius = 0;
    end
end