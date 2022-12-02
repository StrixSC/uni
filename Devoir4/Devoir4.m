

function [xi yi zi face]=Devoir4(Robs,nint,next)
    len_box_side_a = 4; % in cm
    len_box_side_b = 2; % in cm
    len_box_side_c = 4; % in cm
    box_height = len_box_side_c; % in cm;
    critical_angle = abs(asin(nint/next));

    com_sphere_OXYZ = [0;0;0]; % in cm
    com_box_OXYZ = [0;0;box_height/2]; % in cm

    %% Defining our plans:
    box_x_interval = [-len_box_side_a, len_box_side_a];
    box_y_interval = [-len_box_side_b, len_box_side_b];
    box_z_interval = [0, box_height];

    %% Cyan
    cyan_normal = [-1;0;0];
    cyan_base_interval = box_x_interval;
    cyan_height_interval = box_z_interval;
    cyan_indices = [1, 3];
    cyan_com = [len_box_side_b/2; -len_box_side_a; box_height/2];
    cyan_face_value = 1;
    cyan_plane = Plane(cyan_normal, cyan_base_interval, cyan_height_interval, cyan_indices, cyan_com, cyan_face_value);

    %% Blue
    blue_normal = [1;0;0];
    blue_base_interval = box_x_interval;
    blue_height_interval = box_z_interval;
    blue_indices = [1, 3];
    blue_face_value = 2;
    blue_com = [len_box_side_b/2; len_box_side_a; box_height/2];
    blue_plane = Plane(blue_normal, blue_base_interval, blue_height_interval, blue_indices, blue_com, blue_face_value);

    %% Red
    red_normal = [0;1;0];
    red_base_interval = box_y_interval;
    red_height_interval = box_z_interval;
    red_indices = [2, 3];
    red_face_value = 3;
    red_com = [0; len_box_side_b; box_height/2];
    red_plane = Plane(red_normal, red_base_interval, red_height_interval, red_indices, red_com, red_face_value);

    %% Orange
    orange_normal = [0;-1;0];
    orange_base_interval = box_y_interval;
    orange_indices = [2, 3];
    orange_height_interval = box_z_interval;
    orange_face_value = 4;
    orange_com = [0; -len_box_side_b; box_height/2];
    orange_plane = Plane(orange_normal, orange_base_interval, orange_height_interval, orange_indices, orange_com, orange_face_value);

    %% Green
    green_normal = [0; 0; 1];
    green_base_interval = box_x_interval;
    green_indices = [1, 2];
    green_height_interval = box_y_interval;
    green_face_value = 5;
    green_com = [0; 0; box_height];  
    green_plane = Plane(green_normal, green_base_interval, green_height_interval, green_indices, green_com, green_face_value);

    %% Magenta
    magenta_normal = [0;0;-1];
    magenta_base_interval = box_x_interval;
    magenta_indices = [1, 2];
    magenta_height_interval = box_y_interval;
    magenta_face_value = 6;
    magenta_com = [0;0;0];
    magenta_plane = Plane(magenta_normal, magenta_base_interval, magenta_height_interval, magenta_indices, magenta_com, magenta_face_value);

    %% Sphere:
    sphere_com = [0;0;0];
    sphere_radius = 8; % in cm
    sphere = Sphere(sphere_com, sphere_radius);

    %% Defining return variables:
    xi = [];
    yi = [];
    zi = [];
    face = [];

    %% Step 1: Identifying the critical sector 
    %{ 
    We need to assess the four critical points when looking at a 
    sphere from the observers' perspective. 
    The four critical points will allow us to identify the angles
    required to trace the rays.
    %}
    
    cp_1 = [0;sphere_radius];
    cp_2 = [0;-sphere_radius];
    robs_xz = [Robs(1), Robs(3)];
    robs_xy = [Robs(1), Robs(2)];

    % Theta and Phi can be found very similarily, because our solid is a sphere
    % In order to find both of the angles, we will project the view of the
    % observer on respective planes (xz for theta and xy for phi). 
    % Then, we can easily compute the angle theta or phi by using symmetry
    % trigonometric rules. 

    %% Theta:
    v1 = robs_xz - transpose(cp_1);
    v2 = robs_xz - transpose(cp_2);
    height = norm(cp_1);
    distance_xz = sqrt((0-robs_xz(1))^2 + (0-robs_xz(2))^2);
    theta = atan(height/distance_xz)*2;
    theta_start = asin(-robs_xz(1)/distance_xz) - theta/2;
    theta_end = theta_start + theta;
    theta_plus = theta_start-theta/2;
    theta_minus = theta_start;

    %% Phi:
    v3 = robs_xy - transpose(cp_1);
    v4 = robs_xy - transpose(cp_2);
    height = norm(cp_1);
    distance_xy = sqrt((0 - robs_xy(1))^2 + (0-robs_xy(2))^2);
    phi = atan(height/distance_xy)*2;
    phi_start = asin(-robs_xy(1)/distance_xy) - phi/2;
    phi_end = phi_start + phi;
    phi_plus = phi_end-phi/2;
    phi_minus = phi_start;
    

    %% Step 2: Ray Tracing
    % N and M represent the amount of theta and phi angles we will trace
    T = 1;
    P = 1;

    % We must now create rays (N*M rays to be exact) that will each have a unique
    % phi and theta angle composing it.
    % The formula is as follows:
    % \vec{omega}_(n,m) = transpose((sin(\theta_n)cos(\phi_m), sin(\theta_n)sin(\phi_m),cos(\theta_n)))
    
    function theta_n = compute_theta_n(n, count)
        theta_n = theta_plus + ((theta_end - theta_start)/(2*count))*((2*n) - 1);
    end

    function phi_m = compute_phi_m(m, count)
        phi_m = phi_plus + ((phi_end - phi_start)/(2*count))*((2*m) - 1);
    end

    function svi = compute_shortest_viable_intersection(all_intersections)
        shortest_distance = Inf;
        i = -1;
        epsilon = 1e-6;
        for j = 1:length(all_intersections)
            intersection = all_intersections(j);
            if (intersection < epsilon)
                continue
            end

            if(intersection <= shortest_distance)
                i = j;
                shortest_distance = intersection;
            end
        end
        svi = i;
    end

    function dv = compute_direction_vector(theta, phi)
        dv = [sin(theta)*cos(phi); sin(theta)*sin(phi); cos(theta)];
    end

    printf("========================STARTING...========================\n");
    for thval=0:T
        theta_n = compute_theta_n(thval, T);
        for phival=0:P
            phi_m = compute_phi_m(phival, P);
            ray_origin = [Robs(1); Robs(2); Robs(3)];
            ray_direction = compute_direction_vector(theta_n, phi_m);
            ray_direction_unit = ((ray_direction - ray_origin)/norm(ray_direction - ray_origin));
            starting_ray = Ray(ray_origin, ray_direction_unit);
            ray = starting_ray;
            total_travelled_distance = 0;
            is_inside_sphere = false;
            for reflexions=0:4
                % Intersections with planes:
                intersections = [];
                distances = [];
                [cyan_distance, cyan_plane_collision_point] = cyan_plane.check_collision_with_ray(ray);
                [blue_distance, blue_plane_collision_point] = blue_plane.check_collision_with_ray(ray);
                [red_distance, red_plane_collision_point] = red_plane.check_collision_with_ray(ray);
                [orange_distance, orange_plane_collision_point] = orange_plane.check_collision_with_ray(ray);
                [green_distance, green_plane_collision_point] = green_plane.check_collision_with_ray(ray);
                [magenta_distance, magenta_plane_collision_point] = magenta_plane.check_collision_with_ray(ray);
                [sphere_distance, sphere_collision_point] = sphere.check_collision_with_ray(ray);
                distances = [cyan_distance; blue_distance; red_distance; orange_distance; green_distance; magenta_distance; sphere_distance];
                intersections = [cyan_plane_collision_point; blue_plane_collision_point; red_plane_collision_point; orange_plane_collision_point; green_plane_collision_point; magenta_plane_collision_point; sphere_collision_point];
                svi = compute_shortest_viable_intersection(distances)
                
                if (svi < 0)
                    % If there are no indices, then there are no intersections/collisions that are on the sphere or the planes, for this angle.
                    break
                end

                total_travelled_distance = total_travelled_distance + distances(svi);
                
                if (svi < 6)
                    % Intersection occurred with one of the 6 planes -> End the computation with this ray.
                    %% Step 3: Image reconstitution.
                    resulting_point = starting_ray.compute_collision_point(total_travelled_distance);
                    xi = [xi; resulting_point(1)];
                    yi = [yi; resulting_point(2)];
                    zi = [zi; resulting_point(3)];
                    face = [face; svi];
                    break;
                else
                    % Intersection with the sphere:
                    % https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-sphere-intersection#:~:text=The%20normal%20of%20a%20point,%7CP%E2%88%92C%7C%7C.
                    col_point = [intersections(svi * 3 - 2); intersections(svi * 3 - 1); intersections(svi * 3)];
                    np = (col_point - sphere.center)/norm(col_point - sphere.center)
                    if (is_inside_sphere)
                        np = -1 * np;
                    end

                    if (is_inside_sphere)
                        [new_is_inside_sphere, new_ray] = ray.compute_new_ray(col_point, np, nint, next, critical_angle, is_inside_sphere);
                        is_inside_sphere = new_is_inside_sphere;
                        ray = new_ray;
                    else
                        [new_is_inside_sphere, new_ray] = ray.compute_new_ray(col_point, np, next, nint, critical_angle, is_inside_sphere);
                        is_inside_sphere = new_is_inside_sphere;
                        ray = new_ray;
                    end
                end
            end
        end
        thval
    end
end