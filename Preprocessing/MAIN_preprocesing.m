close all
clear all
clc
%%  SET
path_to_data = 'D:\Preprocesing';
path_to_data= [path_to_data '\'];

% Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
resolution = 25;  

% Nastavení parametrů pro modifikaci jasu
sigma=50;
Num_tiles_param=150;
ClipLimit=0.005;

%% Preprocessing of databases and creation of GT disc positions
%% Drishti-GS
path=[path_to_data 'Drishti-GS\'];
load_drishtigs(resolution, path, sigma, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'dristhi-gt')
%% HRF
path=[path_to_data 'HRF\'];
load_hrf(resolution, path, sigma, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'HRF')
%% REFUGE
path=[path_to_data 'REFUGE\'];
load_refuge(resolution, path, sigma, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'REFUGE')
%% RIGA
path=[path_to_data 'RIGA\'];
load_riga_BinRushed(resolution, path, sigma, Num_tiles_param, ClipLimit );
load_riga_Magrabia(resolution, path, sigma, Num_tiles_param, ClipLimit );
load_riga_MESSIDOR(resolution, path, sigma, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'RIGA')
%% RIM-ONE
path=[path_to_data 'RIM-ONE\'];
load_rimone(resolution, path, sigma, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'RIM-ONE')
%% UoA_DR
path=[path_to_data 'UoA_DR\'];
load_uoadr(resolution, path, sigma, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'UoA_DR')
load chirp
sound(y/10,Fs)

