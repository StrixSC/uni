function [xi yi zi face]=Devoir4(Robs,nint,next)
    len_box_side_a = 4/100; % in meters
    len_box_side_b = 2/100; % in meters
    len_box_side_c = 4/100; % in meters
    box_height = len_box_side_c; % in meters;
    sphere_radius = 8/100; % in meters

    com_sphere_OXYZ = [0;0;0]; % in meters
    com_box_OXYZ = [0;0;box_height/2]; % in meters

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

    %% Defining return variables:
    xi = [];
    yi = [];
    zi = [];
    face = [];
end