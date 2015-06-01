function particle= predict2(particle, dr, Q)
%
% INPUTS:
%   dr - Robot movement control volume
%   Q - covariance of dr
xv= particle.xv;
Pv= particle.Pv;
s= sin( xv(3));
c= cos( xv(3));

% Jacobians     
phi= xv(3);
Fxr=  [1 0 (-s*dr(1)-c*dr(2));
       0 1  (c*dr(1)-s*dr(2));
       0 0                 1];
    Fdr= [c -s 0;
          s  c 0;
          0  0 1]; 

% predict particle pose and covariance
particle.Pv= Fxr*Pv*Fxr' + Fdr*Q*Fdr';
dr= multivariateGauss(dr, Q, 1);%Sampling
 %% Predict particle pose.
particle.xv= [xv(1) + c*dr(1)-s*dr(2);
              xv(2) + s*dr(1)+c*dr(2);
              piTopi( xv(3) + dr(3))];
               

