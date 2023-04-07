function [output_final]=Postprocesing(output,min_size,type_of_morphing,size_of_disk,ploting) 

if sum(output)==0
    output_final=output;
    return
end

output_final=imfill(output,'holes');
output_final=bwareaopen(output_final,min_size);

padding=50;

output_final=padarray(output_final,[padding, padding],0,'both');

if (type_of_morphing=="closing")
    output_final=imclose(output_final,strel('disk',size_of_disk));
elseif (type_of_morphing=="openinig")
        output_final=imopen(output_final,strel('disk',size_of_disk));
elseif (type_of_morphing=="closing_opening")
    output_final=imclose(output_final,strel('disk',size_of_disk));
    output_final=imopen(output_final,strel('disk',size_of_disk));
elseif (type_of_morphing=="opening_closing")
    output_final=imopen(output_final,strel('disk',size_of_disk)) ;
    output_final=imclose(output_final,strel('disk',size_of_disk)) ;
end

output_final=output_final(padding:size(output_final,1)-padding-1,padding:size(output_final,2)-padding-1);

if ploting       
    figure
    subplot(1,2,1)
    imshow(output)
    title('Po vystupu sítě')    
    
    subplot(1,2,2)
    imshow(output_final)
    title('Postprocesing')
    
end
end