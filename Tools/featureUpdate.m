function particle= featureUpdate(particle, z, idf, Rf)
% Having selected a new pose from the proposal distribution, this pose is assumed
% perfect and each feature update may be computed independently and without pose uncertainty.

 %% Arrange to block for more efficency in computition.  
     [zp, Hv, Hf,Sf] = computeJacobians(particle, idf, Rf);            
    for i=1:length(idf)
        v(:,i)  = [z(1,i) - zp(1,i);
                   z(2,i) - zp(2,i)];
       j  = 2*i + (-1:0);
       vi= v(:,i);
       Hfi= Hf(:,:,i);
       Pfi=particle.Pf(:,:,idf(i));
       xfi=particle.xf(:,idf(i));
       R= Rf(:,j);
      [particle.xf(:,idf(i)),particle.Pf(:,:,idf(i))]= kfCholeskyUpdate(xfi,Pfi,vi,R,Hfi);
    end
  
    
  

