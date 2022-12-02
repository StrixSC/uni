classdef Plane 
    methods
        function plane = Plane(normal, base_interval, height_interval, indices, center, defining_value)
            plane.normal = normal;
            plane.base_interval = base_interval;
            plane.height_interval = height_interval;
            plane.indices = indices;
            plane.center = center;
            plane.defining_value = defining_value;
        end

        function [distance, collision] = check_collision_with_ray(plane, ray)
            t = plane.check_collision_infinite_plan(ray);
            collision = -1;
            distance = 0;
            if (t > 1e-6)
                collision_point =  ray.compute_collision_point(t);
                collision_base = collision_point(plane.indices(1));
                collision_height = collision_point(plane.indices(2));
                base_interval = plane.base_interval;
                height_interval = plane.height_interval;

                if (collision_base >= base_interval(1) && collision_base <= base_interval(2) && collision_height >= height_interval(1) && collision_height <= height_interval(2))
                    collision = t;
                    distance = norm(collision_point - ray.origin);
                end
            end
        end

        function collision = check_collision_infinite_plan(plane, ray)
            % https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/minimal-ray-tracer-rendering-spheres
            if(abs(dot(plane.normal, ray.direction)) > 1e-6) 
                collision = dot((plane.center - ray.origin), plane.normal) / dot(plane.normal, ray.direction); 
            else
                collision = -1;
            end
        end
    end
    properties
        normal = [];
        base_interval = [];
        height_interval = [];
        indices = [];
        center = [];
        defining_value = [];
    end
end