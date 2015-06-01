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
load 'ccdc15\Data\Output\Num50.mat'; 
x50 = data.path;
load 'ccdc15\Data\Output\Num100.mat';
x100 = data.path;
load 'ccdc15\Data\Output\Num200.mat'; 
x200 = data.path;
load 'ccdc15\Data\Output\Num500.mat'; 
x500 = data.path;
step = 3298;
%% Compute absolute error in X,Y and Phi.
width=1.5;
err50=abs(x50-x0); % The number of sampling particles is 50 of  absolute error 
err100=abs(x100-x0); % The number of sampling particles is 100 of  absolute error
err200=abs(x200-x0); % The number of sampling particles is 200 of  absolute error
err500=abs(x500-x0); % The number of sampling particles is 500 of  absolute error
err50(3,:)=abs(piTopi(err50(3,:)));
err100(3,:)=abs(piTopi(err100(3,:)));
err200(3,:)=abs(piTopi(err200(3,:)));
err500(3,:)=abs(piTopi(err500(3,:)));
err.e = err50;
err.ee= err100;
err.eee= err200;
err.eeee= err500;
%% Error in x
figure('name','errorInX','color','w');
hold on;box on;
timeSeq = 1 : step;
h1    = plot(timeSeq, err50(1, timeSeq), '-g','linewidth',width);
h2    = plot(timeSeq, err100(1, timeSeq), 'm--','linewidth',width);
h3    = plot(timeSeq, err200(1, timeSeq), 'b-.','linewidth',width);
h4    = plot(timeSeq, err500(1, timeSeq), 'r:','linewidth',width);
label = [h1, h2,h3, h4];
hx    = legend(label,'50','100','200','500');
set(hx,'box','off','location','NorthWest','Orientation','horizontal');
axis([min(timeSeq) max(timeSeq) 0 5]); 
xlabel('时间(s)');
ylabel('x方向绝对误差(m)');
