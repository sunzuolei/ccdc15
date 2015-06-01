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
dbstop if error;
clear all; close all;
path(path, genpath('../../ccdc15'));
load 'ccdc15\Data\DLR\landmark.mat';
load 'ccdc15\Data\Output\N100.mat';% FastSLAM estimated path data.
xFastSLAM   = data.path;
lmFastSLAM = data.pos;
load 'ccdc15\Data\Output\particlesxv.mat';% particles of FastSLAM2.0 on DLR data  estimated path.
for k=1:3297
    for j=1:100
        i=100*(k-1)+j;
        pp(:,j,k)=Rob(:,:,i);
    end
end
I = imread('ccdc15\Data\DLR\Maps\satelliteMap.png','PNG'); % read the DLR satellite map.
rob  =[0 -0.0025 -0.0025;0 0.00125 -0.00125];
 step = 3298;
 cov = [];
 h.all = figure(1);clf;
pos   = get(0,'ScreenSize');
 set(h.all, 'position',  pos, 'color', 'w','Menu', 'none')
xmin = 0; xmax = 1364; ymin = 0; ymax = 768;%
wp_sim=1280; hp_sim = 720; hp_img = 48;% hp_img is the height of image and the unit is pixel.
l_sim = 0.01; 
b_sim = hp_img/(ymax-ymin); 
w_sim = wp_sim/(xmax-xmin); h_sim = hp_sim/(ymax-ymin);
h.simAxes = axes('Position', [l_sim b_sim w_sim h_sim]);
 hold on;
image([-59 37],[34 -47.5],I,'alphadata',1);
axis([-59 37 -47.5 34]);
set(gca,'xtick',[],'ytick',[]); % 
set(gca,'Color','w','XColor','w','YColor','w')
h.FastSLAMPath = plot (0, 0, 'color','g', ...
    'linestyle', '-', 'linewidth',2,'erasemode','normal'); 
h.lmFastSLAM = plot (0, 0, 'm.','linewidth', 2.5, 'erasemode','normal');
h.particles = plot (0, 0, 'c.','linewidth', 2.5, 'erasemode','normal');
h.cov =plot (0, 0, 'color','r','linestyle', '-', 'linewidth',2,...
    'erasemode','normal'); 
h.eye.sim =line(0,0,'linestyle','-','color','b','linewidth',2,'erasemode','normal');
h.FastSLAMRob  = patch('Faces',[1,2], 'linewidth',1.5,'markeredgecolor','b',...
    'facecolor','y','erasemode', 'normal'); 
FastSLAMrob_  = plot(1000,1000,'<','markersize',10,'markeredgecolor','b',...
  'markerfacecolor','y','linewidth',1.5);
FastSLAMpath_ = plot(1000,1000,'g-','linewidth',2);
lm_       = plot(1000,1000,'m.','linewidth',2.5);
particles_       = plot(1000,1000,'c.','linewidth',3);
cov_       = plot(1000,1000,'r','linewidth',2.5);
eye_ = plot(1000,1000,'s','markersize',10,'color','b','linewidth',2.5);
%%
l_eye = l_sim+w_sim; b_eye = 0.1; w_eye = 700/(xmax-xmin); h_eye = 500/(ymax-ymin);
h.eyeAxes = axes('Units', 'normalized', ...
    'Position', [l_eye b_eye w_eye+0.01 h_eye+0.01]); %[left bottom width height]
axes(h.eyeAxes)
hold on;
box on;
image([-59 37],[34 -47.5],I,'alphadata',1);

set(gca,'xtick',[],'ytick',[]);
set(gca,'Color','b','XColor','b','YColor','b','linewidth',5);
%
h.eyelim.x = 4; 
h.eyelim.y = h.eyelim.x;%*h_eye/w_eye; 
hold on;
axis([-h.eyelim.x, h.eyelim.x, -h.eyelim.y, h.eyelim.y]); 
h.eye.FastSLAMPath= plot (0, 0, 'color','g', ...
    'linestyle', '-', 'linewidth',2,'erasemode','normal'); 
