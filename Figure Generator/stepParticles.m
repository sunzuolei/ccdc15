%%
% Copyright(c) 2015 Ying li;Zuolei Sun;Yafang Xu;Bo Zhang -- Robot Navigation based on Visual 
% Feature Perception and Monte Carlo Sampling ( The 27th Chinese Control and Decision 
% Conference ).

% All rights reserved.

% Redistribution and use source Code and data with or without modification must retain the above 
% copyright notice.

% Experiments are carried out based on real data make by Dr.Udo the dataset is collected from 
% the Deutsches Zentrum für Luft-und Raumfahrt（DLR）
% --- http://www.informatik.uni-bremen.de/agebv/en/DlrSpatialCognitionDataSet
%%
dbstop if error;
clear all; close all;
path(path, genpath('../../ccdc15'));
load 'ccdc15\Data\Output\Num100.mat';% FastSLAM on DLR Data
x = data.path;
load 'ccdc15\Data\Output\particlesRob.mat';
for i =1:1000
    p1(:,i)=Rob(:,:,i);
end
figure('name','sampling particle  ','color','w');
hold on; box on;
xlim([0, 0.2]);ylim([-1.8, 0]);
xlabel('x(m)'); ylabel('y(m)');
pp  = plot(0,0,'m.','linewidth',1,'erasemode','normal');
xx = plot(0,0,'b*','linewidth',1,'erasemode','normal');
label = [xx, pp];
hx    = legend(label,'机器人的位姿','采样粒子');
set(hx,'box','off','location','NorthEast','Orientation','horizontal');
  for iii=1:1000
     set(pp,  'xdata', p1(1,:),  'ydata',p1(2,:));
  end
   set(xx,  'xdata', x(1,2:11),  'ydata',x(2,2:11));

