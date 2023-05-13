sigma=25;
size_of_erosion=40;
%%
path = pwd;
path= [path '\'];

%% HRF
images = dir([path 'Images\*.png']);
center_new_UBMI_mereni=[];
imname={};

for i=1:length(images)
    
    in=images(i).name(1:end-4);    
    im=imread([path 'Images\' images(i).name ]);
    fov=imread([path 'Fov\' in '_fov.png']);

    [center_new] = Detection_of_disc(im,fov,sigma,size_of_erosion);
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
    end
    close all

    imname{i,1}= in ;
end

%% ulozeni do excelu
UBMI_disc_coordinate=table(imname,center_new_UBMI_mereni(:,1),center_new_UBMI_mereni(:,2),'VariableNames',{'name','x-coordinates','y-coordinates'})
writetable(UBMI_disc_coordinate,'UBMI_disc_coordinate_orig.csv',"Delimiter",",");

%% ulozeni do Json
s = struct();
s.name=imname;
s.x_coordinates=center_new_UBMI_mereni(:,1);
s.y_coordinates=center_new_UBMI_mereni(:,2);
json_data = jsonencode(s);
fname = 'UBMI_disc_coordinate_orig.json';
fileID = fopen(fname,'w');
fprintf(fileID, json_data);
fclose(fileID);

%% Functions
function[center_new] = Detection_of_disc(image,fov,sigma,velikost_erodovani)
image=rgb2xyz(im2double(image));
image=rgb2gray(image);
BW=imerode(fov,strel('disk',velikost_erodovani));
vertical_len=size(BW,1);
step=round(vertical_len/15);
BW(1:step,:)=0;
BW(vertical_len-step:vertical_len,:)=0;
image(~BW)=0;
img_filt=imgaussfilt(image,sigma);
img_filt(~BW)=0;
[r, c] = find(img_filt == max(img_filt(:)));
center_new(1)=c;
center_new(2)=r;
end
