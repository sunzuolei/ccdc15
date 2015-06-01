
function dx = deltaXv(xv1, xv2)
% Compute innovation between two xv estimates, normalising the heading component
dx = xv1 - xv2;
dx(3,:) = piTopi(dx(3,:));