function p= initialiseReParticles(np)
for i=1:np
    p(i).w= 1/np;
    p(i).xv= [0;0;0];
    p(i).xf= [];
    p(i).Pf= [];
end