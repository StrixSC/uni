classdef Sphere
    methods
        function sphere = Sphere(center, radius)
            sphere.center = center;
            sphere.radius = radius;
        end

        function [distance, collision] = check_collision_with_ray2(sphere,ray)
            collision = -1;
            cx = sphere.center(1);
            cy = sphere.center(2);
            cz = sphere.center(3);
            x0 = ray.origin(1);
            y0 = ray.origin(2);
            z0 = ray.origin(3);
            dx = ray.direction(1) - ray.origin(1);
            dy = ray.direction(2) - ray.origin(2);
            dz = ray.direction(3) - ray.origin(3);

            a = dx*dx + dy*dy + dz*dz;
            b = 2*dx*(x0-cx)+2*dy*(y0-cy) + 2*dz*(z0-cz);
            c = cx*cx + cy*cy + cz*cz + x0 * x0 + y0*y0 + z0*z0 + -2*(cx*x0 + cy*y0 + cz*z0) - sphere.radius*sphere.radius;

            disc = (b^2) - (4*a*c);
            if (disc < 0)
                collision = -1;
                distance = 0;
            elseif (disc == 0)
                collision = 0;
                distance = 0;
            else
                collision = (-b - sqrt(b^2 - 4*a*c))/(2*a);
                intersection_point = ray.compute_collision_point(collision);
                distance = (intersection_point - ray.origin);
            end
        end

        function [distance, collision] = check_collision_with_ray3(sphere,ray)
            o_minus_c = ray.origin - sphere.center;
            pval = dot(ray.direction, o_minus_c);
            qval = dot(o_minus_c, o_minus_c) - (sphere.radius * sphere.radius);
            disc = (pval * pval) - qval;
            if (disc < 0)
                collision = -1;
                distance =0;
            end
            dRoot = sqrt(disc);
            tval1 = -pval - dRoot;
            tval2 = -pval + dRoot;
            if (tval2 < tval1)
                tval1 = tval2;
            end
            collision = tval2;
            dist_point = ray.compute_collision_point(tval1);
            distance = norm(dist_point - ray.origin);
        end

        function [distance, collision_point] = check_collision_with_ray(sphere,ray)
            collision_point = [0;0;0];
            a = dot(ray.direction, ray.direction);
            b = 2 * dot(ray.direction, ray.origin - sphere.center);
            c = dot(ray.origin - sphere.center, ray.origin - sphere.center) - (sphere.radius*sphere.radius);
            [solvable, t] = SolveQuadratic(a, b, c);
            if (solvable)
                collision_point = ray.compute_collision_point(t);
                distance = norm(collision_point - ray.origin);
            else
                distance = -1;
            end
        end

    end
    properties
        center = [];
        radius = 0;
    end
end