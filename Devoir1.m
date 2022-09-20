% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
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


 % Partie 2: Le moment d'inertie

 % On commence par le calcul du moment d'inertie des composantes individuelles
 % par rapport à leurs propres centre de masse

 % Colis:
 moment_inertie_colis = colis_masse * [
              (colis_longueur^2+colis_hauteur^2)/12, 0, 0;
              0, (colis_largeur^2+colis_hauteur^2)/12, 0;
              0, 0, (colis_longueur^2+colis_largeur^2)/12
            ];

 % Moteurs:
 % Chaque moteurs est représenté par un cylindre plein
 moteur_intertie_xx_yy = (
  (moteur_masse/4*rayon_moteur^2) + (moteur_masse/12 * moteur_hauteur^2)
 );

 moment_inertie_moteur = [
              moteur_intertie_xx_yy, 0, 0;
              0, moteur_intertie_xx_yy, 0;
              0, 0, (moteur_masse/2 * rayon_moteur^2);
            ];

 % Bras:
 % Chaque bras est représenté par un cylindre creux

 bras_inertie_xx_yy = (
  (bras_masse/2 * bras_rayon^2) + (bras_masse/12 * bras_longueur^2)
 );
 moment_inertie_bras = [
        bras_inertie_xx_yy, 0, 0;
        0, bras_inertie_xx_yy, 0;
        0, 0, (bras_masse/2 * bras_rayon^2);
      ];

 % Demi-Sphere:
 moment_inertie_demi_sphere = (sphere_masse * sphere_rayon^2) * [
                                83/320, 0, 0;
                                0, 83/320, 0;
                                0, 0, 2/5;
                              ];

 % Translation des moments d'inerties calculée pour chaque partie afin d'avoir
 % le moment d'inertie selon le centre de masse du drone, plutôt que selon leurs
 % centre de masse.

 % Colis:




