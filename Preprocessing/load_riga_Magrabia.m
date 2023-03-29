function[] = load_riga_Magrabia(rc, path, sigma, Num_tiles_param, ClipLimit)

%% RIGA - Magrabia
degree = 45;
images=[];
images = dir([path 'RIGA\Magrabia\Magrabia\MagrabiaMale\*prime.tif']);
images = [images; dir([path 'RIGA\Magrabia\Magrabia\MagrabiFemale\*prime.tif'])];

se = strel('diamond',3);
for i=1:length(images)
    
    in=images(i).name(1:end-9);
    
    im=imread([images(i).folder '\' images(i).name ]);
    
    fold=images(i).folder;
    ind=strfind(fold,'\');
    fol=fold(ind(end)+1:end);
    fol(strfind(fol,'-'))=[];

    in_pom=images(i).name(1:5);
    if i<10
        imname= [ 'riga_na_na_'  fol '_' in_pom '00' num2str(i)];
    elseif (i<100)
        imname= [ 'riga_na_na_'  fol '_' in_pom '0' num2str(i)];
    else
        imname= [ 'riga_na_na_'  fol '_' in_pom num2str(i)];
    end
    
    if fold(ind(end)-8:ind(end)-1)==string('Magrabia')
        degree=35;
    end
    
    for h=1:6
        if fol(1:5)==string('BinRu') && ~((fol(end-5:end)==string('rected') && h==3)&& str2num(in(6:end))<25 )
        gt=imread([images(i).folder '\' in '-' num2str(h) '.jpg' ]);
        else
        gt=imread([images(i).folder '\' in '-' num2str(h) '.tif' ]);
        end
        mask1=(rgb2gray(im2double(im))-rgb2gray(im2double(gt)));
        mask2=mat2gray(mask1);
        [mask3,~] = imgradient(mask2);
        mask4=imbinarize(mask3,0.4);
        mask=bwlabel(imclose(imclose(mask4,se),se));
        S = regionprops(mask,'area');
        [B,Ind] = sort(struct2array(S));
        disc=zeros(size(mask));
        disc(mask==Ind(end))=1;
        disc=imfill(disc,'hole');
        if length(Ind)<2
            ed=edge(disc);
            ed_disc = imdilate(ed,strel('diamond',12));
            mask(ed_disc)=mask(ed_disc)./2;
            mask=mask*2;
            S = regionprops(mask,'area');
            [B,Ind] = sort(struct2array(S));
        end
            
        cup1=zeros(size(mask));
        cup1(mask==Ind(end-1))=1;
        cup=imfill(cup1,'hole');
        
       if ((sum(disc(:)==cup(:)))/size(disc,1)*size(disc,2))>=0.99
            ed=edge(disc);
            ed_disc = imdilate(ed,strel('diamond',12));
            mask(ed_disc)=mask(ed_disc)./2;
            mask=mask*2;
            S = regionprops(mask,'area');
            [B,Ind] = sort(struct2array(S));
            cup=zeros(size(mask));
            cup(mask==Ind(end-1))=1;
            cup=imfill(cup,'hole');
       end

       cup=logical(cup);
       disc=logical(disc);
  
        [I,D,C,~, fov]=image_adjustment(im,rc,degree,disc,cup,0, 'riga', 0);


%         [I_mod]=modifikace_jasu(I,fov,sigma,Num_tiles_param,ClipLimit);
        [I_mod]=local_contrast_and_clahe(I,fov);


        if (h==1)
            imwrite(C,[path '\Cup\Magrabia\expert1\' imname '_cup_exp_' num2str(h) '.png'])
            imwrite(D,[path '\Disc\Magrabia\expert1\' imname '_disc_exp_' num2str(h) '.png'])
        elseif (h==2)
            imwrite(C,[path '\Cup\Magrabia\expert2\' imname '_cup_exp_' num2str(h) '.png'])
            imwrite(D,[path '\Disc\Magrabia\expert2\' imname '_disc_exp_' num2str(h) '.png'])
        elseif (h==3)
            imwrite(C,[path '\Cup\Magrabia\expert3\' imname '_cup_exp_' num2str(h) '.png'])
            imwrite(D,[path '\Disc\Magrabia\expert3\' imname '_disc_exp_' num2str(h) '.png'])
        elseif (h==4)
            imwrite(C,[path '\Cup\Magrabia\expert4\' imname '_cup_exp_' num2str(h) '.png'])
            imwrite(D,[path '\Disc\Magrabia\expert4\' imname '_disc_exp_' num2str(h) '.png'])
        elseif (h==5)
            imwrite(C,[path '\Cup\Magrabia\expert5\' imname '_cup_exp_' num2str(h) '.png'])
            imwrite(D,[path '\Disc\Magrabia\expert5\' imname '_disc_exp_' num2str(h) '.png'])
        else
            imwrite(C,[path '\Cup\Magrabia\expert6\' imname '_cup_exp_' num2str(h) '.png'])
            imwrite(D,[path '\Disc\Magrabia\expert6\' imname '_disc_exp_' num2str(h) '.png'])
        end
 
    end
    imwrite(I,[path '\Images_orig\Magrabia\' imname '.png'])
    imwrite(fov,[path '\Fov\Magrabia\' imname '_fov.png'])
    imwrite(I_mod,[path '\Images\Magrabia\' imname '.png'])

end
end