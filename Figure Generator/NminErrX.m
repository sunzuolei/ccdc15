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
load 'ccdc15\Data\Output\Nmin58.mat'; 
x58 = data.path;
load 'ccdc15\Data\Output\Num100.mat';
x68 = data.path;
load 'ccdc15\Data\Output\Nmin78.mat'; 
x78 = data.path;
load 'ccdc15\Data\Output\Nmin88.mat'; 
x88 = data.path;
step = 3298;
%% Compute absolute error in X,Y and Phi.
width=1.5;
err58=abs(x58-x0); % The absolute error is  effective particle number is 0.58 times of sampling particles
err68=abs(x68-x0); %The absolute error is  effective particle number is 0.68 times of sampling particles
err78=abs(x78-x0); % The absolute error is  effective particle number is 0.78 times of sampling particles
err88=abs(x88-x0); % The absolute error is  effective particle number is 0.88 times of sampling particles
err58(3,:)=abs(piTopi(err58(3,:)));
err68(3,:)=abs(piTopi(err68(3,:)));
err78(3,:)=abs(piTopi(err78(3,:)));
err88(3,:)=abs(piTopi(err88(3,:)));
err.e = err58;
err.ee= err68;
err.eee= err78;
err.eeee= err88;
%% Error in x
figure('name','errorInX','color','w');
hold on;box on;
timeSeq = 1 : step;
h1    = plot(timeSeq, err58(1, timeSeq), '-g','linewidth',width);
h2    = plot(timeSeq, err68(1, timeSeq), 'm--','linewidth',width);
h3    = plot(timeSeq, err78(1, timeSeq), 'b-.','linewidth',width);
h4    = plot(timeSeq, err88(1, timeSeq), 'r:','linewidth',width);
label = [h1, h2,h3, h4];
hx    = legend(label,'0.58N','0.68N','0.78N','0.88N');
set(hx,'box','off','location','NorthWest','Orientation','horizontal');
axis([min(timeSeq) max(timeSeq) 0 4]); 
xlabel('时间(s)');
ylabel('x方向绝对误差(m)');