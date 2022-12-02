classdef Ray 
    methods
        function ray = Ray(origin, direction)
            ray.origin = origin;
            ray.direction = direction;
        end
        % Requires the intersection point computed using the infinite plane method
        function collision_point = compute_collision_point(ray, t)
            collision_point = ray.origin + (t * ray.direction);
        end

        function [new_is_inside_sphere, new_ray] = compute_new_ray(ray, intersection_point, normal_v, nint, next, critical_angle, is_inside_sphere)
            j = cross(ray.direction, normal_v)/norm(cross(ray.direction, normal_v));
            k = cross(normal_v, j)/norm(cross(normal_v, j));
            si = dot(ray.direction, k);
            incident_angle = asin(si);

            c1 = (nint > next);
            c2 = (incident_angle > critical_angle);
            c3 = (incident_angle < (-1 * critical_angle));
            if (c2 || c3)
                % Reflexion occurs
                new_direction = normal_v * sqrt(1 - (si * si)) + k*si;
                new_is_inside_sphere = is_inside_sphere;
            else
                % Refraction occurs
                st = (nint/next)*si;
                new_is_inside_sphere = ~is_inside_sphere;
                new_direction = -normal_v * sqrt(1 - (st * st)) + k*st;
            end
            new_direction_unit = new_direction/norm(new_direction);
            new_ray = Ray(intersection_point, new_direction_unit);
        end

    end
    properties
        origin = 0; % p0 (observer)
        direction = 0; % u 
    end
end