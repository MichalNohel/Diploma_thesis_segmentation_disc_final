function[] = load_rimone(rc, path, sigma, Num_tiles_param, ClipLimit)
degree = 20;

%% RIM-ONE Glaucoma
images = dir([path 'RIM-ONE\RIM-ONE r3\Glaucoma and suspects\Stereo Images\*.jpg']);

for i=1:length(images)
    
    in=images(i).name(1:end-4);
    
    im=imread([images(i).folder '\' images(i).name ]);
    cup=imread([path 'RIM-ONE\RIM-ONE r3\Glaucoma and suspects\Average_masks\' in '-Cup-Avg.png' ]);
    disk=imread([path 'RIM-ONE\RIM-ONE r3\Glaucoma and suspects\Average_masks\' in '-Disc-Avg.png' ]);

    [m,n,~]=size(im);
    fov=logical(zeros(m,n)); fov([1, end],1:n/2)=1; fov(:,[1 n/2])=1;
    [I,D,C,~, fov]=image_adjustment(im,rc,degree,disk,cup,0, 'rimone', fov);

    [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit);
    
    in(strfind(in,'-'))=[];
    imname= [ 'rimone_na_glaucoma_'  in  ];
    
    imwrite(I,[path '\Images_orig\Glaucoma\' imname '.png'])
    imwrite(I_mod,[path '\Images\Glaucoma\' imname '.png'])
    imwrite(C,[path '\Cup\Glaucoma\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\Glaucoma\' imname '_fov.png'])
    imwrite(D,[path '\Disc\Glaucoma\' imname '_disc.png'])

end

%% RIM-ONE Healthy
images = dir([path 'RIM-ONE\RIM-ONE r3\Healthy\Stereo Images\*.jpg']);

for i=1:length(images)
    
    in=images(i).name(1:end-4);
    
    im=imread([images(i).folder '\' images(i).name ]);
    cup=imread([path 'RIM-ONE\RIM-ONE r3\Healthy\Average_masks\' in '-Cup-Avg.png' ]);
    disc=imread([path 'RIM-ONE\RIM-ONE r3\Healthy\Average_masks\' in '-Disc-Avg.png' ]);

    [m,n,~]=size(im);
    fov=logical(zeros(m,n)); fov([1, end],1:n/2)=1; fov(:,[1 n/2])=1;
    [I,D,C,~, fov]=image_adjustment(im,rc,degree,disc,cup,0, 'rimone', fov);

    [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit);
   
    in(strfind(in,'-'))=[];
    imname= [ 'rimone_na_healthy_'  in  ];
    
    imwrite(I,[path '\Images_orig\Healthy\' imname '.png'])
    imwrite(I_mod,[path '\Images\Healthy\' imname '.png'])
    imwrite(C,[path '\Cup\Healthy\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\Healthy\' imname '_fov.png'])
    imwrite(D,[path '\Disc\Healthy\' imname '_disc.png'])

end
end