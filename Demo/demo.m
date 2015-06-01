% The demo for the paper Robot Navigation based on Visual Feature Perception
% and Monte Carlo Sampling (The 27th Chinese Control and Decision Conference).
% 
% Ying Li; Zuolei Sun; Yafang Xu; Bo Zhang
% 
% The data is made by Dr.Udo available at
% 
% http://www.informatik.uni-bremen.de/agebv/en/DlrSpatialCognitionDataSet
% 
% For more information, please conect: sunzuolei@gmail.com
%%
dbstop if error;
clear; close all; clc;
rng(7777); % Control random number generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path(path, genpath('../../ccdc15')); 
load 'ccdc15/Data/DLR/truth.mat';
load 'ccdc15/Data/DLR/relMotion.mat'; % robot odometry data in DLR
load 'ccdc15/Data/DLR/landmark.mat';  % observations in DLR.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% switches
visualize = 1;
%% parametres configuration
step = 3297;
NPARTICLES=100;% number of sample particles
% initialisations
particles= initialiseParticles(NPARTICLES,step);%All sampling particle initialization
re_particles= initialiseReParticles(NPARTICLES);%Resampling particles initialization
pos = zeros(3, step);%To robot pose to allocate memory
xv = truth.x(:,1); 
Pv = truth.P(:,:,1);
% particles_xv = [];
for i = 1:NPARTICLES
    particles(i,1).xv = xv;   % robot initial pose.
    particles(i,1).xv(3)= xv(3)+0.065 ;  % modify the heading.
    particles(i,1).Pv= Pv;    % Initial covariance.
end
% p = 1;
%% assign memory and Initialise.
data.path = zeros(3, step+1 ); % assign memory for estimated path.
 % state include robot and landmarks.
data.path(:,1) = particles(1,1).xv  ;
data.pos(1).x  = particles(1,1).xf;
idList   = zeros(1,23001);       % assign memory for corresponding list.

disp('Processing, it will take 20 minutes and 4GB memory at least');
disp('If no more than 4GB free memory available, your Matlab must be crashed soon :(')
% Main loop 
tic;
%%
for i = 1:step
    fprintf('.');
    if mod(i, 30) == 0
        fprintf('\n');
    end
    
     %load 'ccdc15/Data/Output/filename.mat';
    for j=1:NPARTICLES
     %% predict simulation
         if i == 1
           particles(j,i)= predict2(particles(j,i), relMotion(i).x, relMotion(i).P);
         else
            particles(j,i)= predict2(particles(j,i-1), relMotion(i).x, relMotion(i).P);
        end
%         particles(i)= observe_heading(particles(i), xtrue(3), SWITCH_HEADING_KNOWN); % if heading known, observe heading

    end
   %% Observe step
        % Compute (known) data associations
            if i==1
               Nf= size(particles(1,i).xf,2);
            else
               Nf= size(particles(1,i-1).xf,2); %The number of landmarks on the map
            end
        [zf, idf, Rf, zn, Rn, idList] = dataAssociateKnown(landmark(i).z,...
                                  landmark(i).R, landmark(i).ID, idList, Nf);  
        % Observe map features
        if ~isempty(zf) 
          % sample from "optimal" proposal distribution, then update map 
            for j=1:NPARTICLES
                particles(j,i)= sampleProposal(particles(j,i), zf,idf, Rf); 
                particles(j,i)= featureUpdate(particles(j,i), zf, idf, Rf);
            end
            % resample
            % Variable substitution is to satisfy the requirement of variable function resample_particles
            re_particles = particles(:,i);
            re_particles= resampleParticles( re_particles, 0.68*NPARTICLES); 
            particles(:,i)= re_particles;          
        end
        % Observe new features, augment map
        if ~isempty(zn)
            for j=1:NPARTICLES
                if isempty(zf) % sample from proposal distribution (if we have not already done so above)
                    particles(j,i).xv= multivariateGauss(particles(j,i).xv, particles(j,i).Pv, 1);
                    particles(j,i).Pv= zeros(3);
                end                        
                particles(j,i)= addFeature(particles(j,i), zn, Rn);
            end
        end
end
%% store data 
   for i=1:step
%        filename = [particles num2str(i)]; 
%        load 'ccdc15/Data/Output/filename.mat';
       %i moment robot pose  through the moment of all the sampling particles pose weighted and representative
       for j = 1:NPARTICLES
%           In order to pose the sampling particles into a function save can be used to store the form
%            Rob(:,:,p) = particles(j,i).xv;
%            p = p+1;
%%
          pos(:,i) = pos(:,i) + particles(j,i).xv * particles(j,i).w;
       end          
          M= size(particles(1,i).xf,2); %The robot to move to step i observed number of landmarks
          lm(i).xf = zeros(2,  M);%The landmarks to allocate memory for the step i detected
     for k = 1: M
         %The landmark for the k position is through all the sampling particles detected weighted the landmark and representation
         for j = 1:NPARTICLES        
             lm(i).xf(:,k)=lm(i).xf(:,k)+particles(j,i).xf(:,k)*particles(j,i).w;
         end
     end
        data.path(:,i+1) = pos(:,i); % convenient for animation
        data.pos(i+1).x=lm(i).xf;
   end
   %%
%    Data storage is convenient other drawing need
%    save Nmin88 data;
%    save particlesRob Rob;
%%
     toc;
 %% animation.
vis(data, truth, step, visualize);   
