clear all
close all
clc
%%
% Skript pro výpočet hodnotících metrik pro U-Net  

%% Evaluace masek pro rozlišení 25px
% path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_25px\Output_unet\';
% images_file = dir([path_to_data]);

%% Evaluace masek pro rozlišení 35px
path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_35px\Output_unet\';
images_file = dir([path_to_data]);

%% evaluace dristhi
% images_file = images_file(1:53);

%% evaluace refuge
images_file = images_file([1:2,62:461]);

%%
images_file(1:2)=[]; 
%% Definice proměnných
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


%% Procházení všech segmentací a porovnání s GT
for i=1:length(images_file)
    image=imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '.png']);
    disc_GT=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Disc_orig.png']));
    disc_output_net=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Disc_output.png']));
    cup_GT=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Cup_orig.png']));
    cup_output_net=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Cup_output.png']));
    
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
%% Zobrazeni výsledků
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

