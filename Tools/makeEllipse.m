function p= makeEllipse(x,P,circ)
% make a single 2-D ellipse 
r= sqrtm2by2(P);
a= r*circ;
p(2,:)= [a(2,:)+x(2) NaN];
p(1,:)= [a(1,:)+x(1) NaN];