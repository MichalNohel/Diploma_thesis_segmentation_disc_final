clear all
close all
clc
%% Evaluace masek pro rozlišení 25px
% path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_25px\Output_nnUNet\';
% path_to_output_nnUnet=[path_to_data '\Result_OD_detection_25px/'];

%% Evaluace masek pro rozlišení 35px
path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_35px\Output_nnUNet\';
path_to_output_nnUnet=[path_to_data '\Result_OD_detection_35px/'];

%% Path to GT data
path_to_GT=[path_to_data '/labelsTs/'];

%% whole databse
% Output_NN_unet = dir([path_to_output_nnUnet '*.nii.gz']);
% GT_file = dir([path_to_GT '*.nii.gz']);
%% refuge databse
Output_NN_unet = dir([path_to_output_nnUnet 'refuge*.nii.gz']); %pro evaluaci refuge
GT_file = dir([path_to_GT 'refuge*.nii.gz']);
%% drishti databse
% Output_NN_unet = dir([path_to_output_nnUnet 'drishti*.nii.gz']); %pro evaluaci refuge
% GT_file = dir([path_to_GT 'drishti*.nii.gz']);



%%
Dice_disc=[];
Dice_cup=[];

Housdorf_distance_disc=[];
Housdorf_distance_cup=[];

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
for i=1:length(Output_NN_unet)
    GT_lbl=niftiread([GT_file(i).folder '\' GT_file(i).name]);
    Output_NN_unet_lbl=niftiread([Output_NN_unet(i).folder '\' Output_NN_unet(i).name]);

    disc_GT=logical(GT_lbl);
    cup_GT=logical(zeros(size(GT_lbl)));
    cup_GT(GT_lbl==2)=1;
    
    disc_output_net=logical(Output_NN_unet_lbl);
    cup_output_net=logical(zeros(size(GT_lbl)));
    cup_output_net(Output_NN_unet_lbl==2)=1;    

    Dice_disc(i)=dice(disc_GT,disc_output_net);
    Dice_cup(i)=dice(cup_GT,cup_output_net);

    Housdorf_distance_disc(i)=Hausdorff_Dist(disc_GT,disc_output_net);
    Housdorf_distance_cup(i)=Hausdorff_Dist(cup_GT,cup_output_net);

    [error_area_disc(i),error_area_cup(i)]= Calculation_error_of_area(disc_GT,disc_output_net,cup_GT,cup_output_net);
   
    if (sum(cup_output_net(:))==0)
        Error_of_segmentation_cup(i)=1;
        continue    
    elseif (sum(disc_output_net(:))==0)
        Error_of_segmentation_disc(i)=1;
        continue 
    else
        [abs_error_disc_pom,abs_error_cup_pom,rel_error_disc_pom,rel_error_cup_pom]= Calculation_error_of_distance(disc_GT,disc_output_net,cup_GT,cup_output_net);
        
        abs_error_disc(i,:)=abs_error_disc_pom;
        abs_error_cup(i,:)=abs_error_cup_pom;
        rel_error_disc(i,:)=rel_error_disc_pom;
        rel_error_cup(i,:)=rel_error_cup_pom;
        
        abs_error_disc_mean(i)=mean(abs_error_disc_pom);
        abs_error_cup_mean(i)=mean(abs_error_cup_pom);
        rel_error_disc_mean(i)=mean(rel_error_disc_pom);
        rel_error_cup_mean(i)=mean(rel_error_cup_pom);
        Error_of_segmentation_cup(i)=0;
        Error_of_segmentation_disc(i)=0;
    end
    disp(i)
end
%%
disp('Disk')
disp(['Počet chybících segmentaci disku ' num2str(sum(Error_of_segmentation_disc))])
disp(['Pruměrný DICE disku je ' num2str(mean(Dice_disc))])
disp(['Smer. odchylka DICE disku je ' num2str(std(Dice_disc))])
disp(['Pruměrná HD disku je ' num2str(mean(Housdorf_distance_disc)) ' px'])
disp(['Smer. odchylka HD disku je ' num2str(std(Housdorf_distance_disc)) ' px'])
disp(['pruměrna absolutni chyba disku je ' num2str(mean(abs_error_disc_mean)) ' px'])
disp(['Smer. odchylka absolutni chyba disku je ' num2str(std(abs_error_disc_mean)) ' px'])
disp(['pruměrna relativní chyba disku je ' num2str(mean(rel_error_disc_mean)) ' %'])
disp(['Pruměrna chyba plochy disku je ' num2str(mean(error_area_disc)) '%'])

abs_error_cup_mean_mod=abs_error_cup_mean;
rel_error_cup_mean_mod=rel_error_cup_mean;
abs_error_cup_mean_mod(logical(Error_of_segmentation_cup))=[];
rel_error_cup_mean_mod(logical(Error_of_segmentation_cup))=[];
Housdorf_distance_cup_mod=Housdorf_distance_cup;
Housdorf_distance_cup_mod(logical(Error_of_segmentation_cup))=[];


disp('Cup')
disp(['Počet chybících segmentaci cupu ' num2str(sum(Error_of_segmentation_cup))])
disp(['Pruměrný DICE cupu je ' num2str(mean(Dice_cup))])
disp(['Smer. odchylka DICE cupu je ' num2str(std(Dice_cup))])
disp(['Pruměrná HD cupu je ' num2str(mean(Housdorf_distance_cup_mod)) ' px'])
disp(['Smer. odchylka HD cupu je ' num2str(std(Housdorf_distance_cup_mod)) ' px'])
disp(['pruměrna absolutni chyba cupu je ' num2str(mean(abs_error_cup_mean_mod)) ' px'])
disp(['Smer. odchylka absolutni chyba cupu je ' num2str(std(abs_error_cup_mean_mod)) ' px'])
disp(['pruměrna relativní chyba cupu je ' num2str(mean(rel_error_cup_mean_mod)) ' %'])
disp(['Pruměrna chyba plochy cupu je ' num2str(mean(error_area_cup)) ' %'])
