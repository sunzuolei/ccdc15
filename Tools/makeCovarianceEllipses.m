function p= makeCovarianceEllipses(x,P)
N= 10;
inc= 2*pi/N;
phi= 0:inc:2*pi;
circ= 2*[cos(phi); sin(phi)];

p= makeEllipse(x(1:2), P(1:2,1:2) + eye(2)*eps, circ);
