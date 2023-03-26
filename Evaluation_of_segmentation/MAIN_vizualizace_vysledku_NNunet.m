clear all
close all
clc
%% Evaluace masek pro rozlišení 35px
path_to_output_nnUnet=[pwd '\Output_nnUnet/'];
Output_NN_unet = dir([path_to_output_nnUnet '*.nii.gz']);

path_to_GT=[pwd '/labelsTs/'];
GT_file = dir([path_to_GT '*.nii.gz']);

path_to_image=[pwd '/imagesTs/'];
image_file = dir([path_to_image '*.nii.gz']);

Dice_disc=[];
Dice_cup=[];

error_area_disc=[];
error_area_cup=[];

abs_error_disc=[];
abs_error_cup=[];
rel_error_disc=[];
rel_error_cup=[];

abs_error_disc_mean=[];
abs_error_cup_mean=[];
rel_error_disc_mean=[];
rel_error_cup_mean=[];

Error_of_segmentation_disc=[];
Error_of_segmentation_cup=[];
%%
i=20
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
