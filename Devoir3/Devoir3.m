% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [face t x y z sommets] = Devoir3(Pos0, MatR0, V0, W0)

    function [is_completed] = verify_completion(v, w, z)
        is_completed = ((1/2 * m * v^2) + (1/2 * I * w^2) + (m * g * z)) < (2^(1/2) * m * g * l);
    end

    function [Fg] = compute_gravitational(r)
        Fg = m * g;
    end

    function [Ffs] = compute_friction_static(r, v)
        Ffs = -1 * mu_s * compute_normale(r);
    end

    function [Ffc] = compute_friction_kinetic(r, v)
        norm_v = norm(v);
        if norm_v <= 0
            Ffc = 0;
        elseif norm_v > 0
            Ffc = -1 * mu_c * compute_normale(r) * (v / norm_v);
        end
    end

    function [a] = compute_acceleration(q, t)
        r = [q(1); q(2); q(3)];
        v = [q(4); q(5); q(6)];
        z_unit = [0; 0; 1];
        Fg = compute_gravitational(r);
        Fn = z_unit * Fg;

        Ffs = compute_friction_static(r, v);
        Ffc = compute_friction_kinetic(r, v);

        F = -Fg + Fn - Ffs + Ffc;
        a = F/m;
    end

    function [aa] = compute_angular_acceleration(q, t)
        w = [q(7); q(8); q(9)];
        theta = [q(10)];
    end

    function [vertices] = compute_vertices(q ,t)
    end

    % Define dice data:
    m = 20/1000; % in kg
    l = 4/100; % in meters
    I_comp = m * (l^2) * 1/6;
    I = [
        I_comp, 0, 0;
        0, I_comp, 0;
        0, 0, I_comp;
        ];
    MI = MatR0 * I * transpose(MatR0)
    g = 9.81;

    % Define constants:
    mu_s = 0.5;
    mu_c = 0.3;

    theta0 = 0.0;

    q = [Pos0(1), Pos0(2), Pos0(3), V0(1), V0(2), V0(3), W0(1), W0(2), W0(3), theta0];

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


    
end

