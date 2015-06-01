function [z, Hv, Hf,Sf] = computeJacobians(particle, idf, R)
   %%
   xv= particle.xv;  
   % observed all old feature need to traverse of particle  
   for i=1:length(idf)
       xf= particle.xf(:,idf(i));
       Pf= particle.Pf(:,:,idf(i));
       j  = 2*i + (-1:0);
       dx= xf(1)-xv(1);
       dy= xf(2)-xv(2);
       c   = cos(xv(3));
       s   = sin(xv(3));
       rot = [ c s;
              -s c];
       %% Predict measurements.
       z(:,i) =  rot * [dx;dy];
       %% Calculate H
       Hv(:,:,i) = [-c  -s  -s*dx+c*dy;   % Jacobian wrt vehicle states
                    s  -c  -c*dx-s*dy];
       Hf(:,:,i) = [ c   s;   -s   c];   % Jacobian wrt feature states
       Sf(:,:,i)= Hf(:,:,i) * Pf * Hf(:,:,i)' + R(:,j); % innovation covariance of 'feature observation given the vehicle'
       xf=[];
       Pf=[];
  end

