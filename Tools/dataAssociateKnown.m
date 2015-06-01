function [zf,idf,Rf,zn,Rn,cList]= dataAssociateKnown(z, R, idz, cList, Nf)
% initialization vector
zf= []; zn= [];
idf= []; idn= [];
Rf = [];  Rn = [];
% find associations (zf) and new features (zn)
for i=1:length(idz)
    ii= idz(i);
    j   = 2*i + (-1:0);
    if cList(ii) == 0 
        zn= [zn z(:,i)];%new feature 
        idn= [idn ii];
        Rn  = [Rn R(:,j)];%observed new feature orresponding to error
    else
        zf= [zf z(:,i)];%old feature
        idf= [idf cList(ii)];
        Rf  = [Rf R(:,j)];%observed  old feature orresponding to error
    end
end


   %% Add new features order to corresponding list
    cList(idn) = Nf + (1:size(zn,2)); % add new observations' index

    
  


