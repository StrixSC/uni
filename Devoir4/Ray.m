classdef Ray 
    methods
        function ray = Ray(origin, direction, nint, next)
            ray.origin = origin;
            ray.direction = direction;
            ray.critical_angle = asin(next/nint);
        end
        % Requires the intersection point computed using the infinite plane method
        function collision_point = compute_collision_point(ray, t)
            collision_point = ray.origin + (t * ray.direction);
        end

        function new_ray = compute_new_ray(ray, intersection_point, normal_v, n1, n2, is_reflexion)
            j = cross(ray.direction, normal_v)/norm(cross(ray.direction, normal_v));
            k = cross(normal_v, j)/norm(cross(normal_v, j));
            si = dot(k, ray.direction);
            incident_angle = asin(si);
            if (is_reflexion)
                new_direction = normal_v * sqrt(1 - (si * si)) + k*si;
            else
                st = (n1/n2)*si;
                new_direction = -normal_v * sqrt(1 - (st * st)) + k*st;
            end
            new_direction_unit = new_direction/norm(new_direction);
            new_ray = Ray(intersection_point, new_direction_unit, n1, n2);
        end
    end
    properties
        origin = 0; % p0 (observer)
        direction = 0; % u 
        critical_angle = 0;
    end
end