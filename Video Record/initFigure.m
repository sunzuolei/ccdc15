%%
h.all = figure(1);clf;
pos   = get(0,'ScreenSize');
pos(1)=pos(1)+ 300;
pos(2)= pos(2)+ 45;
pos(3)= pos(3);
pos(4)= pos(4);
set(h.all, 'position', pos, 'color', 'w','Menu', 'none')
I = imread('ccdc15\Data\DLR\Maps\gtMap.jpg','JPG');
%% Set simulation axes.
xmin = 0; xmax = 1000; ymin = 0; ymax = 800;%
wp_sim=560; hp_sim = 480; hp_img = 240;% hp_img is the height of image and the unit is pixel.
l_sim = 0.01; 
b_sim = hp_img/(ymax-ymin); 
w_sim = wp_sim/(1280-xmin) +0.04; h_sim = hp_sim/(ymax-ymin);
h.simAxes = axes('Position', [l_sim b_sim+0.02 w_sim h_sim]);
hold on;
image([-46.5 22.5],[24.5 -27.5],I,'alphadata',1);
axis([-50 20 -26.5 25]);
set(gca,'xtick',[],'ytick',[]); % 
set(gca,'Color','w','XColor','w','YColor','w')
% 
h.FastSLAMPath = plot (0, 0, 'color','b', ...
    'linestyle', '-', 'linewidth',1.4,'erasemode','normal'); 
h.EKFPath = plot (0, 0, 'color','r', ...
    'linestyle', '-', 'linewidth',1.4,'erasemode','normal'); 
h.IEKFPath= plot (0, 0, 'color','g', ...
    'linestyle', '-', 'linewidth',1.4,'erasemode','normal'); 
h.lmFastSLAM = plot (0, 0, 'm.','linewidth', 1, 'erasemode','normal');
h.particles = plot (0, 0, 'c.','linewidth', 1, 'erasemode','normal');
%     
h.FastSLAMRob  = patch('Faces',[1,2], 'linewidth',1,'markeredgecolor','m',...
    'facecolor','b','erasemode', 'normal'); 
h.EKFRob  = patch('Faces',[1,2], 'linewidth',1,'markeredgecolor','k',...
    'facecolor','g','erasemode', 'normal'); 
h.IEKFRob = patch('Faces',[1,2], 'linewidth',1,'markeredgecolor','r',...
    'facecolor','y','erasemode', 'normal');
h.eye.sim =line(0,0,'linestyle','-','color','r','linewidth',1.5,'erasemode','normal');

%% for yielding legend.
FastSLAMrob_  = plot(1000,1000,'<','markersize',10,'markeredgecolor','b',...
  'markerfacecolor','m','linewidth',1);
FastSLAMpath_ = plot(1000,1000,'b-','linewidth',1.3);
lm_       = plot(1000,1000,'m.','linewidth',2);
particles_ =plot(1000,1000,'c.','linewidth',2);

h.truelgd = legend([FastSLAMrob_, FastSLAMpath_,lm_,particles_],...
   'FastSLAM Robot', 'FastSLAM Path', 'FastSLAM  Landmarks','particles'); 
set(h.truelgd,'box','off','fontsize',10,'textcolor',[92,194,216]/255,...
  'location', 'north','orientation','horizontal','FontWeight','bold'); 
%%

IEKFrob_  = plot(1000,1000,'<','markersize',10,'markeredgecolor','r',...
  'markerfacecolor','y','linewidth',1);
IEKFpath_ = plot(1000,1000,'g-','linewidth',1.3);
EKFrob_  = plot(1000,1000,'<','markersize',10,'markeredgecolor','k',...
  'markerfacecolor','g','linewidth',1);
EKFpath_ = plot(1000,1000,'r-','linewidth',1.3);
eye_ = plot(1000,1000,'s','markersize',10,'color','r','linewidth',1.5);

hold on; 
h.iekflgd(1)=copyobj(h.truelgd(1),gcf);
h.iekflgd = legend([IEKFrob_, IEKFpath_, EKFrob_ ,EKFpath_,eye_ ],...
     'IEKF Robot', 'IEKF Path','EKF Robot', 'EKF Path','Eagle Eye');
set(h.iekflgd,'box','off','fontsize',10,'textcolor',[92,194,216]/255,...
  'location', 'north','orientation','horizontal','FontWeight','bold'); 
lepos = get(h.iekflgd, 'Position');
lepos(1)= lepos(1)-0.013;
lepos(2)= lepos(2)-0.02;
set(h.iekflgd, 'Position', lepos);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set image axes.
l_img = l_sim; b_img = 0; w_img = w_sim; h_img = 240/800;
h.imgAxes = axes('Units', 'normalized', ...
    'Position', [l_img b_img w_img+0.01 h_img+0.023]); %[left bottom width height]
