close all
clear all
clc
%%  SET
% nastavení cesty k vytvořené struktuře a nahraným datům
path_to_data = 'D:\DATA_DP_oci\Preprocesing_35px';
path_to_data= [path_to_data '\'];

%% Pro rozlišeni 25px
% % Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
% resolution = 25;  
% % Nastavení parametrů pro modifikaci jasu
% sigma_preprocesing=50; % 
% Num_tiles_param=150;
% ClipLimit=0.005;

%% Pro rozlišeni 35px
% Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
resolution = 35;  
% Nastavení parametrů pro modifikaci jasu
sigma_preprocesing=75; % 
Num_tiles_param=150;
ClipLimit=0.005;

%% Preprocessing of databases 
% jednotlivé funkce load_XXX slouží pro preprocesing obrazů a anotací. 
% vstupem jsou parametry na jeké prostorové rozlišení se má snímek
% převzorkovat a parametry pro modifikaci jasu, dále následuje funkce pro
% vytvoření GT středů optického disku.
%% Drishti-GS
path=[path_to_data 'Drishti-GS\']; 
load_drishtigs(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'dristhi-gt')
%% HRF
path=[path_to_data 'HRF\'];
load_hrf(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'HRF')
%% REFUGE
path=[path_to_data 'REFUGE\'];
load_refuge(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'REFUGE')
%% RIGA
path=[path_to_data 'RIGA\'];
load_riga_BinRushed(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
load_riga_Magrabia(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
load_riga_MESSIDOR(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'RIGA')
%% RIM-ONE
path=[path_to_data 'RIM-ONE\'];
load_rimone(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'RIM-ONE')
%% UoA_DR
path=[path_to_data 'UoA_DR\'];
load_uoadr(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'UoA_DR')

load chirp
sound(y/10,Fs)
