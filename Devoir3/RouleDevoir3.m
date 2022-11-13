%
% Definir terrain
%
xsol=[-0.25   0.5   0.5   -0.25   -0.25];
ysol=[-0.25   -0.25   0.5   0.5   -0.25];
zsol=[0   0   0   0   0];
Pos0=[0; 0; 1];

for vit=1:4
  clf;
  hold;
  xlabel('x(m)');
  ylabel('y(m)');
  zlabel('z(m)');
%
%  Tracer terrain 
%
  fprintf('\nSimulation %3d\n',vit);
%Lancer 1
  if vit==1
    V0=[0.5;0;0.5];
    W0=[0.1;0.1;0];
    MatR0=[1,0,0;0,1,0;0,0,1];
  elseif vit==2
%Lancer 2
    V0=[0.6;0;0.5];
    W0=[0.1;0.1;0];
    MatR0=[1,0,0;0,1,0;0,0,1];
  elseif vit==3
%Lancer 3
    V0=[0.5;0;0.5];
    W0=[0.2;0.1;0];
    MatR0=[1,0,0;0,1,0;0,0,1];
  else
%Lancer 4 
    V0=[0.5;0;0.5];
    W0=[0.1;0.1;0];
    MatR0=[0.5,0.83205029,0.2401922;0.75,-0.5547002,0.3602883;0.4330127,0,-0.9013878];
  endif
  fprintf('V0 (m/s)= (%8.4f,%8.4f,%8.4f)  \n',V0(1),V0(2),V0(3));
  fprintf('W0 (r/s)= (%8.4f,%8.4f,%8.4f)  \n',W0(1),W0(2),W0(3));
  axis equal;
  plot3(xsol,ysol,zsol,'color','g');
  plot3(Pos0(1),Pos0(2),Pos0(3),'r+');
  [face tt xx yy zz sommet]=Devoir3(Pos0, MatR0, V0, W0);
  sz=size(tt,2);
  Sx=sommet(1,:);
  Sy=sommet(2,:);
  Sz=sommet(3,:);
  xsommet=[Sx(1),Sx(2),Sx(3),Sx(4),Sx(1),Sx(5),Sx(6),Sx(7),Sx(8),Sx(5)];
  ysommet=[Sy(1),Sy(2),Sy(3),Sy(4),Sy(1),Sy(5),Sy(6),Sy(7),Sy(8),Sy(5)];
  zsommet=[Sz(1),Sz(2),Sz(3),Sz(4),Sz(1),Sz(5),Sz(6),Sz(7),Sz(8),Sz(5)];
%  Posf1=(sommet(:,1)+sommet(:,2)+sommet(:,3)+sommet(:,4))/4; % position du centre de la face 1 est la moyenne des positions des sommets 1,2,3 et4
  plot3(xx(1:sz),yy(1:sz),zz(1:sz),'b');
  plot3(xsommet,ysommet,zsommet,'color','r');
  plot3([Sx(2),Sx(6)],[Sy(2),Sy(6)],[Sz(2),Sz(6)],'color','r');
  plot3([Sx(3),Sx(7)],[Sy(3),Sy(7)],[Sz(3),Sz(7)],'color','r');
  plot3([Sx(4),Sx(8)],[Sy(4),Sy(8)],[Sz(4),Sz(8)],'color','r');
%  plot3(Posf1(1),Posf1(2),Posf1(3),'b+');
  fprintf('Temps final          %10.6f s \n',tt(sz));
  fprintf('Position finale du d�    (%8.4f,%8.4f,%8.4f)  m \n',xx(sz),yy(sz),zz(sz));
  fprintf('\n\n');
  hold;
  pause;
end