axis([0 600 50 300]);
axes(h.imgAxes)
hold on; 
set(gca,'xtick',[],'ytick',[]);
set(gca,'Color','w','XColor','w','YColor','w');
%% eagle eye 
l_eye = l_sim+w_img; b_eye = 0; w_eye = 320/1280; h_eye = h_img;
h.eyeAxes = axes('Units', 'normalized', ...
    'Position', [l_eye b_eye w_eye+0.01 h_eye+0.02]); %[left bottom width height]
axes(h.eyeAxes)
hold on;
box on;
set(gca,'xtick',[],'ytick',[]);
set(gca,'Color','w','XColor','k','YColor','k','linewidth',2);
%
h.eyelim.x = 4; 
h.eyelim.y = h.eyelim.x;%*h_eye/w_eye; 
hold on;
axis([-h.eyelim.x, h.eyelim.x, -h.eyelim.y, h.eyelim.y]); 
h.eye.EKFPath = plot (0, 0, 'color','r', ...
    'linestyle', '-', 'linewidth',1.8,'erasemode','normal'); 
h.eye.IEKFPath= plot (0, 0, 'color','g', ...
    'linestyle', '-', 'linewidth',1.8,'erasemode','normal'); 
h.eye.FastSLAMPath= plot (0, 0, 'color','b', ...
    'linestyle', '-', 'linewidth',1.8,'erasemode','normal'); 
h.eye.lmFastSLAM = plot (0, 0, 'm.','linewidth', 2,'erasemode','normal');
h.eye.particles = plot (0, 0, 'c.','linewidth', 2,'erasemode','normal');
%     
h.eye.EKFRob  = patch('Faces',[1,2], 'linewidth',2,'markeredgecolor','k',...
    'facecolor','g','erasemode', 'normal'); 
h.eye.IEKFRob = patch('Faces',[1,2], 'linewidth',2,'markeredgecolor','r',...
    'facecolor','y','erasemode', 'normal');
h.eye.FastSLAMRob  = patch('Faces',[1,2], 'linewidth',2,'markeredgecolor','b',...
    'facecolor','m','erasemode', 'normal'); 
%% Set error figure of different number of samping particles in x axes.
h.errNumAxes = axes('Units', 'normalized', ...
    'Position', [l_eye+0.05 b_eye+2*h_eye+0.05 w_eye-0.04 h_eye-0.03]);
axes(h.errNumAxes)
hold on; box on;
ylabel('Error in X (m)','fontsize',10);
h.errNum50 = plot(0,0,'-g','linewidth', 1, 'erasemode','normal');
h.errNum100  = plot(0,0,'-m','linewidth', 1, 'erasemode','normal');
h.errNum200  = plot(0,0,'-b','linewidth', 1, 'erasemode','normal');
h.errNum500  = plot(0,0,'-r','linewidth', 1, 'erasemode','normal');
h.errNumlgd   = legend('50','100','200','500');
set(h.errNumlgd ,'box','off','location','NorthOutside','textcolor',[92,194,216]/255,...
    'orientation','horizontal','fontsize',10,'FontWeight','bold','linewidth',1.8);
%
%%
%Set error figure of different number of min effective particles in x axes.
h.errNminAxes = axes('Units', 'normalized', ...
    'Position',[l_eye+0.05 b_eye+h_eye+0.05+0.02 w_eye-0.04 h_eye-0.07]);
axes(h.errNminAxes)
hold on; box on;
xlabel('time (s)');
ylabel('Error in X (m)','fontsize',10);
h.errNmin58 = plot(0,0,'-g','linewidth', 1, 'erasemode','normal');
h.errNmin68 = plot(0,0,'-m','linewidth', 1, 'erasemode','normal');
h.errNmin78 = plot(0,0,'-b','linewidth', 1, 'erasemode','normal');
h.errNmin88 = plot(0,0,'-r','linewidth', 1, 'erasemode','normal');
h.errNminlgd   = legend('0.58N','0.68N','0.78N','0.88N');
set(h.errNminlgd ,'box','off','location','NorthOutside','textcolor',[92,194,216]/255,...
    'orientation','horizontal','fontsize',10,'FontWeight','bold','linewidth',1.8);

%% Set text axes.
h.txtAxes = axes('Units', 'normalized', ...
    'Position', [l_img b_sim+h_sim+0.03 w_img+w_eye 1-h_img-h_sim]);
axes(h.txtAxes)
hold on; 
set(gca,'xtick',[],'ytick',[]);
set(gca,'Color','w','XColor','w','YColor','w');
text(0.5,0.25,'EKF-SLAM¡¢IEKF-SLAM and FastSLAM on DLR Data Set',...
    'fontsize',14,'Color','r','fontweight','bold',...
    'HorizontalAlignment','center','verticalAlignment','middle',...
    'fontname','Arial');
text(0.5,0.02,'DLR data and images cite from U Frese and J Kurlbaum''s <A Benchmark Data Set for Data Association>',...
    'fontsize',10,'Color',[144,243,13]/255,'fontweight','bold',...
    'HorizontalAlignment','center','verticalAlignment','middle',...
    'fontname','Arial');