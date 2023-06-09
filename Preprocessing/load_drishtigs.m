function[] = load_drishtigs(rc, path, sigma, Num_tiles_param, ClipLimit)
%%
% Funkce pro předzpracování databáze, využívají se zde funkce
% image_adjustment a modifikace jasu
% rc - int - Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
% path - string - cesta k datům
% sigma, Num_tiles_param, ClipLimit - int - Nastavení parametrů pro modifikaci jasu
%%
% rozlišení databáze
degree = 30;

%% Drihsti-GS Train
images = dir([path 'Drishti-GS\Training\Images\*.png']);
for i=1:length(images)
    in=images(i).name(1:end-4);
    im=imread([path 'Drishti-GS\Training\Images\' images(i).name ]);
    cup=imread([path 'Drishti-GS\Training\GT\' in '\SoftMap\' in '_cupsegSoftmap.png']);
    disc=imread([path 'Drishti-GS\Training\GT\' in '\SoftMap\' in '_ODsegSoftmap.png']);
    
    vektor_hodnot=[255,191,128,64];
    for j=1:4
        pom_cup=cup;
        pom_disk=disc;
        pom_cup(pom_cup<vektor_hodnot(j))=0;
        pom_disk(pom_disk<vektor_hodnot(j))=0;
        pom_disk=logical(pom_disk);
        pom_cup=logical(pom_cup);
        [I,C,D,~,fov]=image_adjustment(im,rc,degree,pom_cup,pom_disk,0, 'drishtigs', 0);
        
        %moje modifikace
        [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit); %
        %modifikace UBMI
%         [I_mod]=local_contrast_and_clahe(I,fov);

        ind=strfind(in,'_');
        num=in(ind+1:end);
        imname= [ 'drishti_train_na_'  num  ];
        
        if (j==1)
            imwrite(C,[path '\Cup\expert1\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert1\' imname '_disc_exp_' num2str(j) '.png'])
        elseif (j==2)
            imwrite(C,[path '\Cup\expert2\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert2\' imname '_disc_exp_' num2str(j) '.png'])
        elseif (j==3)
            imwrite(C,[path '\Cup\expert3\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert3\' imname '_disc_exp_' num2str(j) '.png'])
        else
            imwrite(C,[path '\Cup\expert4\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert4\' imname '_disc_exp_' num2str(j) '.png'])
        end
    end
    imwrite(I,[path '\Images_orig\' imname '.png'])
    imwrite(I_mod,[path '\Images\' imname '.png'])
    imwrite(fov,[path '\Fov\' imname '_fov.png'])
end

%% Drihsti-GS Test
images = dir([path 'Drishti-GS\Test\Images\*.png']);
for i=1:length(images)
    in=images(i).name(1:end-4);
    im=imread([path 'Drishti-GS\Test\Images\' images(i).name ]);
    cup=imread([path 'Drishti-GS\Test\Test_GT\' in '\SoftMap\' in '_cupsegSoftmap.png']);
    disc=imread([path 'Drishti-GS\Test\Test_GT\' in '\SoftMap\' in '_ODsegSoftmap.png']);
    
    vektor_hodnot=[255,191,128,64];
    for j=1:4
        pom_cup=cup;
        pom_disk=disc;
        pom_cup(pom_cup<vektor_hodnot(j))=0;
        pom_disk(pom_disk<vektor_hodnot(j))=0;
        pom_disk=logical(pom_disk);
        pom_cup=logical(pom_cup);
        [I,C,D,~,fov]=image_adjustment(im,rc,degree,pom_cup,pom_disk,0, 'drishtigs', 0);
       
        
        %moje modifikace
        [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit); %
        %modifikace UBMI
%         [I_mod]=local_contrast_and_clahe(I,fov);

        ind=strfind(in,'_');
        num=in(ind+1:end);
        imname= [ 'drishti_test_na_'  num  ];

        if (j==1)
            imwrite(C,[path '\Cup\expert1\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert1\' imname '_disc_exp_' num2str(j) '.png'])
        elseif (j==2)
            imwrite(C,[path '\Cup\expert2\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert2\' imname '_disc_exp_' num2str(j) '.png'])
        elseif (j==3)
            imwrite(C,[path '\Cup\expert3\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert3\' imname '_disc_exp_' num2str(j) '.png'])
        else
            imwrite(C,[path '\Cup\expert4\' imname '_cup_exp_' num2str(j) '.png'])
            imwrite(D,[path '\Disc\expert4\' imname '_disc_exp_' num2str(j) '.png'])
        end
    end    

    imwrite(I,[path '\Images_orig\' imname '.png'])
    imwrite(I_mod,[path '\Images\' imname '.png'])
    imwrite(fov,[path '\Fov\' imname '_fov.png'])

end
end