function[] = load_mereni_UBMI(rc, path, sigma_preprocesing, Num_tiles_param, ClipLimit)
%%
% Funkce pro předzpracování databáze, využívají se zde funkce
% image_adjustment a modifikace jasu
% rc - int - Nastaveni na jake rozlišeni počtu px na stupen se má převzorkovat
% path - string - cesta k datům
% sigma, Num_tiles_param, ClipLimit - int - Nastavení parametrů pro modifikaci jasu
%%
% rozlišení databáze
degree = 45;

%% UBMI
images = dir([path 'UBMI_mereni_orig\Images\*.png']);
for i=1:length(images)
    
    in=images(i).name(1:end-4);
    
    im=imread([path 'UBMI_mereni_orig\Images\' images(i).name ]);
    fov=imread([path 'UBMI_mereni_orig\Fov\' in '_fov.png']);
    
    % Převzorkování dat
    [I,~,~,~, FOV]=image_adjustment(im,rc,degree,0,0,0, 'hrf', fov);
    
    % Normalizace dat
    [I_mod]=modifikace_jasu(I,FOV,sigma_preprocesing,Num_tiles_param,ClipLimit);
    
    imname= in ;
    imwrite(im,[path '\Images_orig_full\' imname '.png'])
    imwrite(I,[path '\Images_orig\' imname '.png'])
    imwrite(I_mod,[path '\Images\' imname '.png'])
    imwrite(FOV,[path '\Fov\' imname '_fov.png'])

end
end