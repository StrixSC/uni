% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [face t x y z sommets] = Devoir3(Pos0, MatR0, V0, W0)

    function [is_completed] = verify_completion(q)
        v = [q(4); q(5); q(6)];
        w = [q(7); q(8); q(9)];
        pos_z = q(3);
        is_completed = false;
        if ((1/2 * m * dot(v, v)) + (1/2 * I * dot(w, w)) + (m * grav * pos_z)) < (sqrt(2) * m * grav * l)
            is_completed = true;
        end
    end

    function [Fg] = compute_gravitational()
        Fg = -1 * m * [0; 0; grav];
    end

    function [Ffs] = compute_friction_static(N)
        Ffs = -1 * mu_s * N;
    end

    function [Ffc] = compute_friction_kinetic(v, N)
        norm_v = norm(v);
        norm_N = norm(N);
        
        if norm_v <= 0
            Ffc = [0;0;0];
        elseif norm_v > 0
            Ffc = -1 * mu_c * transpose(N) * (v / norm_v);
        end

    end

    function [vertices] = compute_vertices(q)
        r = [q(1); q(2); q(3)];
        MatRot = [
            q(10) q(11) q(12);
            q(13) q(14) q(15);
            q(16) q(17) q(18);
            ];
        vertices = r + MatRot * relative_vertices;
    end


    function [a] = compute_acceleration(q, t)
        r = [q(1); q(2); q(3)];
        v = [q(4); q(5); q(6)];
        pos_z_unit = [0 0 1];
        Fg = compute_gravitational();

        N = [0; 0; 0];

        if r(3) <= 0
            N = -1 * Fg;
        end

        Ffs = compute_friction_static(N);
        Ffc = compute_friction_kinetic(v, N);

        F = Fg + N + Ffs + Ffc;
        a = F/m;
    end

    function [ang_acc] = compute_angular_acceleration(q, t)
        ang_acc = [0; 0; 0];
    end

    function [g] = compute_g(q, t)
        v = [q(4); q(5); q(6)];
        w = [q(7); q(8); q(9)];
        a = compute_acceleration(q, t);
        aa = compute_angular_acceleration(q, t);

        R_xx = q(10);
        R_xy = q(11);
        R_xz = q(12);
        R_yx = q(13);
        R_yy = q(14);
        R_yz = q(15);
        R_zx = q(16);
        R_zy = q(17);
        R_zz = q(18);

        dR_xx_dt = w(2) * R_zx - w(3) * R_yx;
        dR_yx_dt = w(2) * R_zy - w(3) * R_yy;
        dR_zx_dt = w(2) * R_zz - w(3) * R_yz;
        dR_xy_dt = w(3) * R_xx - w(1) * R_zx;
        dR_yy_dt = w(3) * R_xy - w(1) * R_zy;
        dR_zy_dt = w(3) * R_xz - w(1) * R_zz;
        dR_xz_dt = w(1) * R_yx - w(2) * R_xx;
        dR_yz_dt = w(1) * R_yy - w(2) * R_xy;
        dR_zz_dt = w(1) * R_yz - w(2) * R_xz;

        g = [v(1),
            v(2),
            v(3),
            a(1),
            a(2),
            a(3),
            aa(1),
            aa(2),
            aa(3),
            dR_xx_dt,
            dR_yx_dt,
            dR_zx_dt,
            dR_xy_dt,
            dR_yy_dt,
            dR_zy_dt,
            dR_xz_dt,
            dR_yz_dt,
            dR_zz_dt
        ];

    end

    function [landed_face] = compute_landed_face(vertices)
        % position of face 1 is the average of positions of vertices 1, 2, 3 and 4
        pos_face_1 = (vertices(:, 1)+vertices(:, 2)+vertices(:, 3)+vertices(:,4))/4;

        % position of face 2 is the average of positions of vertices 3, 4, 7 and 8
        pos_face_2 = (vertices(:, 3)+vertices(:, 4)+vertices(:, 7)+vertices(:,8))/4;

        % position of face 3 is the average of positions of vertices 1, 2, 3 and 4
        pos_face_3 = (vertices(:, 2)+vertices(:, 3)+vertices(:, 6)+vertices(:,7))/4;

        % position of face 4 is the average of positions of vertices 1, 4, 5 and 8
        pos_face_4 = (vertices(:, 1)+vertices(:, 4)+vertices(:, 5)+vertices(:,8))/4;

        % position of face 5 is the average of positions of vertices 1, 2, 5 and 6
        pos_face_5 = (vertices(:, 1)+vertices(:, 2)+vertices(:, 5)+vertices(:, 6))/4;

        % position of face 6 is the average of positions of vertices 5, 6, 7 and 8
        pos_face_6 = (vertices(:, 5)+vertices(:, 6)+vertices(:, 7)+vertices(:, 8))/4;

        % The highest (in terms of z position) valued face is the face that it has landed on (or appears to have landed on in the final result of the simulation):
        face_positions = [pos_face_1(3) pos_face_2(3) pos_face_3(3) pos_face_4(3) pos_face_5(3) pos_face_6(3)];
        [maximum_value, index] = max(face_positions);
        landed_face = index;
    end

    function [vf, wf] = compute_post_collision_q(q, colliding_vertex, collision_counter)
        r0 = [q(1); q(2); q(3)] - transpose(colliding_vertex);
        v0 = [q(4); q(5); q(6)];
        w0 = [q(7); q(8); q(9)];
        n = [0; 0; 1];
        v_minus = v0 + cross(w0, r0);
        u = cross(v_minus, n) / norm(cross(v_minus, n));
        t_ = cross(n, u);
        j = -m * (1 + epsilon) * dot(n, v0);
        G_a_t = dot(t_, (inv(I) * cross(cross(r0, t_), r0)));
        alpha = 1 / ((1 / m) + G_a_t);

        if (mu_s * (1 + epsilon) * abs(dot(n, v_minus)) < abs(dot(t_, v_minus)))
            jt = alpha * mu_c * (1 + epsilon) * dot(n, v0);
        else
            jt = -1 * alpha * abs(dot(t_, v0));
        end

        if (collision_counter <= MAX_COLLISION)
            jt = 0;
        end

        j = -alpha * (1 + epsilon) * dot(n, v_minus);

        J = n * j + t_ * jt;
        vf = v0 + (J / m);
        wf = w0 + (inv(I) * cross(r0, J));
    end

    % Define dice data:
    m = 20/1000; % in kg
    l = 4/100; % in meters
    I_dice = m * (l^2) * 1/6;
    I = I_dice * [1, 0, 0; 0, 1, 0; 0, 0, 1];
    relative_vertices = [
                    l / 2, -l / 2, -l / 2, l / 2, l / 2, -l / 2, -l / 2, l / 2;
                    l / 2, l / 2, -l / 2, -l / 2, l / 2, l / 2, -l / 2, -l / 2;
                    -l / 2, -l / 2, -l / 2, -l / 2, l / 2, l / 2, l / 2, l / 2;
                    ];
    grav = 9.81;
    radius_sphere = 1/2 * sqrt(3 * (l^2)); % In meters
    ERROR_RANGE = 1/1000;
    MAX_COLLISION = 3;
    epsilon = 0.5;

    % Define constants:
    mu_s = 0.5;
    mu_c = 0.3;
    theta = [0; 0; 0];

    q = [
        Pos0(1), % cm x, q(1)
        Pos0(2), % cm y, q(2)
        Pos0(3), % cm z, q(3)
        V0(1), % v x, q(4)
        V0(2), % v y, q(5)
        V0(3), % v z, q(6)
        W0(1), % w z, q(7)
        W0(2), % w z, q(8)
        W0(3), % w z, q(9)
        MatR0(1, 1), % R_xx, q(10)
        MatR0(2, 1), % R_xy, q(11)
        MatR0(3, 1), % R_xz, q(12)
        MatR0(1, 2), % R_yx, q(13)
        MatR0(2, 2), % R_yy, q(14)
        MatR0(3, 2), % R_yz, q(15)
        MatR0(1, 3), % R_zx, q(16)
        MatR0(2, 3), % R_zy, q(17)
        MatR0(3, 3), % R_zz, q(18)
        ];

    completed = false;
    face = 1;
    time = 0;
    time_since_last_snapshot = 0;
    dT_divider = 10000;
    original_dT = 0.001;
    dT = original_dT; % Set delta t to an arbitrairy value;
    snapshot_timer = dT * 10;
    t = [time];
    x = [Pos0(1)];
    y = [Pos0(2)];
    z = [Pos0(3)];
    iterations = 1;
    snapshots_saved = 1;
    collision_counter = 0;
    g = @compute_g;
    force_collision = false;

    while !completed
        v_z = q(6);
        r_z = q(3);
        is_falling = true;
        if (v_z > 0)
            is_falling = false;
        end
        edge_of_sphere_z = q(3) - radius_sphere;

        if (is_falling && edge_of_sphere_z <= 0)
            % At this stage, we can safely assume that a collision is happening or is about to happen.
            vertices = transpose(compute_vertices(q));
            vertices_z = vertices(:, [3]);
            [minimum_z, index] = min(vertices_z);
            
            if(minimum_z <= (-1 * ERROR_RANGE))
                % This is a failsafe in case the change in dT was not able to capture a position that fits the bounds of 1mm (-0.0001 < z < 0.0001) set in the assignment handout.
                force_collision = true;
            end

            if(force_collision || (minimum_z <= ERROR_RANGE && minimum_z >= (-1 * ERROR_RANGE)))
                % Here we can assume that the dice has officially impacted the ground and a collision is happening.
                lowest_vertex = vertices(index, [1:3]);
                [vf, wf]= compute_post_collision_q(q, lowest_vertex, collision_counter);
                for i=1:3
                    q(i+3) = vf(i);
                    q(i+6) = wf(i);
                end
                q(6) = abs(q(6));
                % reset dT:
                dT = original_dT;
                force_collision = false;
                collision_counter = collision_counter + 1;
            else
                % At this stage, the sphere surrounding the dice has enterred the zone at which we must reduce the delta T to precisely pinpoint the moment of the collision.
                % slightly reduce dT;
                dT = dT - original_dT/dT_divider;
                % After a certain level, the dT becomes way too low to impact the change of q, thus we must force a collision.
                if dT <= original_dT/1000
                    force_collision = true;    
                end

                % recompute q;
                q = SEDRK4t0(q, time, dT, g);
                % restart this same iteration (iteration count has not changed).
                continue;
            end
        end


        time = time + dT;
        q = SEDRK4t0(q, time, dT, g);
        iterations = iterations + 1;
        r = [q(1); q(2); q(3)];
        if (abs(time - time_since_last_snapshot) >= snapshot_timer)
            snapshots_saved = snapshots_saved + 1;
            time_since_last_snapshot = time;
            t = [t time];
            x = [x r(1)];
            y = [y r(2)];
            z = [z r(3)];
        end

        if (snapshots_saved >= 1000)
            printf("[!] Reached above 1000 snapshots\n")
            break;
        end

        completed = verify_completion(q);
    end

    if (snapshots_saved <= 100)
        printf("[!] Change deltaT, because snapshot count is too low...\n")
    end

    sommets = compute_vertices(q);
    landed_face = compute_landed_face(sommets);
    printf("[*] Landed on: %i\n", landed_face);
    printf("[*] Collided this amount of times: %i\n", collision_counter);
    printf("[*] We have %i iterations\n", iterations);
    printf("[*] We have %i snapshots\n", snapshots_saved);
end
