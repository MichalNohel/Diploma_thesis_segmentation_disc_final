function[center_new] = Detection_of_disc(image,fov,sigma,velikost_erodovani)
%     image=im2double(image);
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