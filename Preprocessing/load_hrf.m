function[] = load_hrf(rc, path, sigma, Num_tiles_param, ClipLimit)
degree = 45;

%% HRF
images = dir([path 'HRF\images\*.jpg']);
for i=1:length(images)
    
    in=images(i).name(1:end-4);
    
    im=imread([path 'HRF\images\' images(i).name ]);
    ves=imread([path 'HRF\manual1\' in '.tif']);
    fov=logical(rgb2gray(imread([path 'HRF\mask\' in '_mask.tif'])));
    disc=imread([path 'HRF\Disc\' in '_disc.png']);
    cup=imread([path 'HRF\Cup\' in '_cup.png']);

    [I,V,D,C, fov]=image_adjustment(im,rc,degree,ves,disc,cup, 'hrf', fov);

    %moje modifikace
    [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit); %
    %modifikace UBMI
%     [I_mod]=local_contrast_and_clahe(I,fov);
    
    ind=strfind(in,'_');
    diagnose=in(ind(1)+1);
    in(ind)=[];
    if diagnose=='h'
    imname= [ 'hrf_na_healthy_'  in  ];
    elseif diagnose=='g'
    imname= [ 'hrf_na_glaucoma_'  in  ];
    elseif diagnose=='d'
    imname= [ 'hrf_na_dr_'  in  ];
    end
    
    imwrite(I,[path '\Images_orig\' imname '.png'])
    imwrite(I_mod,[path '\Images\' imname '.png'])
    imwrite(D,[path '\Disc\' imname '_disc.png'])
    imwrite(C,[path '\Cup\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\' imname '_fov.png'])
    imwrite(V,[path '\Vessels\' imname '_ves.png'])

end
end