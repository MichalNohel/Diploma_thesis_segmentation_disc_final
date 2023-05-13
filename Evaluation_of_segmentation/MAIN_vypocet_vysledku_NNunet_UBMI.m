clear all
close all
clc
%% Evaluace masek pro rozlišení 25px
% path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_25px\';

%% Evaluace masek pro rozlišení 35px
path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_35px\';

%% path to NNunet mask
path_to_output_nnUnet=[path_to_data '\Sada01_Output_NNunet\result_nnUNet_sada01/'];
path_to_output_nnUnet2=[path_to_data '\Sada02_Output_NNunet\result_nnUNet_sada02/'];

Output_NN_unet = dir([path_to_output_nnUnet '*.nii.gz']);
Output_NN_unet=[Output_NN_unet; dir([path_to_output_nnUnet2 '*.nii.gz'])];

%% Path to GT data
GT_disc_file=dir([path_to_data '\Sada01_manualy_GT\Disc\*.png']);
GT_disc_file=[GT_disc_file; dir([path_to_data '\Sada02_manualy_GT\Disc\*.png'])];

GT_cup_file=dir([path_to_data '\Sada01_manualy_GT\Cup\*.png']);
GT_cup_file=[GT_cup_file; dir([path_to_data '\Sada02_manualy_GT\Cup\*.png'])];
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
    Output_NN_unet_lbl=niftiread([Output_NN_unet(i).folder '\' Output_NN_unet(i).name]);
    disc_output_net=logical(Output_NN_unet_lbl);
    cup_output_net=logical(zeros(size(Output_NN_unet_lbl)));
    cup_output_net(Output_NN_unet_lbl==2)=1;
    
    disc_GT=imread([GT_disc_file(i).folder '\' GT_disc_file(i).name]);
    cup_GT=imread([GT_cup_file(i).folder '\' GT_cup_file(i).name]);

    if (size(disc_output_net)~=size(disc_GT))
        disp(Output_NN_unet(i).name)
        continue
    end
    
    Dice_disc(end+1)=dice(disc_GT,disc_output_net);
    Dice_cup(end+1)=dice(cup_GT,cup_output_net);

    Housdorf_distance_disc(end+1)=Hausdorff_Dist(disc_GT,disc_output_net);
    Housdorf_distance_cup(end+1)=Hausdorff_Dist(cup_GT,cup_output_net);

    [error_area_disc(end+1),error_area_cup(end+1)]= Calculation_error_of_area(disc_GT,disc_output_net,cup_GT,cup_output_net);
   
    if (sum(cup_output_net(:))==0)
        Error_of_segmentation_cup(end+1)=1;
        continue    
    elseif (sum(disc_output_net(:))==0)
        Error_of_segmentation_disc(end+1)=1;
        continue 
    else
        [abs_error_disc_pom,abs_error_cup_pom,rel_error_disc_pom,rel_error_cup_pom]= Calculation_error_of_distance(disc_GT,disc_output_net,cup_GT,cup_output_net);
        
        abs_error_disc(end+1,:)=abs_error_disc_pom;
        abs_error_cup(end+1,:)=abs_error_cup_pom;
        rel_error_disc(end+1,:)=rel_error_disc_pom;
        rel_error_cup(end+1,:)=rel_error_cup_pom;
        
        abs_error_disc_mean(end+1)=mean(abs_error_disc_pom);
        abs_error_cup_mean(end+1)=mean(abs_error_cup_pom);
        rel_error_disc_mean(end+1)=mean(rel_error_disc_pom);
        rel_error_cup_mean(end+1)=mean(rel_error_cup_pom);
        Error_of_segmentation_cup(end+1)=0;
        Error_of_segmentation_disc(end+1)=0;
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

