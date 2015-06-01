%%
% Copyright(c) 2015 Ying Li;Zuolei Sun;Yafang Xu;Bo Zhang -- Robot Navigation based on Visual 
% Feature Perception and Monte Carlo Sampling ( The 27th Chinese Control and Decision 
% Conference ).

% All rights reserved.

% Redistribution and use source Code and data with or without modification must retain the above 
% copyright notice.

% Experiments are carried out based on real data make by Dr.Udo the dataset is collected from 
% the Deutsches Zentrum f¨¹r Luft-und Raumfahrt£¨DLR£©
% --- http://www.informatik.uni-bremen.de/agebv/en/DlrSpatialCognitionDataSet
%%
dbstop if error;
clear all; close all;
path(path, genpath('../../ccdc15'));
load 'ccdc15\Data\Output\Num100.mat';% FastSLAM on DLR Data
x = data.path;
pos=data.pos;
%% Path comparison
figure('name','Landmark','color','w');
hold on; box on; axis equal;
xlim([-50, 20]);ylim([-30, 30]);
xlabel('x(m)'); ylabel('y(m)');
step = 3297;
%
I = imread('ccdc15\Data\DLR\Maps\satelliteMap.png','PNG'); % read the DLR satellite map.
image([-59 37],[34 -47.5],I,'alphadata',0.7);
obsFeature  = plot(0,0,'m.','linewidth',1,'erasemode','normal');
for k =1:step
      if ~isempty(pos(k).x)
             set(obsFeature, 'xdata', pos(k).x(1,:), 'ydata',pos(k).x(2,:));
      end
end
    
