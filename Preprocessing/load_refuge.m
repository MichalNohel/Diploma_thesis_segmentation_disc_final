function[] = load_refuge(rc, path, sigma, Num_tiles_param, ClipLimit)
degree = 45;

%% REFUGE Training
images = dir([path 'REFUGE\REFUGE-Training400\Glaucoma\*.jpg']);
images = [images; dir([path 'REFUGE\REFUGE-Training400\Non-Glaucoma\*.jpg'])];
masks = dir([path 'REFUGE\Annotation-Training400\Disc_Cup_Masks\Glaucoma\*.bmp']);
masks = struct2table([masks; dir([path 'REFUGE\Annotation-Training400\Disc_Cup_Masks\Non-Glaucoma\*.bmp'])]); 

for i=1:length(images)
    
    in=images(i).name(1:end-4);
    radek = find(string(cell2mat(masks.name))==[in '.bmp']);
    
    im=imread([images(i).folder '\' images(i).name ]);
    mask=imread(cell2mat([table2array(masks(radek,2)) '\' table2array(masks(radek,1)) ]));
    disc=mask<150;
    cup=mask<50;

    [I,D,C,~,fov]=image_adjustment(im,rc,degree,disc,cup,0, 'refuge', 0);
    
    %moje modifikace
    [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit); %
    %modifikace UBMI
%     [I_mod]=local_contrast_and_clahe(I,fov);

    if in(1)=='g'
    imname= [ 'refuge_train_glaucoma_'  in  ];
    elseif in(1)=='n'
    imname= [ 'refuge_train_healthy_'  in  ];   
    end
    
    imwrite(I,[path '\Images_orig\Train\' imname '.png'])
    imwrite(I_mod,[path '\Images\Train\' imname '.png'])
    imwrite(D,[path '\Disc\Train\' imname '_disc.png'])
    imwrite(C,[path '\Cup\Train\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\Train\' imname '_fov.png'])

end

%% REFUGE Validation
images = dir([path 'REFUGE\REFUGE-Validation400\*.jpg']);
masks = struct2table(dir([path 'REFUGE\REFUGE-Validation400-GT\Disc_Cup_Masks\*.bmp']));

for i=1:length(images)
    
    in=images(i).name(1:end-4);
    radek = find(string(cell2mat(masks.name))==[in '.bmp']);
    
    im=imread([images(i).folder '\' images(i).name ]);
    mask=imread(cell2mat([table2array(masks(radek,2)) '\' table2array(masks(radek,1)) ]));
    disc=mask<150;
    cup=mask<50;

    [I,D,C,~, fov]=image_adjustment(im,rc,degree,disc,cup,0, 'refuge', 0);

    %moje modifikace
    [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit); %
    %modifikace UBMI
%     [I_mod]=local_contrast_and_clahe(I,fov);

    imname= [ 'refuge_validation_na_'  in  ];
    
    imwrite(I,[path '\Images_orig\Validation\' imname '.png'])
    imwrite(I_mod,[path '\Images\Validation\' imname '.png'])
    imwrite(D,[path '\Disc\Validation\' imname '_disc.png'])
    imwrite(C,[path '\Cup\Validation\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\Validation\' imname '_fov.png'])

end

%% REFUGE Test
images = dir([path 'REFUGE\REFUGE-Test400\*.jpg']);
masks = dir([path 'REFUGE\REFUGE-Test-GT\Disc_Cup_Masks\G\*.bmp']);
masks = struct2table([masks; dir([path 'REFUGE\REFUGE-Test-GT\Disc_Cup_Masks\N\*.bmp'])]);

for i=1:length(images)
    
    in=images(i).name(1:end-4);
    radek = find(string(cell2mat(masks.name))==[in '.bmp']);
    
    im=imread([images(i).folder '\' images(i).name ]);
    mask=imread(cell2mat([table2array(masks(radek,2)) '\' table2array(masks(radek,1)) ]));
    disc=mask<150;
    cup=mask<50;

    [I,D,C,~, fov]=image_adjustment(im,rc,degree,disc,cup,0, 'refuge', 0);
    
    %moje modifikace
    [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit); %
    %modifikace UBMI
%     [I_mod]=local_contrast_and_clahe(I,fov);

    diagnose=cell2mat(table2array(masks(radek,2)));
    if diagnose(end)=='N'
    imname= [ 'refuge_test_healthy_'  in  ];
    else
     imname= [ 'refuge_test_glaucoma_'  in  ];
    end
       
    imwrite(I,[path '\Images_orig\Test\' imname '.png'])
    imwrite(I_mod,[path '\Images\Test\' imname '.png'])
    imwrite(D,[path '\Disc\Test\' imname '_disc.png'])
    imwrite(C,[path '\Cup\Test\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\Test\' imname '_fov.png'])


end
end