%%
% Copyright(c) 2015 Ying li;Zuolei Sun;Yafang Xu;Bo Zhang -- Robot Navigation based on Visual 
% Feature Perception and Monte Carlo Sampling ( The 27th Chinese Control and Decision 
% Conference ).

% All rights reserved.

% Redistribution and use in source Code and data with or without modification must retain the above 
% copyright notice.

% Experiments are carried out based on real data make by Dr.Udo the dataset is collected from 
% the Deutsches Zentrum f¨¹r Luft-und Raumfahrt£¨DLR£©
% --- http://www.informatik.uni-bremen.de/agebv/en/DlrSpatialCognitionDataSet
%%
clear all; close all;
path(path, genpath('../../ccdc15'));
%%
load 'ccdc15\Data\DLR\landmark.mat';
load 'ccdc15\Data\Output\EKFobs4.mat'; % EKF estimated path.
xEKF    = data.path;
load 'ccdc15\Data\Output\IEKF2obs4.mat';% IEKF estimated path.
xIEKF   = data.path;
load 'ccdc15\Data\Output\errNumx.mat';% FastSLAM2 estimated path.
xerrNum50 = err.Num50;
xerrNum100 = err.Num100;
xerrNum200 = err.Num200;
xerrNum500 = err.Num500;
load 'ccdc15\Data\Output\errNminx.mat';%
xerrNmin58 = err.Nmin58;
xerrNmin68 = err.Nmin68;
xerrNmin78 = err.Nmin78;
xerrNmin88 = err.Nmin88;
load 'ccdc15\Data\Output\Num100.mat';% FastSLAM2 estimated path.
xFastSLAM   = data.path;
lmFastSLAM = data.pos;
load 'ccdc15\Data\Output\particlesRob.mat';% FastSLAM2 particles estimated path.
%To put particle set change form of easy draw
for k=1:3297
    for j=1:100
        i=100*(k-1)+j;
        pp(:,j,k)=Rob(:,:,i);
    end
end
%%
rob  =[0 -0.0025 -0.0025;0 0.00125 -0.00125];%size of robot
step = 3298;
images = dir('E:\Li Ying\ccdc15\Data\DLR\Images\*.jpg');
%%
makeVideo = 1;
%%
if makeVideo
    videoObj           = VideoWriter(sprintf('EKF IEKF and FastSLAM on DLR data.avi'));
    videoObj.FrameRate = 5;
    videoObj.Quality   = 100;
    open(videoObj);
end
%%
initFigure;
% axes(h.allAxes);
%%
for k = 1:step
        set(h.all,'CurrentAxes',h.simAxes); 
        if k~=1
            htext= ylabel({['Landmarks ID: ',num2str(landmark(k-1).ID)];...
                ['Step Number: ',num2str(k-1)]});
            set(htext,'Position',[-41 5],'color',[144,243,13]/255,'fontsize',11,'fontweight','bold',...
                    'fontangle','normal','HorizontalAlignment','left','verticalAlignment','top','Rotation',0);
        end
        FastSLAMRobBody = compound(xFastSLAM(:,k), rob);
        EKFRobBody = TransformToGlobal(rob,xEKF(1:3,k));
        IEKFRobBody = TransformToGlobal(rob,xIEKF(1:3,k));