h.eye.lmFastSLAM = plot (0, 0, 'm.','linewidth', 4, 'erasemode','normal');
h.eye.cov =plot (0, 0, 'color','r', ...
    'linestyle', '-', 'linewidth',4,'erasemode','normal'); 
h.eye.particles = plot (0, 0, 'c*','linewidth',5,'erasemode','normal');
h.eye.FastSLAMRob  = patch('Faces',[1,2], 'linewidth',3,'markeredgecolor','b',...
    'facecolor','y','erasemode', 'normal'); 
%%
%The output position of  picture sequence  the name of the former half part
str1 = 'E:\Li Ying\ccdc15\Data\Output\step';
for ii = 1:step
        set(h.all,'CurrentAxes',h.simAxes); 
        cov = makeCovarianceEllipses(data.path(:,ii),data.Pv(:,:,ii));
        str = [str1 num2str(ii) '.jpg'];
        if ii~=1
            htext= ylabel({['Landmarks ID: ',num2str(landmark(ii-1).ID)];...
                ['Step Number: ',num2str(ii-1)]});
            set(htext,'Position',[-41 5.5],'color',[144,243,13]/255,'fontsize',15,'fontweight','bold',...
                    'fontangle','normal','HorizontalAlignment','left','verticalAlignment','top','Rotation',0);
        end
       FastSLAMRobBody = compound(xFastSLAM(:,ii), rob);
       set(h.FastSLAMRob,  'xdata',FastSLAMRobBody(1,:), ...
            'ydata', FastSLAMRobBody(2, :));
      
        set(h.FastSLAMPath,  'xdata',xFastSLAM(1,1:ii), ...
            'ydata',xFastSLAM(2,1:ii));
       if ii~=1 && ~isempty(landmark(ii-1).z)&&~isempty(lmFastSLAM(ii-1).x)
            set(h.lmFastSLAM, 'xdata', lmFastSLAM(ii).x(1,:),...
                'ydata', lmFastSLAM(ii).x(2,:));
       end
       if ~isempty(cov)
          set(h.cov,  'xdata',cov(1,:), 'ydata',cov(2,:));
       end
       if ii~=1
             set(h.particles, 'xdata', pp(1,:,ii-1),'ydata',pp(2,:,ii-1));
       end
% %
%% update the eagle eye.
        set(h.all,'CurrentAxes',h.eyeAxes);
         set(h.eye.FastSLAMRob,  'xdata', FastSLAMRobBody(1,:), ...
             'ydata', FastSLAMRobBody(2, :));
         set(h.eye.FastSLAMPath,  'xdata',xFastSLAM(1,1:ii), ...
            'ydata',xFastSLAM(2,1:ii));
       if ~isempty(cov)
          set(h.eye.cov,  'xdata',cov(1,:), 'ydata',cov(2,:));
       end
        if ii~=1 && ~isempty(landmark(ii-1).z)&&~isempty(lmFastSLAM(ii-1).x)
            set(h.eye.lmFastSLAM, 'xdata', lmFastSLAM(ii).x(1,:),...
                'ydata', lmFastSLAM(ii).x(2,:));
        end
           if ii~=1
             set(h.eye.particles, 'xdata', pp(1,:,ii-1),'ydata',pp(2,:,ii-1));
           end
           ax_eye= [xFastSLAM(1,ii)- 0.1*h.eyelim.x, xFastSLAM(1,ii)+0.1* h.eyelim.x,...
                   xFastSLAM(2,ii)-0.1*h.eyelim.y,xFastSLAM(2,ii)+ 0.1*h.eyelim.y]; 
        Xeye= [ax_eye(1) ax_eye(2) ax_eye(2) ax_eye(1) ax_eye(1)]; 
        Yeye= [ax_eye(4) ax_eye(4) ax_eye(3) ax_eye(3) ax_eye(4)];
        axis(h.eyeAxes,ax_eye); 
        set(h.eye.sim,'xdata',Xeye,'ydata',Yeye); 
  saveas (gcf,str);
%    cov = zeros(2,12);
end
        


