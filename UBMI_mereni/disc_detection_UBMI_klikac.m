function []=disc_detection_UBMI_klikac(path, sigma_detection,size_of_erosion)


%% UBMI
images = dir([path 'Images\*.png']);
center_new_UBMI_mereni=[];
imname={};
num_of_error=0;

for i=1:length(images)
    
    in=images(i).name(1:end-4);    
    im=imread([path 'Images\' images(i).name ]);
    fov=imread([path 'Fov\' in '_fov.png']);

    [center_new] = Detection_of_disc(im,fov,sigma_detection,size_of_erosion);
    figure
    imshow(im)
    hold on
    stem(center_new(1),center_new(2),'g','MarkerSize',16,'LineWidth',2)
    pause(1)
    answer= questdlg('Is detected optic disc?','Optic disc detection','Yes','No','Yes');

    switch answer
        case 'Yes'
            center_new_UBMI_mereni(i,1)=center_new(1);
            center_new_UBMI_mereni(i,2)=center_new(2);
        case 'No'
            imshow(im)
            [x,y] = ginput(1);
            center_new_UBMI_mereni(i,1)=round(x);
            center_new_UBMI_mereni(i,2)=round(y);
            num_of_error=num_of_error+1;
    end
    close all

    imname{i,1}= in ;
end


%% save of test discs centers without mistakes
Disc_centres_test=center_new_UBMI_mereni-1;
save([path 'Disc_centres_test_UBMI.mat'],'Disc_centres_test')



