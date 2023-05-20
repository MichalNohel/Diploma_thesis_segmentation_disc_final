clear all
close all
clc
%%
% Skript pro vizualizaci výsledků segmentace z nnUNetu a zkouška převedení
% vizualizace NIfTI dat.

%% Vizualizace masek z nnUNet pro rozlišení 25px
path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_25px\Output_nnUNet\';

path_to_output_nnUnet=[path_to_data '\Result_OD_detection_25px/'];
Output_NN_unet = dir([path_to_output_nnUnet '*.nii.gz']);

path_to_GT=[path_to_data '/labelsTs/'];
GT_file = dir([path_to_GT '*.nii.gz']);

path_to_image=[path_to_data '/imagesTs/'];
image_file = dir([path_to_image '*.nii.gz']);

%% Vizualizace masek z nnUNet pro rozlišení 35px
path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_35px\Output_nnUNet\';

path_to_output_nnUnet=[path_to_data '\Result_OD_detection_35px/'];
Output_NN_unet = dir([path_to_output_nnUnet '*.nii.gz']);

path_to_GT=[path_to_data '/labelsTs/'];
GT_file = dir([path_to_GT '*.nii.gz']);

path_to_image=[path_to_data '/imagesTs/'];
image_file = dir([path_to_image '*.nii.gz']);

%%
i=100
clear image
image(:,:,1)=niftiread([image_file(((i-1)*3)+1).folder '\' image_file(((i-1)*3)+1).name]);
image(:,:,2)=niftiread([image_file(((i-1)*3)+2).folder '\' image_file(((i-1)*3)+2).name]);
image(:,:,3)=niftiread([image_file(((i-1)*3)+3).folder '\' image_file(((i-1)*3)+3).name]);

GT_lbl=niftiread([GT_file(i).folder '\' GT_file(i).name]);
Output_NN_unet_lbl=niftiread([Output_NN_unet(i).folder '\' Output_NN_unet(i).name]);

figure
subplot(1,3,1)
imshow(image,[])
subplot(1,3,2)
imshow(Output_NN_unet_lbl,[])
subplot(1,3,3)
imshow(GT_lbl,[])
%%
disc_GT=logical(GT_lbl);
cup_GT=logical(zeros(size(GT_lbl)));
cup_GT(GT_lbl==2)=1;

disc_output_net=logical(Output_NN_unet_lbl);
cup_output_net=logical(zeros(size(GT_lbl)));
cup_output_net(Output_NN_unet_lbl==2)=1;
%%
figure
subplot(1,3,1)
imshow(image,[])
subplot(1,3,2)
imshow(disc_GT)
subplot(1,3,3)
imshow(disc_output_net)

%%
figure
subplot(1,3,1)
imshow(image,[])
subplot(1,3,2)
imshow(cup_GT)
subplot(1,3,3)
imshow(cup_output_net)
