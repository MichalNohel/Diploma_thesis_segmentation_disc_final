close all
clear all
clc
%%  SET
path_to_data = 'D:\Preprocesing';
path_to_data= [path_to_data '\'];

% Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
resolution = 25;  

% Nastavení parametrů pro modifikaci jasu
sigma_preprocesing=50;
Num_tiles_param=150;
ClipLimit=0.005;

%% Preprocessing of databases and creation of GT disc positions
%% Drishti-GS
path=[path_to_data 'Drishti-GS\'];
load_drishtigs(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'dristhi-gt')
%% HRF
path=[path_to_data 'HRF\'];
load_hrf(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'HRF')
%% REFUGE
path=[path_to_data 'REFUGE\'];
load_refuge(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'REFUGE')
%% RIGA
path=[path_to_data 'RIGA\'];
load_riga_BinRushed(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
load_riga_Magrabia(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
load_riga_MESSIDOR(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'RIGA')
%% RIM-ONE
path=[path_to_data 'RIM-ONE\'];
load_rimone(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'RIM-ONE')
%% UoA_DR
path=[path_to_data 'UoA_DR\'];
load_uoadr(resolution, path, sigma_preprocesing, Num_tiles_param, ClipLimit );
GT_disc_center_creation(path,'UoA_DR')
load chirp
sound(y/10,Fs)

%% Creation of test and train dataset
output_image_size=[320,320]; %parametres for crop image
percentage_number_test=0.2; % 20% of image will be in test dataset
%parametres for OD detection
sigma_detection=25;
size_of_erosion=40;
path_export_file='D:\DATA\Data_320_320_25px_preprocesing_sigma_50_all_database/';

creation_of_train_and_test_dataset(path_to_data,output_image_size,sigma_detection,size_of_erosion,path_export_file)
load chirp
sound(y/10,Fs)
%% Detection of centres in Test datasets
test_images_file = dir([path_export_file 'Test\Images\*.png']);
test_fov_file = dir([path_export_file 'Test\Fov\*.png']);
test_dics_file = dir([path_export_file 'Test\Disc\*.png']);
num_of_img=length(test_images_file);
Disc_centres_test=[];
Accuracy_of_detec=[];
%% Detection with mistakes
for i=1:num_of_img
    image=imread([test_images_file(i).folder '\' test_images_file(i).name ]); 
    fov=imread([test_fov_file(i).folder '\' test_fov_file(i).name ]);
    mask_disc=logical(imread([test_dics_file(i).folder '\' test_dics_file(i).name ])); 
    [center_new] = Detection_of_disc(image,fov,sigma_preprocesing,size_of_erosion);
    Disc_centres_test(i,1)=center_new(1);
    Disc_centres_test(i,2)=center_new(2);
    if mask_disc(center_new(2),center_new(1))==1
        Accuracy_of_detec(i)=1;
    else
        Accuracy_of_detec(i)=0;
    end
end
accuracy=sum(Accuracy_of_detec)/length(Accuracy_of_detec)
%% save of test discs centers with mistakes
Disc_centres_test=Disc_centres_test-1;
save([path_export_file 'Disc_centres_test_with_mistakes.mat'],'Disc_centres_test')
%% Detekce bez chyb
for i=1:num_of_img
    image=imread([test_images_file(i).folder '\' test_images_file(i).name ]); 
    fov=imread([test_fov_file(i).folder '\' test_fov_file(i).name ]);
    mask_disc=logical(imread([test_dics_file(i).folder '\' test_dics_file(i).name ])); 
    [center_new] = Detection_of_disc(image,fov,sigma_preprocesing,size_of_erosion);
    Disc_centres_test(i,1)=center_new(1);
    Disc_centres_test(i,2)=center_new(2);

    if mask_disc(Disc_centres_test(i,2),Disc_centres_test(i,1))~=1
        s = regionprops(mask_disc,'centroid');
        Disc_centres_test(i,1)=round(s.Centroid(1));
        Disc_centres_test(i,2)=round(s.Centroid(2));
    end

    if mask_disc(Disc_centres_test(i,2),Disc_centres_test(i,1))==1
        Accuracy_of_detec(i)=1;
    else
        Accuracy_of_detec(i)=0;        
    end
end
accuracy=sum(Accuracy_of_detec)/length(Accuracy_of_detec)

%% save of test discs centers without mistakes
Disc_centres_test=Disc_centres_test-1;
save('Disc_centres_test_correct.mat','Disc_centres_test')

%% code for finding the optimal detection parameters
% for m=1:length(sigma)
%     for n=1:length(size_of_erosion)
%         Disc_centres_test=[];
%         Accuracy_of_detec=[];
%         for i=1:num_of_img
%             image=imread([test_images_file(i).folder '\' test_images_file(i).name ]); 
%             fov=imread([test_fov_file(i).folder '\' test_fov_file(i).name ]);
%             mask_disc=logical(imread([test_dics_file(i).folder '\' test_dics_file(i).name ])); 
%             [center_new] = Detection_of_disc(image,fov,sigma(m),size_of_erosion(n));
%             Disc_centres_test(i,1)=center_new(1);
%             Disc_centres_test(i,2)=center_new(2);
%             if mask_disc(center_new(2),center_new(1))==1
%                 Accuracy_of_detec(i)=1;
%             else
%                 Accuracy_of_detec(i)=0;
%             end
%         end
%         accuracy(m,n)=sum(Accuracy_of_detec)/length(Accuracy_of_detec)
%     end
% end

