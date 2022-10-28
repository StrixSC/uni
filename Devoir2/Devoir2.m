% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [Vf t x y z] = Devoir2(theta)

    % Definitions of constants
    rocket_mass = 320 * 1000; % in kg
    fuel_mass = 300 * 1000; % in kg
    rocket_radius = rocket_cone_radius = rocket_cylinder_radius = 1.8; % in meters
    rocket_height = 53; % in meters
    earth_radius = 6371 * 1000; % in meters
    jets_position_x = 0;
    jets_position_y = 0;
    jets_position_z = 25; % in meters

    % Tiré du document de référence. 
    R = [
        cos(theta), -sin(theta),0;
        sin(theta), cos(theta), 0;
        0,0,1;
      ];

    % Propulsion constants:
    mu = 1200; % in kg/s
    initial_v_gas = 3.5 * 1000; % in m/s

    % Gravitationnal Constants:
    G = 6.673 * 10^(-1 * 11); % in Nm^2/kg^2
    M_t = 5.974 * 10^24; % in kg

    % Friction variables and constants:
    alpha = 30; % TODO
    C_vis = 0.5;
    rho_0 = 1.275; % in kg/m^3
    h_0 = 7200; % in m;

    % Initial Rocket Values:
    r = [0; 0; earth_radius + jets_position_z]; % Rocket's center of mass w.r. to global referential in meters

    % Definition of final values
    t = [0];
    x = [r(1)];
    y = [r(2)];
    z = [r(3)];

    function [is_completed] = verify_completion(counter, rocket_CoM)
        d = rocket_CoM(1)^2 + rocket_CoM(2)^2 + rocket_CoM(3)^2;
        is_completed = d >= 10^14 || d <= earth_radius^2;
    end

    function [Fp] = compute_propulsion(theta)
        v_gas = -1 * initial_v_gas * [0; sin(theta); cos(theta)];
        Fp = -1 * mu * v_gas; % do * 1000 to convert to kg*m/s^2 (Newtons) ;
    end

    function [Fg] = compute_gravitational(rocket_CoM)
        g = -1 * G * M_t * (rocket_CoM / (norm(rocket_CoM)^3));
        Fg = rocket_mass * g;
    end

    function [Fvis] = compute_friction(v, r)
        A = (pi * rocket_radius^2 * cos(alpha)) + (2 * rocket_radius * rocket_height * sin(alpha));
        rho = rho_0 * exp(1)^((earth_radius - norm(r)) / h_0);
        Fvis = -1 * 1/2 * A * rho * C_vis * norm(v) * v;
    end

    function [a] = compute_acceleration(theta, velocity, rocket_CoM)
        Fp = compute_propulsion(theta);
        Fg = compute_gravitational(rocket_CoM);
        Fvis = compute_friction(velocity, rocket_CoM);
        F = Fp + Fg + Fvis;
        a = F / rocket_mass;
    end

    function [g] = compute_g(q, t)
        velocity = [q(1); q(2); q(3)];
        rocket_CoM = [q(4); q(5); q(6)];
        a = compute_acceleration(theta, velocity, rocket_CoM);
        g = [a(1); a(2); a(3); velocity(1); velocity(2); velocity(3)];
    end

    function [m] = compute_rocket_mass_at_time(t) 
      m = 320 * 1000 - 1200 * t;
    end

    function [MI] = compute_moment_of_inertia(t) 
      rocket_mass = compute_rocket_mass_at_time(t);
      I_zz = rocket_mass/2 * rocket_radius^2;
      I_xx = I_yy = (rocket_mass/4 * rocket_radius^2)+(rocket_mass/12 * rocket_height^2);
      I = [
        I_xx, 0, 0;
        0, I_yy, 0;
        0, 0, I_zz;
      ];
      MI = R*I*transpose(R);
    end

    dT = 0.1; % Set delta t to an arbitrairy 0.01 seconds.
    current_q = [0; 0; 0; x(1); y(1); z(1); ];
    current_t = 0;
    previous_q = [0; 0; 0; 0; 0; 0];
    previous_t = 0;
    current_rocket_CoM = [x(1); y(1); z(1)];
    counter = 0;
    printf("Computing simulation...");

    while !verify_completion(counter, current_rocket_CoM)
        velocity_vector = [previous_q(1); previous_q(2); previous_q(3)];
        if (norm(velocity_vector))
            alpha = asin(previous_q(3) / norm(velocity_vector));
        else
            alpha = 0;
        end

        previous_q = current_q;
        previous_t = current_t;
        counter = counter + 1;
        k1 = compute_g(previous_q, previous_t);
        k2 = compute_g(previous_q + (dT / 2 * k1), previous_t + dT / 2);
        k3 = compute_g(previous_q + (dT / 2 * k2), previous_t + dT / 2);
        k4 = compute_g(previous_q + (dT * k3), previous_t + dT / 2);
        current_q = previous_q + (dT * (k1 + (2 * k2) + (2 * k3) + k4)) / 6;
        current_rocket_CoM = [current_q(4), current_q(5), current_q(6)];

        % Update values:
        x = [x; current_rocket_CoM(1)];
        y = [y; current_rocket_CoM(2)];
        z = [z; current_rocket_CoM(3)];
        t = [t; current_t];
        current_t = current_t + dT;
        masse_totale = compute_rocket_mass_at_time(t(end));
        % if (masse_totale <= rocket_mass - fuel_mass)
        % end
    end

    if (counter < 100)
        printf("Number of increments does not reach past 100...");
    elseif (counter > 1000)
        printf("Number of increments is above 1000...");
    end

    Vf = [current_q(1); current_q(2); current_q(3)];

end
