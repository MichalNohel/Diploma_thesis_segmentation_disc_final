close all
clear all
clc
%%  SET
path_to_data = 'D:\DATA_DP_oci\Data_mereni_UBMI_35px';
path_to_data= [path_to_data '\'];

%% Pro rozlišeni 25px
% % Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
% resolution = 25;  
% % Nastavení parametrů pro modifikaci jasu
% sigma_preprocesing=50; % 
% Num_tiles_param=150;
% ClipLimit=0.005;
% sigma_detection=25;
% size_of_erosion=40;

%% Pro rozlišeni 35px
% Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
resolution = 35;  
% Nastavení parametrů pro modifikaci jasu
sigma_preprocesing=75; % 
Num_tiles_param=150;
ClipLimit=0.005;
sigma_detection=45;
size_of_erosion=40;

%% Preprocessing of databases 
%% SADA_01
path=[path_to_data 'Orig_sada01\'];
folder_creation (path)
load_mereni_UBMI(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit);
%%
disc_detection_UBMI_klikac(path, sigma_detection,size_of_erosion)

%% SADA_02
path=[path_to_data 'Orig_sada02\'];
folder_creation (path)
load_mereni_UBMI(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit);
%%
disc_detection_UBMI_klikac(path, sigma_detection,size_of_erosion)






