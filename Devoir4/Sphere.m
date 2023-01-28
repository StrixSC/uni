classdef Sphere

    methods

        function sphere = Sphere(center, radius)
            sphere.center = center;
            sphere.radius = radius;
        end

        function [distance, collision_point] = check_collision_with_ray(sphere, ray)
            distance = -1;
            collision_point = [0;0;0];
            ray_start_to_sphere_center = sphere.center - ray.origin;
            a = dot(ray.direction, ray.direction);
            b = 2 * dot(ray_start_to_sphere_center, ray.direction);
            c = dot(ray_start_to_sphere_center, ray_start_to_sphere_center) - (sphere.radius^2);
            d = (b^2) - (4*a*c);
            if (d >= 0)
                t0 = -(1/2*a) * (-1 * b - (d^0.5));
                if (t0 > 0)                    
                    collision_point = ray.compute_collision_point(t0);
                    distance = norm(collision_point - ray.origin);
                end
            end
        end
    end

    properties
        center = [];
        radius = 0;
    end
   
end
