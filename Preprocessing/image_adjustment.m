function [I2,M1,M2,M3,F]=image_adjustment(im,rc,degree,M1,M2,M3, dat, fov)
%%
% Funkce, která ořeže data podle FOV a převzorkuje data na požadované rozlišení a vrací je zpět
%%
im=im2double(im);
[rad,sloup,polomer,fov]=souradnice(im, dat, fov);

minr=(rad-polomer)*(polomer<rad)+1*(polomer>=rad);
maxr=(rad+polomer)*(size(im,1)>=(rad+polomer))+size(im,1)*(size(im,1)<(rad+polomer));
minc=(sloup-polomer)*(polomer<sloup)+1*(polomer>=sloup);
maxc=(sloup+polomer)*(size(im,2)>=(sloup+polomer))+size(im,2)*(size(im,2)<(sloup+polomer));

I = im(minr:maxr,minc:maxc,:);
I2=imresize(I,(rc*degree)/length(I)); 

F = fov(minr:maxr,minc:maxc,:);
F=imresize(F,(rc*degree)/length(I),'nearest'); 

if length(M1)>5
    M1 = M1(minr:maxr,minc:maxc,:);
    M1=imresize(M1,(rc*degree)/length(I),'nearest'); 
end
if length(M2)>5
    M2 = M2(minr:maxr,minc:maxc,:);
    M2=imresize(M2,(rc*degree)/length(I),'nearest');   
end
if length(M3)>5
    M3 = M3(minr:maxr,minc:maxc,:);
    M3=imresize(M3,(rc*degree)/length(I),'nearest');  
end
end