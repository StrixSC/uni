% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [face t x y z sommets] = Devoir3(Pos0, MatR0, V0, W0)

    function [is_completed] = verify_completion(v, w, z)
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

    function [collides] = detect_collision(q)
        r = [q(1); q(2); q(3)];
        bottom_of_cube = r(3) - radius_sphere;
        if (bottom_of_cube <= 0)
            collides = true
        else
            collides = false
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
        a = F/m;
    end

    function [aa] = compute_angular_acceleration(q, t)
        w = [q(7); q(8); q(9)];
        theta = [q(10)];
        aa = [0;0;0];
    end

    function [g] = compute_g(q, t)
        v = [q(4); q(5); q(6)];
        w = [q(7); q(8); q(9)];
        a = compute_acceleration(q, t);
        aa = compute_angular_acceleration(q, t);
        g = [v(1) v(2) v(3) a(1) a(2) a(3) aa(1) aa(2) aa(3) w(1) w(2) w(3)];
    end

    function [q] = compute_post_collision_q(q)
        r0 = [q(1); q(2); q(3)];
        v0 = [q(4); q(5); q(6)];
        w0 = [q(7); q(8); q(9)];
        has_friction = detect_collision(r0);
        n = -1 * compute_gravitational();
        u = cross(v0, n)/norm(cross(v0, n));
        t = cross(n, u);
        j = -m * (1 + epsilon) * dot(n, v0);
        G_a = dot(t, (inv(MI) * cross(cross(r0, t), r0)));
        alpha = 1/((1/m) + G_a);
        jt = 0;
        if (mu_s * (1 + epsilon) * abs(dot(n, v0)) < abs(dot(t, v0)))
            jt = alpha * mu_c * (1 + epsilon) * dot(n, v0);
        else
            jt = -1 * alpha * abs(dot(t, v0));
        end
        J = n * j + t * jt;
        vf = v0 + (J/m);
        wf = w0 + (inv(MI) * cross(r0, J));
        q = [q(1); q(2); q(3); vf(1); vf(2); vf(3); wf(1); wf(2); wf(3); q(10); q(11); q(12)];
    end

    function [vertices] = compute_vertices(q ,t)
        p = [q(1); q(2); q(3)];
        r = [q(10); q(11); q(12)];
        vertices0 = [
            [
                p(1) + l/2, p(1) + -l/2, p(1) + -l/2, p(1) + l/2, p(1) + l/2, p(1) + -l/2, p(1) + -l/2, p(1) + l/2;
                p(2) + l/2, p(2) + l/2, p(2) + -l/2, p(2) + -l/2, p(2) + l/2, p(2) + l/2, p(2) + -l/2, p(2) + -l/2;
                p(3) + -l/2, p(3) + -l/2, p(3) + -l/2, p(3) + -l/2, p(3) + l/2, p(3) + l/2, p(3) + l/2, p(3) + l/2;
            ]
        ];
        rot = [sind(r(1)); sind(r(2)); sind(r(3))];
        trans = zeros(3, 8);

        for rows = 1:3
            for col = 1:8
                trans(rows, col) = l/2 * rot(rows);
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
    radius_sphere = 1/2 * sqrt(3*(l^2)); % In meters
    epsilon = 0.5;

    % Define constants:
    mu_s = 0.5;
    mu_c = 0.3;
    theta = [0; 0; 0];

    q = [Pos0(1), Pos0(2), Pos0(3), V0(1), V0(2), V0(3), W0(1), W0(2), W0(3), theta(1), theta(2), theta(3)];
    
    face = 1;
    t = [0];
    x = [Pos0(1)];
    y = [Pos0(2)];
    z = [Pos0(3)];

    vertices = [
        [
            l/2, -l/2, -l/2, l/2, l/2, -l/2, -l/2, l/2;
            l/2, l/2, -l/2, -l/2, l/2, l/2, -l/2, -l/2;
            Pos0(3) + -l/2, Pos0(3) + -l/2, Pos0(3) + -l/2, Pos0(3) + -l/2, Pos0(3) + l/2, Pos0(3) + l/2, Pos0(3) + l/2, Pos0(3) + l/2;
        ]
    ];
    sommets = vertices;


    time = 0;
    time_since_last_snapshot = 0;

    completed = false;
    dT = 0.1; % Set delta t to an arbitrairy value;
    snapshot_timer = dT * 50; % Snapshots are taken at intervals, rather than at every incrementation.
    printf("[*] Using deltaT: %f and recording the position of the rocket every: %f seconds.\n", dT, snapshot_timer);
    
    iterations = 1;
    snapshots_saved = 1;

    compute_post_collision_q(q)
    % while !completed
    %     % Update return arrays:
    %     time = time + dT;
    %     g = @compute_g;
    %     q = SEDRK4t0(q, time, dT, g);
    %     iterations = iterations + 1;
    %     r = [q(1); q(2); q(3)];
    %     if (abs(time - time_since_last_snapshot) >= snapshot_timer)
    %         snapshots_saved = snapshots_saved + 1;
    %         time_since_last_snapshot = time;
    %         t = [t; time];
    %         x = [x; r(1)];
    %         y = [y; r(2)];
    %         z = [z; r(3)];
    %     end

    %     if (snapshots_saved >= 1000)
    %         printf("[!] Reached above 1000 snapshots\n")
    %         break;
    %     end

    %     v = [q(4); q(5); q(6)];
    %     w = [q(7); q(8); q(9)];
    %     z = q(3);

    %     completed = verify_completion(v, w, z);
    % end

    % if (iterations <= 100)
    %     printf("[!] Change deltaT, because snapshot count is too low...\n")
    % end

    % printf("[*] We have %i iterations\n", iterations)
    % printf("[*] We have %i snapshots\n", snapshots_saved)
end

