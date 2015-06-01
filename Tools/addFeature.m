function particle= addFeature(particle, z, Rn)
% add new features 
lenz= size(z,2);
xf= zeros(2,lenz);
Pf= zeros(2,2,lenz);
xv= particle.xv;

for i=1:lenz
    lx= z(1,i);
    ly= z(2,i);
    j= 2*i-1;
    R = Rn(1:2,j:j+1);
    s= sin(xv(3)); 
    c= cos(xv(3));
      %% Jacobians
        Gv = [1 0  -lx*s-ly*c;
              0 1  lx*c-ly*s];
        Gz = [c   -s;
              s    c];
       %% Augment state
         xf(:,i) = [xv(1) + lx*c - ly*s;
                    xv(2) + lx*s + ly*c];
         Pf(:,:,i)= Gz*R*Gz';   
end

lenx= size(particle.xf,2);
ii= (lenx+1):(lenx+lenz);
particle.xf(:,ii)= xf;
particle.Pf(:,:,ii)= Pf;








