function w = likelihoodGivenXv(particle, z,idf, R)
% For FastSLAM, p(z|xv) requires the map part to be marginalised from p(z|xv,m)
w = 1;
    [zp,Hv,Hf,Sf]= computeJacobians(particle, idf, R);
for i=1:length(idf)
    v(:,i)= z(:,i)-zp(:,i); %innovation
    w = w * gaussEvaluate(v(:,i),Sf(:,:,i));
end