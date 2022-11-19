% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [face t x y z sommets] = Devoir3(Pos0, MatR0, V0, W0)

    function [is_completed] = verify_completion(q)
        v = [q(4); q(5); q(6)];
        w = [q(7); q(8); q(9)];
        z = q(3);
        is_completed = ((1/2 * m * norm(v)^2) + (1/2 * I * norm(w)^2) + (m * grav * z)) < (2^(1/2) * m * grav * l);
    end

    function [Fg] = compute_gravitational()
        Fg = [0; 0; -1 * m * grav];
    end

    function [Ffs] = compute_friction_static()
        Fg = compute_gravitational();
        N = -1 * Fg;
        Ffs = -1 * mu_s * N;
    end

    function [Ffc] = compute_friction_kinetic(v)
        norm_v = norm(v);

        if norm_v <= 0
            Ffc = 0;
        elseif norm_v > 0
            Fg = compute_gravitational();
            N = -1 * Fg;
            Ffc = -1 * mu_c * transpose(N) * (v / norm_v);
        end

    end

    function [vertices] = compute_final_vertices(q)
        r = [q(1); q(2); q(3)];
        MatRot = [
            q(10) q(11) q(12);
            q(13) q(14) q(15);
            q(16) q(17) q(18);
        ];
        vertices = MatRot * [
            r(1) + l / 2, r(1) + -l / 2, r(1) + -l / 2, r(1) + l / 2, r(1) + l / 2, r(1) + -l / 2, r(1) + -l / 2, r(1) + l / 2;
            r(2) + l / 2, r(2) + l / 2, r(2) + -l / 2, r(2) + -l / 2, r(2) + l / 2, r(2) + l / 2, r(2) + -l / 2, r(2) + -l / 2;
            r(3) + -l / 2, r(3) + -l / 2, r(3) + -l / 2, r(3) + -l / 2, r(3) + l / 2, r(3) + l / 2, r(3) + l / 2, r(3) + l / 2;
        ];
    end

    function [collides, touches_ground] = detect_collision(q, t)
        % This method will detect if there is a collision in the experiment. It will return 1 if there is a collision (or about to be a collision) by using the sphere method
        % If the sphere method detects a collision is about to happen, we check for collisions using AABB method. If a collision occurs then, we return 2.
        % If no collisions occurred, we return 0;

        % q is the q matrix containing the required information and t is the total time lapsed in the experiment
        r = [q(1); q(2); q(3)];

        % Check with methode de sphere first:
        collides = 0;
        bottom_of_sphere = r(3) - radius_sphere;

        if bottom_of_sphere <= 0
            collides = 1; % We have reached the threshold where we could have/already have a collision.
        end

        if collides == 0
            return;
        end

        rotated_vertices_OXYZ = transpose(compute_final_vertices(q));
        touches_ground = [];

        for i = 1:size(rotated_vertices_OXYZ, 1)
            vertex = [rotated_vertices_OXYZ(i, 1); rotated_vertices_OXYZ(i, 2); rotated_vertices_OXYZ(i, 3)];
            if vertex(3) <= 0
                collides = 2;
                touches_ground = [touches_ground; vertex];
            end
        end
    end

    function [a] = compute_acceleration(q, t)
        r = [q(1); q(2); q(3)];
        v = [q(4); q(5); q(6)];
        z_unit = [0 0 1];
        Fg = compute_gravitational();
        N = -1 * Fg;

        Ffs = compute_friction_static();
        Ffc = compute_friction_kinetic(v);

        F = Fg + N + Ffs + Ffc;
        a = F / m;
    end

    function [Rx] = RX(thX)
        Rx = [
            1, 0, 0;
            0, cos(thX), -sin(thX);
            0, sin(thX), cos(thX)
            ];
    end

    function [Ry] = RY(thY)
        Ry = [
            cos(thY), 0, sin(thY);
            0, 1, 0;
            -sin(thY), 0, cos(thY)
            ];
    end

    function [Rz] = RZ(thZ)
        Rz = [
            cos(thZ), -sin(thZ), 0;
            sin(thZ), cos(thZ), 0;
            0, 0, 1
            ];
    end

    function [ang_acc] = compute_angular_acceleration(q, t)
        % % theta = [q(10)];
        % % initial angular velocity
        % w = [q(7); q(8); q(9)];
        % % initial position
        % r = [q(1); q(2); q(3)];
        % r_oxyz = [l / 2; l / 2; l / 2];
        % % local inertia matrix
        % Ilocal = I;

        % thX = q(10);

        % % tourne x y z ?
        % Rx = RX(thX);
        % Ry = RY(thY);
        % Rz = RZ(thZ);

        % % matrice de rotation
        % Rt = Rx * Ry * Rz;

        % % force normal au point de la collision
        % n = [0; 0; 1];

        % Ilocal = compute_moment_of_inertia(mass);
        % tau = cross(r_oxyz, n);
        % MI = Rx * Ilocal * transpose(Rx);
        % L = MI * w;

        % ang_acc = inv(MI) * tau + cross(L, w);
        ang_acc = [0;0;0];
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

    function [q] = compute_post_collision_q(q)
        r0 = [q(1); q(2); q(3)];
        v0 = [q(4); q(5); q(6)];
        w0 = [q(7); q(8); q(9)];
        n = -1 * compute_gravitational();
        u = cross(v0, n) / norm(cross(v0, n));
        t = cross(n, u);
        j = -m * (1 + epsilon) * dot(n, v0);
        G_a = dot(t, (inv(MI) * cross(cross(r0, t), r0)));
        alpha = 1 / ((1 / m) + G_a);
        jt = 0;

        if (mu_s * (1 + epsilon) * abs(dot(n, v0)) < abs(dot(t, v0)))
            jt = alpha * mu_c * (1 + epsilon) * dot(n, v0);
        else
            jt = -1 * alpha * abs(dot(t, v0));
        end

        J = n * j + t * jt;
        vf = v0 + (J / m);
        wf = w0 + (inv(MI) * cross(r0, J));
        q = [q(1),
            q(2),
            q(3),
            vf(1),
            vf(2),
            vf(3),
            wf(1),
            wf(2),
            wf(3),
            q(10),
            q(11),
            q(12),
            q(13),
            q(14),
            q(15),
            q(16),
            q(17),
            q(18)
        ];
    end

    function [vertices] = compute_vertices(q, t)
        p = [q(1); q(2); q(3)];
        r = [q(10); q(11); q(12)];
        vertices0 = [
                [
            p(1) + l / 2, p(1) + -l / 2, p(1) + -l / 2, p(1) + l / 2, p(1) + l / 2, p(1) + -l / 2, p(1) + -l / 2, p(1) + l / 2;
            p(2) + l / 2, p(2) + l / 2, p(2) + -l / 2, p(2) + -l / 2, p(2) + l / 2, p(2) + l / 2, p(2) + -l / 2, p(2) + -l / 2;
            p(3) + -l / 2, p(3) + -l / 2, p(3) + -l / 2, p(3) + -l / 2, p(3) + l / 2, p(3) + l / 2, p(3) + l / 2, p(3) + l / 2;
            ]
        ];
        rot = [sind(r(1)); sind(r(2)); sind(r(3))];
        trans = zeros(3, 8);

        for rows = 1:3

            for col = 1:8
                trans(rows, col) = l / 2 * rot(rows);
                vertices(rows, col) = vertices0(rows, col) + trans(rows, col);
            end

        end

    end

    % Define dice data:
    m = 20/1000; % in kg
    l = 4/100; % in meters
    I_dice = m * (l^2) * 1/6;
    I = I_dice * [1, 0, 0; 0, 1, 0; 0, 0, 1];
    MI = MatR0 * I * transpose(MatR0);
    grav = 9.81;
    radius_sphere = 1/2 * sqrt(3 * (l^2)); % In meters
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
    dT = 0.1; % Set delta t to an arbitrairy value;
    snapshot_timer = dT * 50; % Snapshots are taken at intervals, rather than at every incrementation.
    printf("[*] Using deltaT: %f and recording the position of the rocket every: %f seconds.\n", dT, snapshot_timer);

    iterations = 1;
    snapshots_saved = 1;
    collide_counter = 0;
    while !completed
        % Update return arrays:
        time = time + dT;
        g = @compute_g;
        q = SEDRK4t0(q, time, dT, g);
        iterations = iterations + 1;

        collides = detect_collision(q, time);

        if collides == 2
            printf("[!] Collide with ground");
            % q = compute_post_collision_q(q);
            collide_counter = collide_counter + 1;
        end

        r = [q(1); q(2); q(3)];
        if (abs(time - time_since_last_snapshot) >= snapshot_timer)
            snapshots_saved = snapshots_saved + 1;
            time_since_last_snapshot = time;
            t = [t; time];
            x = [x; r(1)];
            y = [y; r(2)];
            z = [z; r(3)];
        end


        if (snapshots_saved >= 1000)
            printf("[!] Reached above 1000 snapshots\n")
            break;
        end

        completed = verify_completion(q);
    end

    if (iterations <= 100)
        printf("[!] Change deltaT, because snapshot count is too low...\n")
    end

    sommets = compute_final_vertices(q);

    printf("[*] We have %i iterations\n", iterations)
    printf("[*] We have %i snapshots\n", snapshots_saved)
end
