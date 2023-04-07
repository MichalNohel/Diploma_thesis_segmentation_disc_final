clear all
close all
clc
%% Evaluace masek pro rozlišení 35px
path_to_data='D:\DATA_DP_oci\Vysledky\Rozliseni_25px\Output_unet';
images_file = dir(path_to_data);
images_file(1:2)=[]; 

Dice_disc=[];
Dice_cup=[];

Dice_disc_postprocesing=[];
Dice_cup_postprocesing=[];

ploting=0;

for i=1:length(images_file)
    image=imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '.png']);
    disc_GT=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Disc_orig.png']));
    disc_output_net=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Disc_output.png']));
    cup_GT=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Cup_orig.png']));
    cup_output_net=logical(imread([images_file(i).folder '\' images_file(i).name '\' images_file(i).name '_Cup_output.png']));
    
    Dice_disc(i)=dice(disc_GT,disc_output_net);
    Dice_cup(i)=dice(cup_GT,cup_output_net);

    %disc
    min_size=50;
    type_of_morphing='closing'; 
    size_of_disk=40;

    disc_output_net_postprocesing=Postprocesing(disc_output_net,min_size,type_of_morphing,size_of_disk,ploting) ;
    Dice_disc_postprocesing(i)=dice(disc_GT,disc_output_net_postprocesing);
    %cup
    min_size=5;
    type_of_morphing='closing'; 
    size_of_disk=30;
    
    cup_output_net_postprocesing=Postprocesing(cup_output_net,min_size,type_of_morphing,size_of_disk,ploting) ;    
    Dice_cup_postprocesing(i)=dice(cup_GT,cup_output_net_postprocesing);
%     disp(i)
end
%%
disp(['Pruměrný DICE disku je ' num2str(mean(Dice_disc))])
disp(['Pruměrný DICE cupu je ' num2str(mean(Dice_cup))])

disp(['Smer. odchylka DICE disku je ' num2str(std(Dice_disc))])
disp(['Smer. odchylka DICE cupu je ' num2str(std(Dice_cup))])

%%
disp(['Pruměrný DICE_postprocesing disku je ' num2str(mean(Dice_disc_postprocesing))])
disp(['Pruměrný DICE_postprocesing cupu je ' num2str(mean(Dice_cup_postprocesing))])

disp(['Smer. odchylka DICE_postprocesing disku je ' num2str(std(Dice_disc_postprocesing))])
disp(['Smer. odchylka DICE_postprocesing cupu je ' num2str(std(Dice_cup_postprocesing))])



  