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

%% Drishti-GS
path=[path_to_data 'Drishti-GS\'];
load_drishtigs(resolution, path, sigma, Num_tiles_param, ClipLimit );
load chirp
sound(y/10,Fs)

%% HRF
path=[path_to_data 'HRF\'];
load_hrf(resolution, path, sigma, Num_tiles_param, ClipLimit );
load chirp
sound(y/10,Fs)

%% REFUGE
path=[path_to_data 'REFUGE\'];
load_refuge(resolution, path, sigma, Num_tiles_param, ClipLimit );
load chirp
sound(y/10,Fs)
%% RIGA
path=[path_to_data 'RIGA\'];
load_riga_BinRushed(resolution, path, sigma, Num_tiles_param, ClipLimit );
load_riga_Magrabia(resolution, path, sigma, Num_tiles_param, ClipLimit );
load_riga_MESSIDOR(resolution, path, sigma, Num_tiles_param, ClipLimit );
load chirp
sound(y/10,Fs)