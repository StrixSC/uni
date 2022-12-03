classdef Sphere

    methods

        function sphere = Sphere(center, radius)
            sphere.center = center;
            sphere.radius = radius;
        end

        function [distance, collision_point] = check_collision_with_ray2(sphere, ray)
            collision_point = [0; 0; 0];
            a = dot(ray.direction, ray.direction);
            b = 2 * dot(ray.origin, ray.direction);
            c = dot(ray.origin, ray.origin) - (sphere.radius * sphere.radius);

            disc = b^2 - 4 * a * c;
            denom = 2 * a;

            if (disc < 0)
                t = -1;
            elseif (disc == 0)
                t = -b/denom
                if (t < 0)
                    % hits the sphere from behind, we dont want that.
                    t = -1
                else
                    collision_point = ray.compute_collision_point(t);
                    t = t;
                end
            else
                t = -1;
                t0 = (-b - disc) / denom;
                t1 = (-b + disc) / denom;

                if (t0 < 0 && t1 < 0)
                    valide = false;
                elseif (t0 > 0 && t1 < 0)
                    t = t0;
                elseif (t0 < 0 && t1 > 0)
                    t = t1;
                elseif (t0 > 0 && t1 > 0)
                    if (t0 < t1)
                        t = t0;
                    else
                        t = t1;
                    end
                end
            end

            if (t > 0)
                collision_point = ray.compute_collision_point(t);
                distance = norm(collision_point - ray.origin);
            else
                distance = -1
                collision_point = [0;0;0];
            end
        end

        function [distance, collision_point] = check_collision_with_ray2(sphere, ray)
            RayOrigin = ray.origin;
            RayDirection = ray.direction;
            SphereOrigin = sphere.center;
            SphereRadius = sphere.radius;
            RayStartToSphere = SphereOrigin - RayOrigin;
            Projection = dot(RayDirection, RayStartToSphere); 
            DiskRadiusSquared = SphereRadius^2 - (((norm(RayStartToSphere))^2 - Projection^2));
            if (DiskRadiusSquared < 0)
                distance = -1;
                collision_point = [0;0;0];
                return;
            end
            DiskRadius = sqrt(DiskRadiusSquared);
            t0 = Projection - DiskRadius;
            t1 = Projection + DiskRadius;
            t = -1;
            if (t0 < 0 && t1 < 0)
                valide = false;
            elseif (t0 > 0 && t1 < 0)
                t = t0;
            elseif (t0 < 0 && t1 > 0)
                t = t1;
            elseif (t0 > 0 && t1 > 0)
                if (t0 < t1)
                    t = t0;
                else
                    t = t1;
                end
            end
            if (t > 0)
                collision_point = ray.compute_collision_point(t);
                distance = norm(collision_point - RayOrigin);
            else
                distance = -1;
                collision_point = [0;0;0];
            end
        end

        function [distance, collision_point] = check_collision_with_ray(sphere, ray)
            distance = -1;
            collision_point = [0;0;0];
            ray_start_to_sphere_center = sphere.center - ray.origin;
            a = dot(ray.direction, ray.direction);
            b = -2 * dot(ray_start_to_sphere_center, ray.direction);
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
