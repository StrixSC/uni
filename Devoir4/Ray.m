classdef Ray 
    methods
        function ray = Ray(origin, direction)
            ray.origin = transpose(origin);
            ray.direction = direction;
        end
        % Requires the intersection point computed using the infinite plane method
        function collision_point = compute_collision_point(ray, t)
            collision_point_x =  ray.origin(1) + (t * (ray.direction(1) - ray.origin(1)));
            collision_point_y =  ray.origin(2) + (t * (ray.direction(2) - ray.origin(2)));
            collision_point_z =  ray.origin(3) + (t * (ray.direction(3) - ray.origin(3)));
            collision_point = [collision_point_x; collision_point_y; collision_point_z];
        end
    end
    properties
        origin = 0; % p0 (observer)
        direction = 0; % u 
    end
end