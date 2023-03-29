close all
clear all
clc
%%  SET
path_to_data = 'D:\Preprocesing_TomVicar_mod_jasu_25px';
path_to_data= [path_to_data '\'];

%% Creation of test and train dataset
output_image_size=[360,360]; %parametres for crop image
percentage_number_test=0.2; % 20% of image will be in test dataset
%parametres for OD detection
sigma_detection=25;
size_of_erosion=40;
path_export_file='D:\DATA\Data_360_360_25px_preprocesing_TomVicar/';

creation_of_train_and_test_dataset(path_to_data,output_image_size,sigma_detection,size_of_erosion,percentage_number_test,path_export_file)
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
    [center_new] = Detection_of_disc(image,fov,sigma_detection,size_of_erosion);
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
    [center_new] = Detection_of_disc(image,fov,sigma_detection,size_of_erosion);
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
save([path_export_file 'Disc_centres_test_correct.mat'],'Disc_centres_test')

%% code for finding the optimal detection parameters
% sigma_detection=20:5:50;
% size_of_erosion=40;
% accuracy=[];
% for m=1:length(sigma_detection)
%     for n=1:length(size_of_erosion)
%         Disc_centres_test=[];
%         Accuracy_of_detec=[];
%         for i=1:num_of_img
%             image=imread([test_images_file(i).folder '\' test_images_file(i).name ]); 
%             fov=imread([test_fov_file(i).folder '\' test_fov_file(i).name ]);
%             mask_disc=logical(imread([test_dics_file(i).folder '\' test_dics_file(i).name ])); 
%             [center_new] = Detection_of_disc(image,fov,sigma_detection(m),size_of_erosion(n));
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