% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [Vf t x y z]=Devoir2(pos, ar, va, lambda)

% Definitions of constants
rocket_weight = 320; % in tonnes
fuel_weight = 270; % in tonnes
rocket_cone_radius = rocket_cylinder_radius = 1.8; % in meters
rocket_height= 53; % in meters
rocket_fuel_consumption = 3.5; % in km/s
earth_radius = 6371; % in km

% Definition of return values
  Vf= [0, 0, 0]
  t = [0, 0, 0]
  x = [0, 0, 0]
  y = [0, 0, 0]
  z = [0, 0, 0]

  function [is_completed] = verify_completion(rocket_com)
    first = rocket_com(1)^2 + rocket_com(2)^2 + rocket_com(3)^2 >= 10^14;
    second = rocket_com(1)^2 + rocket_com(2)^2 + rocket_com(3)^2 <= earth_radius^2;
    is_completed = first || second;
  end
  
  rocket_com_x = 0;
  rocket_com_y = 0;
  rocket_com_z = 0;

  while !verify_completion([rocket_com_x ; rocket_com_y ; rocket_com_z])
    rocket_com_x = 10^14; % Temporary condition to break while loop
  end

end
