function []=creation_of_train_and_test_dataset(path_to_data,output_image_size,sigma,size_of_erosion,path_export_file)
    
    % Creatio of file structure for creation of database
    if ~exist(path_export_file, 'dir')
        mkdir(path_export_file)
    end
    if ~exist([path_export_file '\Test\Cup'], 'dir')
        mkdir([path_export_file '\Test\Cup'])
    end
    if ~exist([path_export_file '\Test\Disc'], 'dir')
        mkdir([path_export_file '\Test\Disc'])
    end
    if ~exist([path_export_file '\Test\Fov'], 'dir')
        mkdir([path_export_file '\Test\Fov'])
    end
    if ~exist([path_export_file '\Test\Images'], 'dir')
        mkdir([path_export_file '\Test\Images'])
    end
    if ~exist([path_export_file '\Test\Images_orig'], 'dir')
        mkdir([path_export_file '\Test\Images_orig'])
    end
    if ~exist([path_export_file '\Train\Cup_crop'], 'dir')
        mkdir([path_export_file '\Train\Cup_crop'])
    end
    if ~exist([path_export_file '\Train\Disc_crop'], 'dir')
        mkdir([path_export_file '\Train\Disc_crop'])
    end
    if ~exist([path_export_file '\Train\Images_crop'], 'dir')
        mkdir([path_export_file '\Train\Images_crop'])
    end
    if ~exist([path_export_file '\Train\Images_orig_crop'], 'dir')
        mkdir([path_export_file '\Train\Images_orig_crop'])
    end
    if ~exist([path_export_file '\Train\Images'], 'dir')
        mkdir([path_export_file '\Train\Images'])
    end


    %% Dristi-GS train  - Expert 1
    images_file = dir([path_to_data '\Drishti-GS\Images\*.png']);
    images_orig_file = dir([path_to_data '\Drishti-GS\Images_orig\*.png']);
    disc_file = dir([path_to_data '\Drishti-GS\Disc\expert1\*.png']);
    cup_file = dir([path_to_data '\Drishti-GS\Cup\expert1\*.png']);
    fov_file = dir([path_to_data '\Drishti-GS\Fov\*.png']);
    
    coordinates_dristi_GS=load([path_to_data '\Drishti-GS\coordinates_dristi_GS.mat']);
    coordinates=coordinates_dristi_GS.coordinates_dristi_GS;
    num_of_img=length(images_file);
    split=52; % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split)
    
    
    %% REFUGE_train
    images_file = dir([path_to_data '\REFUGE\Images\Train\*.png']);
    images_orig_file = dir([path_to_data '\REFUGE\Images_orig\Train\*.png']);
    disc_file = dir([path_to_data '\REFUGE\Disc\Train\*.png']);
    cup_file = dir([path_to_data '\REFUGE\Cup\Train\*.png']);
    fov_file = dir([path_to_data '\REFUGE\Fov\Train\*.png']);
    
    coordinates_REFUGE_Train=load([path_to_data '\REFUGE\coordinates_REFUGE_Train.mat']);
    coordinates=coordinates_REFUGE_Train.coordinates_REFUGE_Train;
    num_of_img=length(images_file);
    split=0; % split to test and train dataset

    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% REFUGE_Validation
    images_file = dir([path_to_data '\REFUGE\Images\Validation\*.png']);
    images_orig_file = dir([path_to_data '\REFUGE\Images_orig\Validation\*.png']);
    disc_file = dir([path_to_data '\REFUGE\Disc\Validation\*.png']);
    cup_file = dir([path_to_data '\REFUGE\Cup\Validation\*.png']);
    fov_file = dir([path_to_data '\REFUGE\Fov\Validation\*.png']);
    
    coordinates_REFUGE_Validation=load([path_to_data '\REFUGE\coordinates_REFUGE_Validation.mat']);
    coordinates=coordinates_REFUGE_Validation.coordinates_REFUGE_Validation;
    num_of_img=length(images_file);
    split=0; % split to test and train dataset

    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    %% REFUGE_Test    
    images_file = dir([path_to_data '\REFUGE\Images\Test\*.png']);
    images_orig_file = dir([path_to_data '\REFUGE\Images_orig\Test\*.png']);
    disc_file = dir([path_to_data '\REFUGE\Disc\Test\*.png']);
    cup_file = dir([path_to_data '\REFUGE\Cup\Test\*.png']);
    fov_file = dir([path_to_data '\REFUGE\Fov\Test\*.png']);
    
    coordinates_REFUGE_Test=load([path_to_data '\REFUGE\coordinates_REFUGE_Test.mat']);
    coordinates=coordinates_REFUGE_Test.coordinates_REFUGE_Test;
    num_of_img=length(images_file);
    split=401; % split to test and train dataset

    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% Riga - Bin Rushed
    images_file = dir([path_to_data '\RIGA\Images\BinRushed\*.png']);
    images_orig_file = dir([path_to_data '\RIGA\Images_orig\BinRushed\*.png']);
    disc_file = dir([path_to_data '\RIGA\Disc\BinRushed\expert1\*.png']);
    cup_file = dir([path_to_data '\RIGA\Cup\BinRushed\expert1\*.png']);
    fov_file = dir([path_to_data '\RIGA\Fov\BinRushed\*.png']);
    
    coordinates_RIGA_BinRushed=load([path_to_data '\RIGA\coordinates_RIGA_BinRushed.mat']);
    coordinates=coordinates_RIGA_BinRushed.coordinates_RIGA_BinRushed;
    num_of_img=length(images_file);
    split=round(num_of_img*percentage_number_test); % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% Riga - Magrabia
    images_file = dir([path_to_data '\RIGA\Images\Magrabia\*.png']);
    images_orig_file = dir([path_to_data '\RIGA\Images_orig\Magrabia\*.png']);
    disc_file = dir([path_to_data '\RIGA\Disc\Magrabia\expert1\*.png']);
    cup_file = dir([path_to_data '\RIGA\Cup\Magrabia\expert1\*.png']);
    fov_file = dir([path_to_data '\RIGA\Fov\Magrabia\*.png']);
    
    coordinates_RIGA_Magrabia=load([path_to_data '\RIGA\coordinates_RIGA_Magrabia.mat']);
    coordinates=coordinates_RIGA_Magrabia.coordinates_RIGA_Magrabia;
    num_of_img=length(images_file);
    split=round(num_of_img*percentage_number_test); % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% Riga - MESSIDOR
    images_file = dir([path_to_data '\RIGA\Images\MESSIDOR\*.png']);
    images_orig_file = dir([path_to_data '\RIGA\Images_orig\MESSIDOR\*.png']);
    disc_file = dir([path_to_data '\RIGA\Disc\MESSIDOR\expert1\*.png']);
    cup_file = dir([path_to_data '\RIGA\Cup\MESSIDOR\expert1\*.png']);
    fov_file = dir([path_to_data '\RIGA\Fov\MESSIDOR\*.png']);
    
    coordinates_RIGA_MESSIDOR=load([path_to_data '\RIGA\coordinates_RIGA_MESSIDOR.mat']);
    coordinates=coordinates_RIGA_MESSIDOR.coordinates_RIGA_MESSIDOR;
    num_of_img=length(images_file);
    split=round(num_of_img*percentage_number_test); % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% RIM-ONE - Glaucoma
    images_file = dir([path_to_data '\RIM-ONE\Images\Glaucoma\*.png']);
    images_orig_file = dir([path_to_data '\RIM-ONE\Images_orig\Glaucoma\*.png']);
    disc_file = dir([path_to_data '\RIM-ONE\Disc\Glaucoma\*.png']);
    cup_file = dir([path_to_data '\RIM-ONE\Cup\Glaucoma\*.png']);
    fov_file = dir([path_to_data '\RIM-ONE\Fov\Glaucoma\*.png']);
    
    coordinates_RIM_ONE_Glaucoma=load([path_to_data '\RIM-ONE\coordinates_RIM_ONE_Glaucoma.mat']);
    coordinates=coordinates_RIM_ONE_Glaucoma.coordinates_RIM_ONE_Glaucoma;
    num_of_img=length(images_file);
    split=round(num_of_img*percentage_number_test); % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% RIM-ONE - Healthy
    images_file = dir([path_to_data '\RIM-ONE\Images\Healthy\*.png']);
    images_orig_file = dir([path_to_data '\RIM-ONE\Images_orig\Healthy\*.png']);
    disc_file = dir([path_to_data '\RIM-ONE\Disc\Healthy\*.png']);
    cup_file = dir([path_to_data '\RIM-ONE\Cup\Healthy\*.png']);
    fov_file = dir([path_to_data '\RIM-ONE\Fov\Healthy\*.png']);
    
    coordinates_RIM_ONE_Healthy=load([path_to_data '\RIM-ONE\coordinates_RIM_ONE_Healthy.mat']);
    coordinates=coordinates_RIM_ONE_Healthy.coordinates_RIM_ONE_Healthy;
    num_of_img=length(images_file);
    split=round(num_of_img*percentage_number_test); % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% UoA_DR - Healthy
    images_file = dir([path_to_data '\UoA_DR\Images\Healthy\*.png']);
    images_orig_file = dir([path_to_data '\UoA_DR\Images_orig\Healthy\*.png']);
    disc_file = dir([path_to_data '\UoA_DR\Disc\Healthy\*.png']);
    cup_file = dir([path_to_data '\UoA_DR\Cup\Healthy\*.png']);
    fov_file = dir([path_to_data '\UoA_DR\Fov\Healthy\*.png']);
    
    coordinates_UoA_Healthy=load([path_to_data '\UoA_DR\coordinates_UoA_Healthy.mat']);
    coordinates=coordinates_UoA_Healthy.coordinates_UoA_Healthy;
    num_of_img=length(images_file);
    split=round(num_of_img*percentage_number_test); % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    %% UoA_DR - NDPR
    % images_file = dir([path_to_data '\UoA_DR\Images\NDPR\*.png']);
    % images_orig_file = dir([path_to_data '\UoA_DR\Images_orig\NDPR\*.png']);
    % disc_file = dir([path_to_data '\UoA_DR\Disc\NDPR\*.png']);
    % cup_file = dir([path_to_data '\UoA_DR\Cup\NDPR\*.png']);
    % fov_file = dir([path_to_data '\UoA_DR\Fov\NDPR\*.png']);
    % 
    % coordinates_UoA_NDPR=load('C:\Users\nohel\Desktop\Databaze_final\UoA_DR\coordinates_UoA_NDPR.mat');
    % coordinates=coordinates_UoA_NDPR.coordinates_UoA_NDPR;
    % num_of_img=length(images_file);
    % split=round(num_of_img*percentage_number_train); % split to test and train dataset
    % 
    % creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_to_crop_image,split )
    %% UoA_DR - PDR
    % images_file = dir([path_to_data '\UoA_DR\Images\PDR\*.png']);
    % images_orig_file = dir([path_to_data '\UoA_DR\Images_orig\PDR\*.png']);
    % disc_file = dir([path_to_data '\UoA_DR\Disc\PDR\*.png']);
    % cup_file = dir([path_to_data '\UoA_DR\Cup\PDR\*.png']);
    % fov_file = dir([path_to_data '\UoA_DR\Fov\PDR\*.png']);
    % 
    % coordinates_UoA_PDR=load('C:\Users\nohel\Desktop\Databaze_final\UoA_DR\coordinates_UoA_PDR.mat');
    % coordinates=coordinates_UoA_PDR.coordinates_UoA_PDR;
    % num_of_img=length(images_file);
    % split=round(num_of_img*percentage_number_train); % split to test and train dataset
    % 
    % creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_to_crop_image,split )
    %% HRF 
    images_file = dir([path_to_data '\HRF\Images\*.png']);
    images_orig_file = dir([path_to_data '\HRF\Images_orig\*.png']);
    disc_file = dir([path_to_data '\HRF\Disc\*.png']);
    cup_file = dir([path_to_data '\HRF\Cup\*.png']);
    fov_file = dir([path_to_data '\HRF\Fov\*.png']);
    
    coordinates_HRF=load([path_to_data '\HRF\coordinates_HRF.mat']);
    coordinates=coordinates_HRF.coordinates_HRF;
    num_of_img=length(images_file);
    split=round(num_of_img*percentage_number_test); % split to test and train dataset
    
    creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_export_file,split )
    
    
    
    %% Functions        
    function [output_crop_image, output_crop_image_orig, output_mask_disc,output_mask_cup]=Crop_image(image,image_orig,mask_disc,mask_cup,output_image_size,center_new)
        size_in_img=size(image);
        x_half=round(output_image_size(1)/2);
        y_half=round(output_image_size(2)/2);
        if ((center_new(2)-x_half)<0)
            x_start=1;
        elseif ((center_new(2)+x_half)>size_in_img(1))
            x_start=size_in_img(1)-output_image_size(1);
        else
            x_start=center_new(2)-x_half;
            if x_start==0
                x_start=1;
            end
        end
    
        if ((center_new(1)-y_half)<0)
            y_start=1;
        elseif ((center_new(1)+y_half)>size_in_img(2))
            y_start=size_in_img(2)-output_image_size(2);
        else
            y_start=center_new(1)-y_half;
            if y_start==0
                y_start=1;
            end
        end    
        output_crop_image=image(x_start:x_start+output_image_size(1)-1,y_start:y_start+output_image_size(2)-1,:);
        output_crop_image_orig=image_orig(x_start:x_start+output_image_size(1)-1,y_start:y_start+output_image_size(2)-1,:);
        output_mask_disc=mask_disc(x_start:x_start+output_image_size(1)-1,y_start:y_start+output_image_size(2)-1);
        output_mask_cup=mask_cup(x_start:x_start+output_image_size(1)-1,y_start:y_start+output_image_size(2)-1);
    end
    
    function []= creation_of_crop_images(output_image_size,images_orig_file,images_file,disc_file,cup_file,fov_file,sigma,size_of_erosion,coordinates,path_to_crop_image,split )
        num_of_img=length(images_file);
        for i=1:num_of_img
            %expert 1
            image=imread([images_file(i).folder '\' images_file(i).name ]); 
            image_orig=imread([images_orig_file(i).folder '\' images_orig_file(i).name ]); 
            mask_disc=logical(imread([disc_file(i).folder '\' disc_file(i).name ]));  
            mask_cup=logical(imread([cup_file(i).folder '\' cup_file(i).name ]));  
            fov=imread([fov_file(i).folder '\' fov_file(i).name ]);    
              
            if i>=split
                [center_new] = Detection_of_disc(image,fov,sigma,size_of_erosion);
                if mask_disc(center_new(2),center_new(1))~=1
                    center_new(1)=coordinates(i,1);
                    center_new(2)=coordinates(i,2);
                end
                [output_crop_image, output_crop_image_orig, output_mask_disc,output_mask_cup]=Crop_image(image,image_orig,mask_disc,mask_cup,output_image_size,center_new);
              
                imwrite(output_crop_image,[path_to_crop_image 'Train\Images_crop\' images_file(i).name])
                imwrite(output_crop_image_orig,[path_to_crop_image 'Train\Images_orig_crop\' images_file(i).name])
                imwrite(output_mask_disc,[path_to_crop_image 'Train\Disc_crop\' disc_file(i).name])
                imwrite(output_mask_cup,[path_to_crop_image 'Train\Cup_crop\' cup_file(i).name])
                imwrite(image,[path_to_crop_image 'Train\Images\' images_file(i).name])
            else
                imwrite(image,[path_to_crop_image 'Test\Images\' images_file(i).name])
                imwrite(image_orig,[path_to_crop_image 'Test\Images_orig\' images_file(i).name])
                imwrite(mask_disc,[path_to_crop_image 'Test\Disc\' disc_file(i).name])
                imwrite(mask_cup,[path_to_crop_image 'Test\Cup\' cup_file(i).name])
                imwrite(fov,[path_to_crop_image 'Test\Fov\' fov_file(i).name])
            end
        end
    end
end
    
        