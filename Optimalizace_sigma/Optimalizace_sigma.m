close all
clear all
clc
%%
% Skript, ve kterém se optimalizovala hodnota sigma pro detekci optického
% disku
%%  SET
%%25px
% path_to_data = 'D:\DATA_DP_oci\Data_360_360_25px_preprocesing';
% path_to_data= [path_to_data '\'];
% sigma_preprocesing=30:10:80; % 
% Num_tiles_param=150;
% ClipLimit=0.005;

%% 35px
path_to_data = 'D:\DATA_DP_oci\Data_500_500_35px_preprocesing';
path_to_data= [path_to_data '\'];
sigma_preprocesing=30:10:100; % 
sigma_preprocesing=[sigma_preprocesing, 75]; % 
Num_tiles_param=150;
ClipLimit=0.005;

%%

images_file = dir([path_to_data 'Test\Images_orig\*.png']);
fov_file = dir([path_to_data 'Test\Fov\*.png']);

for m=1:length(sigma_preprocesing)
    path_to_new_file=[path_to_data 'Optimalizace_sigma\sigma' num2str(sigma_preprocesing(m)) '\'];
    mkdir(path_to_new_file)
    
    for i = 1:length(images_file)
        I=im2double(imread([images_file(i).folder '\' images_file(i).name ]));
        fov=logical(imread([fov_file(i).folder '\' fov_file(i).name ]));
        [I_mod]=modifikace_jasu(I,fov,sigma_preprocesing(m),Num_tiles_param,ClipLimit);
        imwrite(I_mod,[path_to_new_file images_file(i).name])
    end
end


%% Detection of centres in Test datasets
sigma_detection=45;
size_of_erosion=40;

test_images_file = dir([path_to_data 'Optimalizace_sigma\sigma80\*.png']);
test_fov_file = dir([path_to_data 'Test\Fov\*.png']);
test_dics_file = dir([path_to_data 'Test\Disc\*.png']);
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
save([path_to_data 'Disc_centres_test_with_mistakes.mat'],'Disc_centres_test')
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
save([path_to_data 'Disc_centres_test_correct.mat'],'Disc_centres_test')

%% code for finding the optimal detection parameters
test_fov_file = dir([path_to_data 'Test\Fov\*.png']);
test_dics_file = dir([path_to_data 'Test\Disc\*.png']);
test_images_file = dir([path_to_data 'Optimalizace_sigma\sigma90\*.png']);
num_of_img=length(test_images_file);

sigma_detection=20:5:80;
size_of_erosion=40;
accuracy=[];
eukl_vzdal=[];
for m=1:length(sigma_detection)
    for n=1:length(size_of_erosion)
        Disc_centres_test=[];
        Accuracy_of_detec=[];
        eukl_vzdal_pom=[];
        for i=1:num_of_img
            image=imread([test_images_file(i).folder '\' test_images_file(i).name ]); 
            fov=imread([test_fov_file(i).folder '\' test_fov_file(i).name ]);
            mask_disc=logical(imread([test_dics_file(i).folder '\' test_dics_file(i).name ])); 
            [center_new] = Detection_of_disc(image,fov,sigma_detection(m),size_of_erosion(n));
            Disc_centres_test(i,1)=center_new(1);
            Disc_centres_test(i,2)=center_new(2);
            if mask_disc(center_new(2),center_new(1))==1
                Accuracy_of_detec(i)=1;
            else
                Accuracy_of_detec(i)=0;
            end
            
            s = regionprops(mask_disc,'centroid');
            eukl_vzdal_pom(i)=sqrt(((round(s.Centroid(1))-center_new(1))^2)+((round(s.Centroid(2))-center_new(2))^2));

        end
        eukl_vzdal(m)=mean(eukl_vzdal_pom)
        accuracy(m,n)=sum(Accuracy_of_detec)/length(Accuracy_of_detec)
    end
end

sigma_detection


