function [] = folder_creation (of)
if ~exist([of '\Images'], 'dir')
    mkdir([of '\Images'])
end
if ~exist([of '\Images_orig'], 'dir')
    mkdir([of '\Images_orig'])
end
if ~exist([of '\Fov'], 'dir')
    mkdir([of '\Fov'])
end
if ~exist([of '\Images_orig_full'], 'dir')
    mkdir([of '\Images_orig_full'])
end
end