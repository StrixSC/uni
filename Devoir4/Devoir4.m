function [xi yi zi face]=Devoir4(Robs,nint,next)
    len_box_side_a = 4; % in cm
    len_box_side_b = 2; % in cm
    len_box_side_c = 4; % in cm
    box_height = len_box_side_c; % in cm;
    sphere_radius = 8; % in cm

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
    cyan_com = [len_box_side_b/2; -len_box_side_a; box_height/2];
    cyan_face_value = 1;

    %% Blue
    blue_normal = [1;0;0];
    blue_base_interval = box_x_interval;
    blue_height_interval = box_z_interval;
    blue_face_value = 2;
    blue_com = [len_box_side_b/2; len_box_side_a; box_height/2];

    %% Red
    red_normal = [0;1;0];
    red_base_interval = box_y_interval;
    red_height_interval = box_z_interval;
    red_face_value = 3;
    red_com = [0; len_box_side_b; box_height/2];

    %% Orange
    orange_normal = [0;-1;0];
    orange_base_interval = box_y_interval;
    orange_height_interval = box_z_interval;
    orange_face_value = 4;
    orange_com = [0; -len_box_side_b; box_height/2];

    %% Green
    green_normal = [0; 0; 1];
    green_base_interval = box_x_interval;
    green_height_interval = box_y_interval;
    green_face_value = 5;
    green_com = [0; 0; box_height];  

    %% Magenta
    magenta_normal = [0;0;-1];
    magenta_base_interval = box_x_interval;
    magenta_height_interval = box_y_interval;
    magenta_face_value = 6;
    magenta_com = [0;0;0];

    %% Sphere:
    sphere_com = [0;0;0];

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
    theta_start = abs(asin(-robs_xz(1)/distance_xz)) - theta/2;
    theta_end = pi/2 - theta_start - theta;

    %% Phi:
    v3 = robs_xy - transpose(cp_1);
    v4 = robs_xy - transpose(cp_2);
    height = norm(cp_1);
    distance_xy = sqrt((0 - robs_xy(1))^2 + (0-robs_xy(2))^2);
    phi = atan(height/distance_xy)*2;
    phi_start = abs(asin(-robs_xy(1)/distance_xy)) - phi/2;
    phi_end = pi/2 - phi_start - phi;

    %% Step 2: Ray Tracing

    %% Step 3: Image reconstitution.
end