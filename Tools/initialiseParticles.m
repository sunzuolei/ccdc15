function p= initialiseParticles(np,step)
for i=1:step
    for j=1:np
        p(j,i).w= 1/np;
        p(j,i).xv= [0;0;0];
        p(j,i).Pv= zeros(3);
        p(j,i).xf= [];
        p(j,i).Pf= [];
    end
end