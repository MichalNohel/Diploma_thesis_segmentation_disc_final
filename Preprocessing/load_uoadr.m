function[] = load_uoadr(rc, path, sigma, Num_tiles_param, ClipLimit)
degree = 45;

%% UoA_DR
images = dir([path 'UoA_DR\']);
dirFlags = [images.isdir]; 
dirFlags(1:2)=0;
images(~dirFlags)=[];

for i=1:length(images)
     in=images(i).name;
    
    im=imread([path 'UoA_DR\' images(i).name '\' images(i).name '.jpg']);
    if str2num(in)==72
    ves=imread([path 'UoA_DR\' images(i).name '\' images(i).name '.2.jpg']);
    disc=imread([path 'UoA_DR\' images(i).name '\' images(i).name '.1.jpg']);
    else
    ves=imread([path 'UoA_DR\' images(i).name '\' images(i).name '.1.jpg']);
    disc=imread([path 'UoA_DR\' images(i).name '\' images(i).name '.2.jpg']);
    end
    cup=imread([path 'UoA_DR\' images(i).name '\' images(i).name '.3.jpg']);

    disc=rgb2gray(disc);
    disc(disc<50)=0;
    disc=logical(disc);
    disc=bwpropfilt(disc,'Area',1,'largest');
    disc=imerode(disc,strel('disk',1));
    disc=bwpropfilt(disc,'Area',1,'largest');

    cup=rgb2gray(cup);
    cup(cup<50)=0;
    cup=logical(cup);
    cup=bwpropfilt(cup,'Area',1,'largest');
    cup=imerode(cup,strel('disk',1));
    cup=bwpropfilt(cup,'Area',1,'largest');

    [I,V,D,C,fov]=image_adjustment(im,rc,degree,ves,disc,cup, 'uoadr',0);

    %moje modifikace
    [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit); %
    %modifikace UBMI
%     [I_mod]=local_contrast_and_clahe(I,fov);
    
    if sum(str2num(in) == [1:81, 83:94, 130, 132:143, 168, 169, 171:174, 179, 193])
    imname= [ 'uoadr_na_npdr_'  in  ];
    imwrite(I,[path '\Images_orig\NDPR\' imname '.png'])
    imwrite(I_mod,[path '\Images\NDPR\' imname '.png'])
    imwrite(V,[path '\Vessels\NDPR\' imname '_mask.png'])
    imwrite(D,[path '\Disc\NDPR\' imname '_disc.png'])
    imwrite(C,[path '\Cup\NDPR\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\NDPR\' imname '_fov.png'])
    elseif sum(str2num(in) == [82, 95:100, 131, 167, 176:178, 182:192, 194:200])
    imname= [ 'uoadr_na_pdr_'  in  ];
    imwrite(I,[path '\Images_orig\PDR\' imname '.png'])
    imwrite(I_mod,[path '\Images\PDR\' imname '.png'])
    imwrite(V,[path '\Vessels\PDR\' imname '_mask.png'])
    imwrite(D,[path '\Disc\PDR\' imname '_disc.png'])
    imwrite(C,[path '\Cup\PDR\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\PDR\' imname '_fov.png'])
    elseif sum(str2num(in) == [101:129, 144:166, 170, 175, 180, 181])
    imname= [ 'uoadr_na_healthy_'  in  ];
    imwrite(I,[path '\Images_orig\Healthy\' imname '.png'])
    imwrite(I_mod,[path '\Images\Healthy\' imname '.png'])
    imwrite(V,[path '\Vessels\Healthy\' imname '_mask.png'])
    imwrite(D,[path '\Disc\Healthy\' imname '_disc.png'])
    imwrite(C,[path '\Cup\Healthy\' imname '_cup.png'])
    imwrite(fov,[path '\Fov\Healthy\' imname '_fov.png'])
    end

end
end