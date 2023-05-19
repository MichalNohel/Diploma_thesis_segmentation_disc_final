clear all
close all
clc 
%%
% Skript který vytvoří adresář nutný pro předzpracování dat

% path=cd;  %cesta do složky, kde bude vytvořen adresář pro předzpracování dat
path='D:\DATA_DP_oci\Preprocesing_35px';
if ~exist(path, 'dir')
    mkdir(path)
end 

% Vytváření jednotlivých adresářů dle potřeb daných databází a složek pro
% předzpracování a vytvoření nových databází
%% Drishti-GS
name='\Drishti-GS';
if ~exist([path name], 'dir')
    mkdir([path name])
    mkdir([path name name])
    basic_folder_creation ([path name])
end

if ~exist([path name '\Cup\expert1'], 'dir')
    mkdir([path name '\Cup\expert1'])
end
if ~exist([path name '\Cup\expert2'], 'dir')
    mkdir([path name '\Cup\expert2'])
end
if ~exist([path name '\Cup\expert3'], 'dir')
    mkdir([path name '\Cup\expert3'])
end
if ~exist([path name '\Cup\expert4'], 'dir')
    mkdir([path name '\Cup\expert4'])
end
if ~exist([path name '\Disc\expert1'], 'dir')
    mkdir([path name '\Disc\expert1'])
end
if ~exist([path name '\Disc\expert2'], 'dir')
    mkdir([path name '\Disc\expert2'])
end
if ~exist([path name '\Disc\expert3'], 'dir')
    mkdir([path name '\Disc\expert3'])
end
if ~exist([path name '\Disc\expert4'], 'dir')
    mkdir([path name '\Disc\expert4'])
end
%% HRF
name='\HRF';
if ~exist([path name], 'dir')
    mkdir([path name])
    mkdir([path name name])
    basic_folder_creation ([path name])
    mkdir([path name '\Vessels'])
end

%% REFUGE
name='\REFUGE';
if ~exist([path name], 'dir')
    mkdir([path name])
    mkdir([path name name])
    basic_folder_creation ([path name])
    special_folder_creation ([path name '\Cup'],2)
    special_folder_creation ([path name '\Disc'],2)
    special_folder_creation ([path name '\Fov'],2)
    special_folder_creation ([path name '\Images'],2)
    special_folder_creation ([path name '\Images_orig'],2)
end


%% RIGA
name='\RIGA';
if ~exist([path name], 'dir')
    mkdir([path name])
    mkdir([path name name])
    basic_folder_creation ([path name])
    special_folder_creation ([path name '\Cup'],0)
    special_folder_creation ([path name '\Disc'],0)
    special_folder_creation ([path name '\Fov'],1)
    special_folder_creation ([path name '\Images'],1)
    special_folder_creation ([path name '\Images_orig'],1)
end

%% RIM-ONE
name='\RIM-ONE';
if ~exist([path name], 'dir')
    mkdir([path name])
    mkdir([path name name])
    basic_folder_creation ([path name])
    special_folder_creation ([path name '\Cup'],3)
    special_folder_creation ([path name '\Disc'],3)
    special_folder_creation ([path name '\Fov'],3)
    special_folder_creation ([path name '\Images'],3)
    special_folder_creation ([path name '\Images_orig'],3)
end

%% UoA_DR
name='\UoA_DR';
if ~exist([path name], 'dir')
    mkdir([path name])
    mkdir([path name name])
    basic_folder_creation ([path name])
    mkdir([path name '\Vessels'])
    special_folder_creation ([path name '\Cup'],4)
    special_folder_creation ([path name '\Disc'],4)
    special_folder_creation ([path name '\Fov'],4)
    special_folder_creation ([path name '\Images'],4)
    special_folder_creation ([path name '\Images_orig'],4)
    special_folder_creation ([path name '\Vessels'],4)
end

%%

