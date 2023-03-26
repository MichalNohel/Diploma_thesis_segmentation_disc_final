function []=GT_disc_center_creation(path,database)

switch database
    case 'dristhi-gt'
        %% Dristi-GS - centre of disc
        images_file = dir([path 'Disc\expert1\*.png']);
        N_train=length(images_file);
        coordinates_dristi_GS=[];
        %train
        for i=1:N_train
            %expert 1
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            s = regionprops(mask,'centroid');
            coordinates_dristi_GS(i,1)=round(s.Centroid(1));
            coordinates_dristi_GS(i,2)=round(s.Centroid(2));
        end
        name=[path 'coordinates_dristi_GS'];
        save(name,'coordinates_dristi_GS')

    case 'HRF'
        %% HRF centre of disc
        images_file = dir([path 'Disc\*.png']);
        N_Test=length(images_file);
        coordinates_HRF=[];
        %test
        for i=1:N_Test
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            s = regionprops(mask,'centroid');
            coordinates_HRF(i,1)=round(s.Centroid(1));
            coordinates_HRF(i,2)=round(s.Centroid(2));
        end
        name=[path 'coordinates_HRF.mat'];
        save(name,"coordinates_HRF")

    case 'REFUGE'
        %% REFUGE - Test - centre of disc
        images_file = dir([path 'Disc\Test\*.png']);
        N_Test=length(images_file);
        coordinates_REFUGE_Test=[];
        %test
        for i=1:N_Test
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            s = regionprops(mask,'centroid');
            coordinates_REFUGE_Test(i,1)=round(s.Centroid(1));
            coordinates_REFUGE_Test(i,2)=round(s.Centroid(2));
        end
        name=[path 'coordinates_REFUGE_Test.mat'];
        save(name,"coordinates_REFUGE_Test")
        
        %%--------------------------------------------------------------------------
        %% REFUGE - Train - centre of disc        
        images_file = dir([path 'Disc\Train\*.png']);
        N_train=length(images_file);
        coordinates_REFUGE_Train=[];
        %train
        for i=1:N_train
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            s = regionprops(mask,'centroid');
            coordinates_REFUGE_Train(i,1)=round(s.Centroid(1));
            coordinates_REFUGE_Train(i,2)=round(s.Centroid(2));
        end

        name=[path 'coordinates_REFUGE_Train.mat'];
        save(name,"coordinates_REFUGE_Train")
        
        %%--------------------------------------------------------------------------
        %% REFUGE - Validation - centre of disc
        images_file = dir([path 'Disc\Validation\*.png']);
        N_Validation=length(images_file);
        coordinates_REFUGE_Validation=[];
        %Validation
        for i=1:N_Validation
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            s = regionprops(mask,'centroid');
            coordinates_REFUGE_Validation(i,1)=round(s.Centroid(1));
            coordinates_REFUGE_Validation(i,2)=round(s.Centroid(2));
        end

        name=[path 'coordinates_REFUGE_Validation.mat'];
        save(name,"coordinates_REFUGE_Validation")

    case 'RIGA'
        %% RIGA - MESSIDOR centre of disc
        disc_file = dir([path 'Disc\MESSIDOR\expert1\*.png']);
        N_Riga=length(disc_file);
        coordinates_RIGA_MESSIDOR=[];
        %Expert1
        for i=1:N_Riga
            mask=imread([disc_file(i).folder '\' disc_file(i).name ]);
        
            s = regionprops(mask,'centroid');
            coordinates_RIGA_MESSIDOR(i,1)=round(s.Centroid(1));
            coordinates_RIGA_MESSIDOR(i,2)=round(s.Centroid(2));
        end
        
        name=[path 'coordinates_RIGA_MESSIDOR.mat'];
        save(name,"coordinates_RIGA_MESSIDOR")
        
        %% ------------------------------------------------------
        %% RIGA - Magrabia centre of disc
        disc_file = dir([path 'Disc\Magrabia\expert1\*.png']);
        N_Riga=length(disc_file);
        coordinates_RIGA_Magrabia=[];
        %Expert1
        for i=1:N_Riga
            mask=imread([disc_file(i).folder '\' disc_file(i).name ]);
        
            s = regionprops(mask,'centroid');
            coordinates_RIGA_Magrabia(i,1)=round(s.Centroid(1));
            coordinates_RIGA_Magrabia(i,2)=round(s.Centroid(2));
        end

        name=[path 'coordinates_RIGA_Magrabia.mat'];
        save(name,"coordinates_RIGA_Magrabia")

        %% ------------------------------------------------------
        %% RIGA - BinRushed centre of disc
        disc_file = dir([path 'Disc\BinRushed\expert1\*.png']);
        N_Riga=length(disc_file);
        coordinates_RIGA_BinRushed=[];
        %Expert1
        for i=1:N_Riga
            mask=imread([disc_file(i).folder '\' disc_file(i).name ]);
        
            s = regionprops(mask,'centroid');
            coordinates_RIGA_BinRushed(i,1)=round(s.Centroid(1));
            coordinates_RIGA_BinRushed(i,2)=round(s.Centroid(2));
        end
       
        name=[path 'coordinates_RIGA_BinRushed.mat'];
        save(name,"coordinates_RIGA_BinRushed")

    case 'RIM-ONE'
        %% RIM-ONE - Glaucoma-  centre of disc
        images_file = dir([path 'Disc\Glaucoma\*.png']);
        N_RIM_ONE=length(images_file);
        coordinates_RIM_ONE_Glaucoma=[];
        %test
        for i=1:N_RIM_ONE
            mask=double(imread([images_file(i).folder '\' images_file(i).name ]));
            mask=logical(mask);
        
            s = regionprops(mask,'centroid');
            coordinates_RIM_ONE_Glaucoma(i,1)=round(s.Centroid(1));
            coordinates_RIM_ONE_Glaucoma(i,2)=round(s.Centroid(2));
        end
        
        name=[path 'coordinates_RIM_ONE_Glaucoma.mat'];
        save(name,"coordinates_RIM_ONE_Glaucoma")
        
        %% RIM-ONE - Healthy -  centre of disc
        images_file = dir([path 'Disc\Healthy\*.png']);
        N_RIM_ONE=length(images_file);
        coordinates_RIM_ONE_Healthy=[];
        %test
        for i=1:N_RIM_ONE
            mask=double(imread([images_file(i).folder '\' images_file(i).name ]));
            mask=logical(mask);
        
            s = regionprops(mask,'centroid');
            coordinates_RIM_ONE_Healthy(i,1)=round(s.Centroid(1));
            coordinates_RIM_ONE_Healthy(i,2)=round(s.Centroid(2));
        end

        name=[path 'coordinates_RIM_ONE_Healthy.mat'];
        save(name,"coordinates_RIM_ONE_Healthy")

    case 'UoA_DR'
        %% UoA_DR - NDPR-  centre of disc
        images_file = dir([path 'Disc\NDPR\*.png']);
        N_UoA_DR=length(images_file);
        coordinates_UoA_DR_NDPR=[];
        %test
        for i=1:N_UoA_DR
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            mask=logical(mask);
        
            s = regionprops(mask,'centroid');
            coordinates_UoA_DR_NDPR(i,1)=round(s.Centroid(1));
            coordinates_UoA_DR_NDPR(i,2)=round(s.Centroid(2));
        end
        
        name=[path 'coordinates_UoA_DR_NDPR.mat'];
        save(name,"coordinates_UoA_DR_NDPR")
        
        %% UoA_DR - PDR-  centre of disc
        images_file = dir([path 'Disc\PDR\*.png']);
        N_UoA_DR=length(images_file);
        coordinates_UoA_DR_PDR=[];
        %test
        for i=1:N_UoA_DR
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            mask=logical(mask);
        
            s = regionprops(mask,'centroid');
            coordinates_UoA_DR_PDR(i,1)=round(s.Centroid(1));
            coordinates_UoA_DR_PDR(i,2)=round(s.Centroid(2));
        end
        
        name=[path 'coordinates_UoA_DR_PDR.mat'];
        save(name,"coordinates_UoA_DR_PDR")
        
        %% UoA_DR - Healthy-  centre of disc
        images_file = dir([path 'Disc\Healthy\*.png']);
        N_UoA_DR=length(images_file);
        coordinates_UoA_Healthy=[];
        %test
        for i=1:N_UoA_DR
            mask=imread([images_file(i).folder '\' images_file(i).name ]);
            mask=logical(mask);
        
            s = regionprops(mask,'centroid');
            coordinates_UoA_Healthy(i,1)=round(s.Centroid(1));
            coordinates_UoA_Healthy(i,2)=round(s.Centroid(2));
        end
        
        name=[path 'coordinates_UoA_Healthy.mat'];
        save(name,"coordinates_UoA_Healthy")
    otherwise
        disp('Špatně zadaný název databáze')
end