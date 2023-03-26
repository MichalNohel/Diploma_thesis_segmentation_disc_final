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



