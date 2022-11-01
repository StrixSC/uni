% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [Vf t x y z] = Devoir2(theta)

    function [alpha] = compute_alpha(v, thX)
        rocket_axis_oxyz = [0; 0; 1];
        rocket_axis_OXYZ = R(thX) * rocket_axis_oxyz;
        denom = (norm(v) * norm(rocket_axis_OXYZ));
        if (denom)
            alpha = acos(dot(v, rocket_axis_OXYZ)/denom);
        else
            alpha = 0; % The alpha will be parallel to the Z axis
        end

    end

    function [is_completed] = verify_completion(r)
        completed = false;
        d = r(1)^2 + r(2)^2 + r(3)^2;

        if (d >= 10^14)
            printf("[!] Rocket distance greater than 10^14...\n");
        elseif (d <= earth_radius^2)
            printf("[!] Crash...\n");
        end

        is_completed = d >= 10^14 || d <= earth_radius^2;
    end

    % Rotation matrix about the X axis, at thX angle.
    function [Rx] = R(thX)
        Rx = [
            1, 0, 0;
            0, cos(thX), -sin(thX);
            0, sin(thX), cos(thX)
            ];
    end

    function [mass] = compute_rocket_mass_at_time(time)
        mass = (rocket_mass + fuel_mass) - 1200 * time;

        if (mass <= rocket_mass - fuel_mass)
            mass = rocket_mass;
        end

    end

    function [I] = compute_moment_of_inertia(mass)
        I_zz = mass / 2 * rocket_radius^2;
        I_xx = I_yy = (mass / 4 * rocket_radius^2) + (mass / 12 * rocket_height^2);
        I = [
            I_xx, 0, 0;
            0, I_yy, 0;
            0, 0, I_zz;
            ];
    end

    function [Fp] = compute_propulsion(r, thX, mass)
        v_gas = -1 * initial_v_gas * [0; sin(theta); cos(theta)];
        Fp = -1 * mu * v_gas;

        if (mass <= rocket_mass)
            Fp = [0; 0; 0];
        else
            Fp = Fp;
        end

    end

    function [Fg] = compute_gravitational(r, mass)
        g = -1 * G * M_t * (r / (norm(r)^3));
        Fg = mass * g;
    end

    function [Fvis] = compute_friction(r, v, alpha)
        % Add cos alpha absolute values
        A = (pi * rocket_radius^2 * cos(alpha)) + (2 * rocket_radius * rocket_height * sin(alpha));
        rho = rho_0 * exp((earth_radius - norm(r)) / h_0);
        Fvis = -1 * 1/2 * A * rho * C_vis * norm(v) * v;
    end

    function [ang_acc] = compute_angular_acceleration(q, t)
        r = [0; q(3); q(4)];
        thX = q(6);
        mass = compute_rocket_mass_at_time(t);
        propulsion_force = compute_propulsion(r, thX, mass);
        tau = cross(r_oxyz, propulsion_force);
        I_local = compute_moment_of_inertia(mass);
        Rx = R(thX);
        MI = Rx * I_local * transpose(Rx);
        ang_acc = inv(MI) * tau;
    end

    function [lin_acc] = compute_linear_acceleration(q, t)
        v = [0; q(1); q(2)];
        r = [0; q(3); q(4)];
        wx = q(5);
        thX = q(6);
        mass = compute_rocket_mass_at_time(t);
        alpha = compute_alpha(v, thX);

        if (mass <= rocket_mass)
            Fp = [0; 0; 0];
        else
            Fp = compute_propulsion(r, thX, mass);
        end

        Fg = compute_gravitational(r, mass);
        Fvis = compute_friction(r, v, alpha);
        F = Fp + Fg + Fvis;
        lin_acc = F / mass;
    end

    function [g] = compute_g(q, t)
        v = [0; q(1); q(2)];
        lin_acc = compute_linear_acceleration(q, t);
        ang_acc = compute_angular_acceleration(q, t);
        g = [lin_acc(2), lin_acc(3), v(2), v(3), ang_acc(1), q(5)];
    end

    % Definitions of constants
    rocket_mass = 20 * 1000; % in kg
    fuel_mass = 300 * 1000; % in kg
    rocket_radius = rocket_cone_radius = rocket_cylinder_radius = 1.8; % in meters
    rocket_height = 53; % in meters
    earth_radius = 6371 * 1000; % in meters
    jets_position_x = 0;
    jets_position_y = 0;
    jets_position_z = 25; % in meters
    r_oxyz = [0; 0; -1 * jets_position_z]; % center of mass of the rocket with respect to its own referential.

    % Propulsion constants:
    mu = 1200; % in kg/s
    initial_v_gas = 3.5 * 1000; % in m/s

    % Gravitationnal Constants:
    G = 6.673 * 10^(-1 * 11); % in Nm^2/kg^2
    M_t = 5.974 * 10^24; % in kg

    % Friction variables and constants:
    alpha = 0;
    C_vis = 0.5;
    rho_0 = 1.275; % in kg/m^3
    h_0 = 7200; % in m;

    % Initial Rocket Values:
    r0 = [0; 0; earth_radius + jets_position_z]; % Rocket's center of mass w.r. to global referential in meters
    v0 = [0; 0; 0]; % Rocket's initial velocity. (Rocket is stationary at time 0 ergo the velocity is 0)
    w0x = 0; % Rocket's initial angular velocity with respect to the X axis. (Rocket is stationary at time 0 ergo the angular velocity is 0)
    thX = 0; % Rocket's initial angular displacement with respect to the X axis (Rocket is sitting still and thus has not rotated at moment 0).
    q = [v0(2), v0(3), r0(2), r0(3), w0x, thX];
    mass0 = rocket_mass;

    % Definition of final values
    t = [0];
    x = [r0(1)];
    y = [r0(2)];
    z = [r0(3)];

    completed = false;
    % Starting positions:
    dT = 0.01; % Set delta t to an arbitrairy value;
    snapshot_timer = dT * 100;
    printf("[*] Using deltaT: %f and recording the position of the rocket every: %f seconds.\n", dT, snapshot_timer);

    time = 0;
    time_since_last_snapshot = 0;

    iterations = 1;
    snapshots_saved = 1;
    printf("[*] Computing simulation...\n");

    while !completed
        % Update return arrays:
        time = time + dT;
        g = @compute_g;
        q = SEDRK4t0(q, time, dT, g);
        iterations = iterations + 1;
        r = [0; q(3); q(4)];
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

        completed = verify_completion([0; q(3); q(4)]);
    end

    if (iterations <= 100)
        printf("[!] Change deltaT, because snapshot count is too low...\n")
    end

    printf("[*] We have %i iterations\n", iterations)
    printf("[*] We have %i snapshots\n", snapshots_saved)
    Vf = [v0(1); q(1); q(2)];
end