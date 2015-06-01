%%
% Copyright(c) 2015 Ying Li;Zuolei Sun;Yafang Xu;Bo Zhang -- Robot Navigation based on Visual 
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
load 'ccdc15\Data\DLR\truth.mat';
x0   = truth.x; % truth data
load 'ccdc15\Data\Output\EKFobs4.mat'; % EKF-SLAM on DLR Data
x1 = data.path;
load 'ccdc15\Data\Output\IEKF2obs4.mat';% IEKF-SLAM on DLR Data
x2 = data.path;
load 'ccdc15\Data\Output\Num100.mat';% FastSLAM on DLR Data
x3 = data.path;
step = 3298;
width=1.5;
errEKF=abs(x1-x0); % EKF error.
errIEKF=abs(x2-x0); % IEKF error.
errFastSLAM=abs(x3-x0); % IEKF error.
errEKF(3,:)=abs(piTopi(errEKF(3,:)));
errIEKF(3,:)=abs(piTopi(errIEKF(3,:)));
errFastSLAM(3,:)=abs(piTopi(errFastSLAM(3,:)));
err.EKF = errEKF;
err.IEKF= errIEKF;
err.FastSLAM= errFastSLAM;
%% Error in x
figure('name','errorInX','color','w');
hold on;box on;
timeSeq = 1 : step;
h1    = plot(timeSeq, errEKF(1, timeSeq), '-r','linewidth',width);
h2    = plot(timeSeq, errIEKF(1, timeSeq), 'g--','linewidth',width);
h3    = plot(timeSeq, errFastSLAM(1, timeSeq), 'b:','linewidth',width);
label = [h1, h2,h3];
hx    = legend(label,'EKF-SLAM','IEKF-SLAM','粒子滤波');
set(hx,'box','off','location','NorthWest','Orientation','horizontal');
axis([min(timeSeq) max(timeSeq) 0 12]); 
xlabel('时间(s)');
ylabel('x方向绝对误差(m)');