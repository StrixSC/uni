% Patel, Pritam - 1933097
% Kim, Victor - 1954607
% Dao, Jean Huy - 1960503
% Mohammed Amin, Nawras - 1962832

function [pcm acm MI aa]=Devoir1(pos, ar, va, lambda)
  % Partie 1: La position du centre de masse

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

  masse_totale = sphere_masse + bras_masse*6 + moteur_masse*6 + colis_masse;

  % Position du centre de masse dans la situation initiale

  bras_cm_x = bras_masse * (bras1_cm_x + bras2_cm_x + bras3_cm_x + bras4_cm_x + bras5_cm_x + bras6_cm_x);
  moteur_cm_x = moteur_masse * (moteur1_cm_x + moteur2_cm_x + moteur3_cm_x + moteur4_cm_x + moteur5_cm_x + moteur6_cm_x);
  cm_x = (sphere_masse * sphere_cm_x + bras_cm_x + moteur_cm_x + colis_masse * colis_cm_x)/masse_totale

  bras_cm_y = bras_masse * (bras1_cm_y + bras2_cm_y + bras3_cm_y + bras4_cm_y + bras5_cm_y + bras6_cm_y);
  moteur_cm_y = moteur_masse * (moteur1_cm_y + moteur2_cm_y + moteur3_cm_y + moteur4_cm_y + moteur5_cm_y + moteur6_cm_y);
  cm_y = (sphere_masse * sphere_cm_y + bras_cm_y + moteur_cm_y + colis_masse * colis_cm_y)/masse_totale

  bras_cm_z = bras_masse * bras_cm_z * 6;
  moteur_cm_z = moteur_masse * moteur_cm_z * 6;
  cm_z = (sphere_masse * sphere_cm_z + bras_cm_z + moteur_cm_z + colis_masse * colis_cm_z)/masse_totale

  pcm_initial = transpose([cm_x, cm_y, cm_z])

  % Position du centre de masse dans la situation finale

  % Tiré du document de réference:
  R = [ cos(ar),   0, sin(ar);
        0,         1, 0;
        -sin(ar),  0, cos(ar); ];

  pcm = (R * pcm_initial) + pos



 % Partie 2: Le moment d'inertie

 % On calcul d'abord le moment d'inertie des sous-objets par rapport à leurs centre de masse
 % Colis:
 moment_inertie_colis = colis_masse * [
              (colis_longueur^2+colis_hauteur^2)/12, 0, 0;
              0, (colis_largeur^2+colis_hauteur^2)/12, 0;
              0, 0, (colis_longueur^2+colis_largeur^2)/12
            ];

 % Moteurs:

 moteur_intertie_xx_yy = (
  (moteur_masse/4*rayon_moteur^2) + (moteur_masse/12 * moteur_hauteur^2)
 );

 ar = 0.0;
 moment_inertie_moteur = [
              moteur_intertie_xx_yy, 0, 0;
              0, moteur_intertie_xx_yy, 0;
              0, 0, (moteur_masse/2 * rayon_moteur^2);
            ];

 % Bras:

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

 r_c = [cm_x, cm_y, cm_z];

 % I_c + mT(d_c)


  function [translated_inertia_matrix] =  translate_inertia(moment_matrix, object_mass, subobject_com)
    d_c = transpose(r_c) - subobject_com;
    X = 1;
    Y = 2;
    Z = 3;
    translated_inertia_matrix = moment_matrix + (object_mass * [
      d_c(Y)^2+d_c(Z)^2,-1*d_c(X)*d_c(Y),-1*d_c(X)*d_c(Z);
      -1*d_c(Y)*d_c(X),d_c(X)^2+d_c(Z)^2,-1*d_c(Y)*d_c(Z);
      -1*d_c(Z)*d_c(X),-1*d_c(Z)*d_c(Y),d_c(X)^2+d_c(Y)^2;
    ]);
  end

  inertia_moteur1 = translate_inertia(moment_inertie_moteur, moteur_masse, [moteur1_cm_x; moteur1_cm_y; moteur_cm_z]);
  inertia_moteur2 = translate_inertia(moment_inertie_moteur, moteur_masse, [moteur2_cm_x; moteur2_cm_y; moteur_cm_z]);
  inertia_moteur3 = translate_inertia(moment_inertie_moteur, moteur_masse, [moteur3_cm_x; moteur3_cm_y; moteur_cm_z]);
  inertia_moteur4 = translate_inertia(moment_inertie_moteur, moteur_masse, [moteur4_cm_x; moteur4_cm_y; moteur_cm_z]);
  inertia_moteur5 = translate_inertia(moment_inertie_moteur, moteur_masse, [moteur5_cm_x; moteur5_cm_y; moteur_cm_z]);
  inertia_moteur6 = translate_inertia(moment_inertie_moteur, moteur_masse, [moteur6_cm_x; moteur6_cm_y; moteur_cm_z]);

  inertia_moteurs_total = inertia_moteur1 + inertia_moteur2 + inertia_moteur3 + inertia_moteur4 + inertia_moteur5 + inertia_moteur6;

  inertia_bras1 = translate_inertia(moment_inertie_bras, bras_masse, [bras1_cm_x; bras1_cm_y; bras_cm_z]);
  inertia_bras2 = translate_inertia(moment_inertie_bras, bras_masse, [bras2_cm_x; bras2_cm_y; bras_cm_z]);
  inertia_bras3 = translate_inertia(moment_inertie_bras, bras_masse, [bras3_cm_x; bras3_cm_y; bras_cm_z]);
  inertia_bras4 = translate_inertia(moment_inertie_bras, bras_masse, [bras4_cm_x; bras4_cm_y; bras_cm_z]);
  inertia_bras5 = translate_inertia(moment_inertie_bras, bras_masse, [bras5_cm_x; bras5_cm_y; bras_cm_z]);
  inertia_bras6 = translate_inertia(moment_inertie_bras, bras_masse, [bras6_cm_x; bras6_cm_y; bras_cm_z]);

  inertia_bras_total = inertia_bras1 + inertia_bras2 + inertia_bras3 + inertia_bras4 + inertia_bras5 + inertia_bras6;

  inertia_demi_sphere = translate_inertia(moment_inertie_demi_sphere, sphere_masse, [sphere_cm_x; sphere_cm_y; sphere_cm_z]);
  inertia_colis = translate_inertia(moment_inertie_colis, colis_masse, [colis_cm_x; colis_cm_y; colis_cm_z]);

  I = inertia_moteurs_total + inertia_bras_total + inertia_demi_sphere + inertia_colis;

  % Utilisation de la matrice de rotation OY afin de calculer le moment d'inertie finale:

  % à commenter lorsque terminé:
  ar = 0.0;


  % I_g = R^(G<-L)*I^L*Transpose((R^(G<-L)))
  % Moment d'inertie du système globale = Matrice Rotation du système local vers le système global * Matrice du moment d'inertie du système local * transposée de la matrice de rotation
  % du système local vers le système global.

  MI = R * I * transpose(R)


  % Partie 3: Calcul de l'accélération angulaire

  % Moment de force
  force_max = 20;
  force_totale = lambda * force_max;
  moteur1_moment_force = cross(([moteur1_cm_x; moteur1_cm_y; moteur_cm_z] - pcm), [0; 0; force_totale(1)]);
  moteur2_moment_force = cross(([moteur2_cm_x; moteur2_cm_y; moteur_cm_z] - pcm), [0; 0; force_totale(2)]);
  moteur3_moment_force = cross(([moteur3_cm_x; moteur3_cm_y; moteur_cm_z] - pcm), [0; 0; force_totale(3)]);
  moteur4_moment_force = cross(([moteur4_cm_x; moteur4_cm_y; moteur_cm_z] - pcm), [0; 0; force_totale(4)]);
  moteur5_moment_force = cross(([moteur5_cm_x; moteur5_cm_y; moteur_cm_z] - pcm), [0; 0; force_totale(5)]);
  moteur6_moment_force = cross(([moteur6_cm_x; moteur6_cm_y; moteur_cm_z] - pcm), [0; 0; force_totale(6)]);

  moment_force = moteur1_moment_force + moteur2_moment_force + moteur3_moment_force + moteur4_moment_force + moteur5_moment_force + moteur6_moment_force

  % Moment cinetique
  L = MI * va;

  % Acceleration angulaire
  aa = MI\(moment_force + cross(L, va))

  % Return variables temporaires
  acm = [0; 0; 0];

end