%        
        %% robot and robot pose
        set(h.FastSLAMRob,  'xdata',FastSLAMRobBody(1,:), ...
            'ydata', FastSLAMRobBody(2, :));
        set(h.EKFRob,  'xdata', EKFRobBody(1,:), ...
            'ydata', EKFRobBody(2, :));
        set(h.IEKFRob,  'xdata', IEKFRobBody(1,:), ...
            'ydata', IEKFRobBody(2, :));
        set(h.FastSLAMPath,  'xdata',xFastSLAM(1,1:k), ...
            'ydata',xFastSLAM(2,1:k));
        set(h.EKFPath,  'xdata', xEKF(1,1:k), ...
            'ydata', xEKF(2,1:k));
        set(h.IEKFPath,  'xdata', xIEKF(1,1:k), ...
            'ydata', xIEKF(2,1:k));
        % Observed features
        if k~=1 && ~isempty(landmark(k-1).z)&&~isempty(lmFastSLAM(k-1).x)
            set(h.lmFastSLAM, 'xdata', lmFastSLAM(k).x(1,:),...
                'ydata', lmFastSLAM(k).x(2,:));
        end
        %particles
        if k~=1
             set(h.particles, 'xdata', pp(1,:,k-1),'ydata',pp(2,:,k-1));
        end       
      
        %% update the eagle eye.
        set(h.all,'CurrentAxes',h.eyeAxes);
        set(h.eye.EKFRob,  'xdata', EKFRobBody(1,:), ...
            'ydata', EKFRobBody(2, :));
        set(h.eye.IEKFRob,  'xdata', IEKFRobBody(1,:), ...
            'ydata', IEKFRobBody(2, :));
         set(h.eye.FastSLAMRob,  'xdata', FastSLAMRobBody(1,:), ...
            'ydata', FastSLAMRobBody(2, :));
        set(h.eye.EKFPath,  'xdata', xEKF(1,1:k), ...
            'ydata', xEKF(2,1:k));
        set(h.eye.IEKFPath,  'xdata', xIEKF(1,1:k), ...
            'ydata', xIEKF(2,1:k));
         set(h.eye.FastSLAMPath,  'xdata', xFastSLAM(1,1:k), ...
            'ydata', xFastSLAM(2,1:k));
        
        % Observed features
        if k~=1 &&~isempty(landmark(k-1).z)
            set(h.eye.lmFastSLAM, 'xdata',  lmFastSLAM(k).x(1,:),...
                'ydata',  lmFastSLAM(k).x(2,:));
        end
        if k~=1
             set(h.eye.particles, 'xdata', pp(1,:,k-1),'ydata',pp(2,:,k-1));
        end
            
        %%
        ax_eye= [xFastSLAM(1,k)- 0.01*h.eyelim.x, xFastSLAM(1,k)+0.01* h.eyelim.x,...
                   xFastSLAM(2,k)-0.01*h.eyelim.y,xFastSLAM(2,k)+ 0.01*h.eyelim.y]; 
        Xeye= [ax_eye(1) ax_eye(2) ax_eye(2) ax_eye(1) ax_eye(1)]; 
        Yeye= [ax_eye(4) ax_eye(4) ax_eye(3) ax_eye(3) ax_eye(4)];
        axis(h.eyeAxes,ax_eye); 
        set(h.eye.sim,'xdata',Xeye,'ydata',Yeye); 
        %%
        set(h.all,'CurrentAxes',h.errNumAxes)
        set(h.errNum50, 'xdata', 1:k ,'ydata',xerrNum50(1,1:k));
        set(h.errNum100, 'xdata', 1:k ,'ydata',xerrNum100(1,1:k));
        set(h.errNum200, 'xdata', 1:k ,'ydata',xerrNum200(1,1:k));
        set(h.errNum500, 'xdata', 1:k ,'ydata',xerrNum500(1,1:k));
        %%
        set(h.all,'CurrentAxes',h.errNminAxes)
        set(h.errNmin58, 'xdata', 1:k ,'ydata',xerrNmin58(1,1:k));
        set(h.errNmin68, 'xdata', 1:k ,'ydata',xerrNmin68(1,1:k));
        set(h.errNmin78, 'xdata', 1:k ,'ydata',xerrNmin78(1,1:k));
        set(h.errNmin88, 'xdata', 1:k ,'ydata',xerrNmin88(1,1:k));
        drawnow;
        hold on;
        %% Images
        if k ~= 1
            a = imread(images(k-1).name);
            set(h.all,'CurrentAxes',h.imgAxes);
            imagesc([0 596],[298 50],a,'alphadata',1);
            colormap(gray);
        end
        %%
        if k~=1 && makeVideo && mod(k-1, 3) == 0 

            writeVideo(videoObj, getframe(h.all));
        end
end
%%
if makeVideo
        close(videoObj);
end
