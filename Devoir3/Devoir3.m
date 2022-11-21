% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [face t x y z sommets] = Devoir3(Pos0, MatR0, V0, W0)

    function [is_completed] = verify_completion(q)
        v = [q(4); q(5); q(6)];
        w = [q(7); q(8); q(9)];
        z = q(3);
        is_completed = false;
        if ((1/2 * m * norm(v)^2) + (1/2 * I * norm(w)^2) + (m * grav * z)) < (2^(1/2) * m * grav * l)
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
        z_unit = [0 0 1];
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
        R_yx = q(11);
        R_zx = q(12);
        R_xy = q(13);
        R_yy = q(14);
        R_zy = q(15);
        R_xz = q(16);
        R_yz = q(17);
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

    function [vf, wf] = compute_post_collision_q(q, colliding_vertex)
        r0 = [q(1); q(2); q(3)] - transpose(colliding_vertex);
        v0 = [q(4); q(5); q(6)];
        w0 = [q(7); q(8); q(9)];
        n = [0; 0; 1];
        r0
        w0
        v_minus = v0 + cross(w0, r0);
        u = cross(v_minus, n) / norm(cross(v_minus, n));
        t = cross(n, u);
        j = -m * (1 + epsilon) * dot(n, v0);
        G_a_t = dot(t, (inv(MI) * cross(cross(r0, t), r0)));
        alpha = 1 / ((1 / m) + G_a_t);

        if (mu_s * (1 + epsilon) * abs(dot(n, v_minus)) < abs(dot(t, v_minus)))
            jt = alpha * mu_c * (1 + epsilon) * dot(n, v0);
        else
            jt = -1 * alpha * abs(dot(t, v0));
        end

        j = -alpha * (1 + epsilon) * dot(n, v_minus);
        J = n * j + t * jt;
        vf = v0 + (J / m);
        wf = w0 + (inv(MI) * cross(r0, J));
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
    MI = MatR0 * I * transpose(MatR0);
    grav = 9.81;
    radius_sphere = 1/2 * sqrt(3 * (l^2)); % In meters
    MIN_SPHERE_THRESHOLD = 0.001;
    MAX_SPHERE_THRESHOLD = -MIN_SPHERE_THRESHOLD;
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
        MatR0(2, 1), % R_yx, q(11)
        MatR0(3, 1), % R_zx, q(12)
        MatR0(1, 2), % R_xy, q(13)
        MatR0(2, 2), % R_yy, q(14)
        MatR0(3, 2), % R_zy, q(15)
        MatR0(1, 3), % R_xz, q(16)
        MatR0(2, 3), % R_yz, q(17)
        MatR0(3, 3), % R_zz, q(18)
        ];

    face = 1;
    t = [0];
    x = [Pos0(1)];
    y = [Pos0(2)];
    z = [Pos0(3)];

    time = 0;
    time_since_last_snapshot = 0;

    completed = false;
    original_dT = 0.0005;
    dT = original_dT; % Set delta t to an arbitrairy value;
    printf("[*] Using deltaT: %f.\n", dT);

    iterations = 1;
    snapshots_saved = 1;
    collision_counter = 0;

    while !completed
        time = time + dT;
        g = @compute_g;
        iterations = iterations + 1;
        r = [q(1); q(2); q(3)]
        v_z = q(6);
        r_z = q(3);
        is_falling = true;
        if (v_z > 0)
            is_falling = false;
        end
        edge_of_sphere_z = q(3) - radius_sphere;

        if (is_falling && 
            edge_of_sphere_z >= MAX_SPHERE_THRESHOLD && 
            edge_of_sphere_z <= MIN_SPHERE_THRESHOLD)
            % At this stage, we can safely assume that a collision is happening or is about to happen.
            q = SEDRK4t0(q, time, dT, g);
            vertices = transpose(compute_vertices(q));
            vertices_z = vertices(:, [3]);
            [minimum_z, index] = min(vertices_z)
            lowest_vertex = vertices(index, [1:3])
            [vf, wf] = compute_post_collision_q(q, lowest_vertex);
            for i=1:3
                q(i+3) = vf(i);
                q(i+6) = wf(i);
            end
            collision_counter = collision_counter + 1;
        elseif(is_falling && edge_of_sphere_z <= MAX_SPHERE_THRESHOLD)
            % % Collision occurred, so we decrease dT and revert the snapshot to before the collision.
            % iterations = iterations - 1;
            % time = time - dT;
            % dT = dT/2;
            % q = SEDRK4t0(q, time, dT, g);
            % continue
        else
            q = SEDRK4t0(q, time, dT, g);
        end

        r = [q(1); q(2); q(3)];
        t = [t; time];
        x = [x; r(1)];
        y = [y; r(2)];
        z = [z; r(3)];
        completed = verify_completion(q);

        if (size(t, 1) >= 1000)
            printf("[!] Reached above 1000 snapshots\n")
            completed = true;
        end

    end

    if (size(t, 1) <= 100)
        printf("[!] Change deltaT, because snapshot count is too low...\n")
    end

    sommets = compute_vertices(q);

    printf("[*] Collided this amount of times: %i\n", collision_counter);
    printf("[*] We have %i iterations\n", iterations);
    printf("[*] We have %i snapshots\n", snapshots_saved);
end
