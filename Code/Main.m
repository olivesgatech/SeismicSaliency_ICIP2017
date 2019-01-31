%% Seismic Saliency
% ===============================================================================
%  Please, cite the following papers in your publication if you use this script.
% ===============================================================================

% M. A. Shafiq, Z. Long, T. Alshawi, and G. AlRegib, “Saliency detection for seismic applications using 
% multi-dimensional spectral projections and directional comparisons ,” IEEE International Conference 
% on Image Processing (ICIP), Beijing, China, Sep. 17-20, 2017.

% M. Shafiq, T. Alshawi, Z. Long, and G. AlRegib, “The role of visual saliency in the automation of seismic 
% interpretation,” Geophysical Prospecting, 2017.

% If you have found any bugs or have any questions/suggestions, 
% please contact amirshafiq@gatech.edu 

%% Saliency for Seismic calculation
% Init
clc
clear 
close all

%% Add Path
addpath(genpath('Functions'))
addpath(genpath('Mat Files'))

%% Load Data
load F3Large_Subset
SS_Dataset = Vol_Normalize( F3_Seismic_Subset, [-1 1] );

%% Multi-dimensional Spectral Saliency
[ dataF_SeisSal] = MultiDim_Spectral_Saliency_v05_Simplified(SS_Dataset, [3,3,3]);

%% Directional Center-surround Comparison
SeisSal_Map = DCS_Comparison( dataF_SeisSal, [3 7 3], [1/3 1/3 1/3] );

%% Display Results
SS_Num = 5;
figure
    imshow(SS_Dataset(:,:,SS_Num),[])
    colormap('gray')
    colorbar
    title('Seismic Section')
    xlabel('Crosslines')
    ylabel('Time (ms)')
    axis on 
    X_ticks = get(gca,'XTick');
    set(gca,'xTickLabel',X_ticks + 300);
    Y_ticks =  get(gca,'YTick');
    set(gca,'yTickLabel',(Y_ticks)*4);
    set(gca,'fontsize',24,'fontname', 'Times New Roman')

figure
    imshow(Img_Normalize(SeisSal_Map(:,:,SS_Num),[0 1]),[])
    colormap('jet')
    colorbar
    title('Seismic Saliency Map')
    xlabel('Crosslines')
    ylabel('Time (ms)')
    axis on 
    X_ticks = get(gca,'XTick');
    set(gca,'xTickLabel',X_ticks + 300);
    Y_ticks =  get(gca,'YTick');
    set(gca,'yTickLabel',(Y_ticks)*4);
    set(gca,'fontsize',24,'fontname', 'Times New Roman')

