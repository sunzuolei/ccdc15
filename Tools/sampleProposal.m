function particle= sampleRroposal(particle, z,idf, R)
% Compute proposal distribution, then sample from it, and compute new particle weight.
xv= particle.xv;
Pv= particle.Pv;
xv0= xv;
Pv0= Pv;
% process each feature, incrementally refine proposal distribution
 [zp, Hv, Hf,Sf] = computeJacobians(particle, idf, R);
for i=1:length(idf)
    zpi=zp(:,i);
    Hvi=Hv(:,:,i);
    Hfi=Hf(:,:,i);
    Sfi=Sf(:,:,i);
    Sfi= inv(Sfi); 
    vi= z(:,i)-zpi; 
    Pv= inv(Hvi' * Sfi * Hvi + inv(Pv)); % proposal covariance
    xv= xv + Pv * Hvi' * Sfi * vi; % proposal mean
    particle.xv= xv;
    particle.Pv= Pv;
end
% sample from proposal distribution
xvs= multivariateGauss(xv,Pv,1); 
particle.xv= xvs;
% Note: particle.Pv must be zeroed after each observation. It accumulates the
% particle pose uncertainty between measurements.
particle.Pv= zeros(3);
% compute sample weight: w = w * p(z|xk) p(xk|xk-1) / proposal
like = likelihoodGivenXv(particle, z,idf, R);
prior = gaussEvaluate(deltaXv(xv0,xvs), Pv0);
prop =  gaussEvaluate(deltaXv(xv, xvs), Pv);
particle.w = particle.w * like * prior / prop;
%%In order to prevent the weight of  particle is too small and the computer
%will be regarded as zero
 if particle.w < eps
    particle.w = particle.w + eps;
 end

