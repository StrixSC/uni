% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [Vf t x y z]=Devoir2(pos, ar, va, lambda)

% Definitions of constants
rocket_mass = 320; % in tonnes
fuel_mass = 270; % in tonnes
rocket_radius = rocket_cone_radius = rocket_cylinder_radius = 1.8/1000; % in km
rocket_height= 53/1000; % in km
earth_radius = 6371; % in km
jets_position_x = 0;
jets_position_y = 0;
jets_position_z = 0 - 25/1000;

% Propulsion constants:
mu = 1200 % in kg/s
initial_v_gas = 3.5; % in km/s

% Gravitationnal Constants:
G = 6.673 * 10^(-1 * 11); % in Nm^2/kg^2
M_t = 5.974 * 10^24; % in kg

% Friction constants:
C_vis = 0.5;
initial_rho = 1.275 % in kg/m^3
initial_h = 7200 % in m;


% Initial Rocket Values: 
  rocket_initial_velocity = [0; 0; 0]
  rocket_com = [0; 0; earth_radius + rocket_height/2]; % Global referential
  rocket_initial_acceleration = 0;

% Definition of final values
  Vf= [0, 0, 0]
  t = [0, 0, 0]
  x = [0, 0, 0]
  y = [0, 0, 0]
  z = [0, 0, 0]

  function [is_completed] = verify_completion(rocket_com)
    d = rocket_com(1)^2 + rocket_com(2)^2 + rocket_com(3)^2;
    is_completed =  d >= 10^14 || d <= earth_radius^2;
  end
  
  function [Fp] = compute_propulsion(incline_angle)
    v_gas = -1 * abs(initial_v_gas) * [0 ; sin(incline_angle) ; cos(incline_angle)];
    Fp  = -1 * mu * v_gas;
  end 

  function [Fg] = compute_gravitational(rocket_com)
    g = -1 * G * M_t * (r / (norm(rocket_com)^3))
    Fg = rocket_mass * g;
  end

  function [Fvis] = compute_friction(alpha)
    A = (pi * rocket_radius^2 * cos(alpha)) + (2 * rocket_radius * rocket_height * sin(alpha));
    p = initial_rho*exp(1)^(earth_radius)
  end

  %%% Uncomment the following three lines to start the simulation: 
  % while !verify_completion([rocket_com_x ; rocket_com_y ; rocket_com_z])
  % end
end
