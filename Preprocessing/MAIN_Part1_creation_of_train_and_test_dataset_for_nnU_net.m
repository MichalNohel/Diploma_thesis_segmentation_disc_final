close all
clear all
clc
%%  SET
% nastavení cesty k vytvořené struktuře a předzpracovaným datům
path_to_data = 'D:\DATA_DP_oci\Preprocesing_35px';
path_to_data= [path_to_data '\'];

%% Creation of test and train dataset for nnU-Net
percentage_number_test=0.2; % 20% of image will be in test dataset
path_export_file='D:\DATA_DP_oci\Data_35px_nn_unet\';

% Creatio of file structure for creation of database
if ~exist(path_export_file, 'dir')
    mkdir(path_export_file)
end
if ~exist([path_export_file '\training\input'], 'dir')
    mkdir([path_export_file '\training\input'])
end
if ~exist([path_export_file '\training\output'], 'dir')
    mkdir([path_export_file '\training\output'])
end
if ~exist([path_export_file '\testing\input'], 'dir')
    mkdir([path_export_file '\testing\input'])
end
if ~exist([path_export_file '\testing\output'], 'dir')
    mkdir([path_export_file '\testing\output'])
end



%% Dristi-GS train  - Expert 1
images_file = dir([path_to_data '\Drishti-GS\Images\*.png']);
disc_file = dir([path_to_data '\Drishti-GS\Disc\expert1\*.png']);
cup_file = dir([path_to_data '\Drishti-GS\Cup\expert1\*.png']);

pom=52; % split to test and train dataset

% Funkce, která provede rozdělení dat na trénovací a testovací dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)
%% REFUGE_train
images_file = dir([path_to_data '\REFUGE\Images\Train\*.png']);
disc_file = dir([path_to_data '\REFUGE\Disc\Train\*.png']);
cup_file = dir([path_to_data '\REFUGE\Cup\Train\*.png']);

pom=0; % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)
%% REFUGE_Validation
images_file = dir([path_to_data '\REFUGE\Images\Validation\*.png']);
disc_file = dir([path_to_data '\REFUGE\Disc\Validation\*.png']);
cup_file = dir([path_to_data '\REFUGE\Cup\Validation\*.png']);

pom=0; % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)
%% REFUGE_Test
images_file = dir([path_to_data '\REFUGE\Images\Test\*.png']);
disc_file = dir([path_to_data '\REFUGE\Disc\Test\*.png']);
cup_file = dir([path_to_data '\REFUGE\Cup\Test\*.png']);

pom=401; % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)
%% Riga - Bin Rushed
images_file = dir([path_to_data '\RIGA\Images\BinRushed\*.png']);
disc_file = dir([path_to_data '\RIGA\Disc\BinRushed\expert1\*.png']);
cup_file = dir([path_to_data '\RIGA\Cup\BinRushed\expert1\*.png']);
num_of_img=length(images_file);
pom=round(num_of_img*percentage_number_test); % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)

%% Riga - Magrabia
images_file = dir([path_to_data '\RIGA\Images\Magrabia\*.png']);
disc_file = dir([path_to_data '\RIGA\Disc\Magrabia\expert1\*.png']);
cup_file = dir([path_to_data '\RIGA\Cup\Magrabia\expert1\*.png']);
num_of_img=length(images_file);
pom=round(num_of_img*percentage_number_test); % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)

%% Riga - MESSIDOR
images_file = dir([path_to_data '\RIGA\Images\MESSIDOR\*.png']);
disc_file = dir([path_to_data '\RIGA\Disc\MESSIDOR\expert1\*.png']);
cup_file = dir([path_to_data '\RIGA\Cup\MESSIDOR\expert1\*.png']);
num_of_img=length(images_file);
pom=round(num_of_img*percentage_number_test); % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)
%% RIM-ONE - Glaucoma
images_file = dir([path_to_data '\RIM-ONE\Images\Glaucoma\*.png']);
disc_file = dir([path_to_data '\RIM-ONE\Disc\Glaucoma\*.png']);
cup_file = dir([path_to_data '\RIM-ONE\Cup\Glaucoma\*.png']);

num_of_img=length(images_file);
pom=round(num_of_img*percentage_number_test); % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
load chirp
sound(y/10,Fs)

%% RIM-ONE -  Healthy
images_file = dir([path_to_data '\RIM-ONE\Images\Healthy\*.png']);
disc_file = dir([path_to_data '\RIM-ONE\Disc\Healthy\*.png']);
cup_file = dir([path_to_data '\RIM-ONE\Cup\Healthy\*.png']);

num_of_img=length(images_file);
pom=round(num_of_img*percentage_number_test); % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
load chirp
sound(y/10,Fs)

%% UoA_DR - Healthy
images_file = dir([path_to_data '\UoA_DR\Images\Healthy\*.png']);
disc_file = dir([path_to_data '\UoA_DR\Disc\Healthy\*.png']);
cup_file = dir([path_to_data '\UoA_DR\Cup\Healthy\*.png']);

num_of_img=length(images_file);
pom=round(num_of_img*percentage_number_test); % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)

%% HRF - 
images_file = dir([path_to_data '\HRF\Images\*.png']);
disc_file = dir([path_to_data '\HRF\Disc\*.png']);
cup_file = dir([path_to_data '\HRF\Cup\*.png']);
num_of_img=length(images_file);
pom=round(num_of_img*percentage_number_test); % split to test and train dataset
creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
load chirp
sound(y/10,Fs)

%%
function []= creation_of_nn_unet_dataset(images_file,disc_file,cup_file,pom,path_export_file)
%%
% Funkce co připraví trénovací a testovací dataset pro nnUNet
%%
    num_of_img=length(images_file);
    for i=1:num_of_img
        %expert 1
        image=imread([images_file(i).folder '\' images_file(i).name ]); 
        mask_disc=logical(imread([disc_file(i).folder '\' disc_file(i).name ]));  
        mask_cup=logical(imread([cup_file(i).folder '\' cup_file(i).name ]));  

        label=uint8(zeros(size(mask_disc)));
        label(mask_disc)=1;
        label(mask_cup)=2;
                
        if i>=pom
            imwrite(image,[path_export_file 'training\input\' images_file(i).name])
            imwrite(label,[path_export_file 'training\output\' images_file(i).name])            
        else
            imwrite(image,[path_export_file 'testing\input\' images_file(i).name])
            imwrite(label,[path_export_file 'testing\output\' images_file(i).name]) 
        end
    end
end
