%%
% Copyright(c) 2015 Ying li;Zuolei Sun;Yafang Xu;Bo Zhang -- Robot Navigation based on Visual 
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
load 'ccdc15\Data\DLR\truth.mat';
x0   = truth.x; % truth data
load 'ccdc15\Data\Output\EKFobs4.mat'; % EKF-SLAM on DLR Data
x1 = data.path;
load 'ccdc15\Data\Output\IEKF2obs4.mat';% IEKF-SLAM on DLR Data
x2 = data.path;
load 'ccdc15\Data\Output\Num100.mat';% FastSLAM on DLR Data
x3 = data.path;
step = 3298;
%% Path comparison
figure('name','Path Comparison','color','w');
hold on; box on; axis equal;
xlim([-50, 20]);ylim([-30, 30]);
xlabel('x(m)'); ylabel('y(m)');
%
I = imread('ccdc15\Data\DLR\Maps\satelliteMap.png','PNG'); % read the DLR satellite map.
image([-59 37],[34 -47.5],I,'alphadata',0.7);
timeSeq = 1 : step;
plot( x0(1, timeSeq), x0(2, timeSeq), ':b', 'linewidth', 1.5 );
 plot( x1(1, timeSeq), x1(2, timeSeq), '--r',  'linewidth', 1.5 );
 plot( x2(1, timeSeq), x2(2, timeSeq), '-g',  'linewidth', 1.5);
 plot( x3(1, timeSeq), x3(2, timeSeq), '-.m',  'linewidth', 1.5 );
