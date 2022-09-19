% Pritam Patel - 1933097
% Victor Kim - 1954607
% Jean Huy Dao - 1960503
% Mohammed Amin, Nawras - 1962832

function [pcm acm MI aa]=Devoir1(pos,ar,va,lambda)

  %matrice_rotation_x = [ cos(ar),  0, sin(ar);
  %                       0,        1, 0;
  %                      -sin(ar),  0, cos(ar); ];

  % Demie sphere pleine (corps du drone)
  sphere_masse = 1.5;
  sphere_rayon = 0.30;

  sphere_cm_x = 0;
  sphere_cm_y = 0;
  sphere_cm_z = 3*sphere_rayon / 8;


  % Cylindre creux (bras du drone)
  bras_longueur = 0.5;
  bras_masse = 0.2;
  bras_rayon = 0.025;
  angle_separation = 60;

  bras1_cm_x = sphere_rayon + bras_longueur/2;
  bras2_cm_x = bras1_cm_x*cosd(60);
  bras3_cm_x = -bras2_cm_x;
  bras4_cm_x = -bras1_cm_x;
  bras5_cm_x = bras3_cm_x;
  bras6_cm_x = bras2_cm_x;

  bras1_cm_y = 0;
  bras2_cm_y = bras1_cm_x*sind(60);
  bras3_cm_y = bras2_cm_y;
  bras4_cm_y = 0;
  bras5_cm_y = -bras2_cm_y;
  bras6_cm_y = -bras2_cm_y;

  bras_cm_z = bras_rayon;


 % Cylindre pleins (moteurs du drone)
  moteur_hauteur = 0.10;
  moteur_masse = 0.4;
  rayon_moteur = 0.05;

  moteur1_cm_x = sphere_rayon + bras_longueur + rayon_moteur;
  moteur2_cm_x = moteur1_cm_x*cosd(60);
  moteur3_cm_x = -moteur2_cm_x;
  moteur4_cm_x = -moteur1_cm_x;
  moteur5_cm_x = moteur3_cm_x;
  moteur6_cm_x = moteur2_cm_x;

  moteur1_cm_y = 0;
  moteur2_cm_y = moteur1_cm_x*sind(60);
  moteur3_cm_y = moteur2_cm_y;
  moteur4_cm_y = 0;
  moteur5_cm_y = -moteur2_cm_y;
  moteur6_cm_y = -moteur2_cm_y;

  moteur_cm_z = moteur_hauteur/2;

  % Colis
  colis_masse = 0.8;
  colis_longueur = 0.7;
  colis_largeur = 0.4;
  colis_hauteur = 0.3;
  colis_cm_x = 0;
  colis_cm_y = 0.1;
  colis_cm_z = -0.15;

  % Masse totale
  masse_totale = sphere_masse + bras_masse*6 + moteur_masse*6 + colis_masse

  % Position du centre de masse
  bras_cm_x = bras_masse * (bras1_cm_x + bras2_cm_x + bras3_cm_x + bras4_cm_x + bras5_cm_x + bras6_cm_x);
  moteur_cm_x = moteur_masse * (moteur1_cm_x + moteur2_cm_x + moteur3_cm_x + moteur4_cm_x + moteur5_cm_x + moteur6_cm_x);
  cm_x = (sphere_masse * sphere_cm_x + bras_cm_x + moteur_cm_x + colis_masse * colis_cm_x)

  bras_cm_y = bras_masse * (bras1_cm_y + bras2_cm_y + bras3_cm_y + bras4_cm_y + bras5_cm_y + bras6_cm_y);
  moteur_cm_y = moteur_masse * (moteur1_cm_y + moteur2_cm_y + moteur3_cm_y + moteur4_cm_y + moteur5_cm_y + moteur6_cm_y);
  cm_y = (sphere_masse * sphere_cm_y + bras_cm_y + moteur_cm_y + colis_masse * colis_cm_y)

  bras_cm_z = bras_masse * bras_cm_z * 6;
  moteur_cm_z = moteur_masse * moteur_cm_z * 6;
  cm_z = (sphere_masse * sphere_cm_z + bras_cm_z + moteur_cm_z + colis_masse * colis_cm_z)