function [] = basic_folder_creation (of)
    if ~exist([of '\Images'], 'dir')
        mkdir([of '\Images'])
    end
    if ~exist([of '\Images_orig'], 'dir')
        mkdir([of '\Images_orig'])
    end
    if ~exist([of '\Disc'], 'dir')
        mkdir([of '\Disc'])
    end
    if ~exist([of '\Cup'], 'dir')
        mkdir([of '\Cup'])
    end
    if ~exist([of '\Fov'], 'dir')
        mkdir([of '\Fov'])
    end
end

function [] = special_folder_creation (path,style)
    
    if style==0
        if ~exist([path '\BinRushed\expert1'], 'dir')
            mkdir([path  '\BinRushed\expert1'])
        end
        if ~exist([path '\BinRushed\expert2'], 'dir')
            mkdir([path  '\BinRushed\expert2'])
        end
        if ~exist([path '\BinRushed\expert3'], 'dir')
            mkdir([path  '\BinRushed\expert3'])
        end
        if ~exist([path '\BinRushed\expert4'], 'dir')
            mkdir([path  '\BinRushed\expert4'])
        end
        if ~exist([path '\BinRushed\expert5'], 'dir')
            mkdir([path  '\BinRushed\expert5'])
        end
        if ~exist([path '\BinRushed\expert6'], 'dir')
            mkdir([path  '\BinRushed\expert6'])
        end
    
        if ~exist([path '\Magrabia\expert1'], 'dir')
            mkdir([path  '\Magrabia\expert1'])
        end
        if ~exist([path '\Magrabia\expert2'], 'dir')
            mkdir([path  '\Magrabia\expert2'])
        end
        if ~exist([path '\Magrabia\expert3'], 'dir')
            mkdir([path  '\Magrabia\expert3'])
        end
        if ~exist([path '\Magrabia\expert4'], 'dir')
            mkdir([path  '\Magrabia\expert4'])
        end
        if ~exist([path '\Magrabia\expert5'], 'dir')
            mkdir([path  '\Magrabia\expert5'])
        end
        if ~exist([path '\Magrabia\expert6'], 'dir')
            mkdir([path  '\Magrabia\expert6'])
        end
    
        if ~exist([path '\MESSIDOR\expert1'], 'dir')
            mkdir([path  '\MESSIDOR\expert1'])
        end
        if ~exist([path '\MESSIDOR\expert2'], 'dir')
            mkdir([path  '\MESSIDOR\expert2'])
        end
        if ~exist([path '\MESSIDOR\expert3'], 'dir')
            mkdir([path  '\MESSIDOR\expert3'])
        end
        if ~exist([path '\MESSIDOR\expert4'], 'dir')
            mkdir([path  '\MESSIDOR\expert4'])
        end
        if ~exist([path '\MESSIDOR\expert5'], 'dir')
            mkdir([path  '\MESSIDOR\expert5'])
        end
        if ~exist([path '\MESSIDOR\expert6'], 'dir')
            mkdir([path  '\MESSIDOR\expert6'])
        end
    end

    if style ==1
        if ~exist([path '\BinRushed'], 'dir')
            mkdir([path  '\BinRushed'])
        end
        if ~exist([path '\Magrabia'], 'dir')
            mkdir([path  '\Magrabia'])
        end
        if ~exist([path '\MESSIDOR'], 'dir')
            mkdir([path  '\MESSIDOR'])
        end
    end

    if style ==2
        if ~exist([path '\Train'], 'dir')
            mkdir([path  '\Train'])
        end
        if ~exist([path '\Test'], 'dir')
            mkdir([path  '\Test'])
        end
        if ~exist([path '\Validation'], 'dir')
            mkdir([path  '\Validation'])
        end
    end

    if style ==3
        if ~exist([path '\Glaucoma'], 'dir')
            mkdir([path  '\Glaucoma'])
        end
        if ~exist([path '\Healthy'], 'dir')
            mkdir([path  '\Healthy'])
        end
    end

    if style ==4
        if ~exist([path '\NDPR'], 'dir')
            mkdir([path  '\NDPR'])
        end
        if ~exist([path '\PDR'], 'dir')
            mkdir([path  '\PDR'])
        end
        if ~exist([path '\Healthy'], 'dir')
            mkdir([path  '\Healthy'])
        end
    end
end