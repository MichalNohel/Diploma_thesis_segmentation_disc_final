# -*- coding: utf-8 -*-
"""
Created on Sun Mar 26 17:00:35 2023

@author: nohel
"""

from functions_MAIN_Part2 import maybe_mkdir_p,subfiles,convert_2d_image_to_nifti,generate_dataset_json
import os
join = os.path.join

if __name__ == "__main__":
        
    base = 'D:\DATA_DP_oci\Data_25px_nn_unet'
    
    task_id = 725
    task_name = "Optic_disc_cup_segm_25px"
    foldername = "Task%03.0d_%s" % (task_id, task_name)
    out_base = join(base, foldername)  
    
    maybe_mkdir_p(out_base)    
    target_imagesTr = join(out_base, "imagesTr")
    target_imagesTs = join(out_base, "imagesTs")
    target_labelsTr = join(out_base, "labelsTr")
    target_labelsTs = join(out_base, "labelsTs")
    
    maybe_mkdir_p(target_imagesTr)
    maybe_mkdir_p(target_labelsTs)
    maybe_mkdir_p(target_imagesTs)
    maybe_mkdir_p(target_labelsTr)

    labels_dir_tr = join(base, 'training', 'output')
    images_dir_tr = join(base, 'training', 'input')
    training_cases = subfiles(labels_dir_tr, suffix='.png', join=False)    
    
    for t in training_cases:
        unique_name = t[:-4]  # just the filename with the extension cropped away, so img-2.png becomes img-2 as unique_name
        input_segmentation_file = join(labels_dir_tr, t)
        input_image_file = join(images_dir_tr, t)

        output_image_file = join(target_imagesTr, unique_name)  # do not specify a file ending! This will be done for you
        output_seg_file = join(target_labelsTr, unique_name)  # do not specify a file ending! This will be done for you

   
        convert_2d_image_to_nifti(input_image_file, output_image_file, is_seg=False)
        convert_2d_image_to_nifti(input_segmentation_file, output_seg_file, is_seg=True)        
        
    # now do the same for the test set
    labels_dir_ts = join(base, 'testing', 'output')
    images_dir_ts = join(base, 'testing', 'input')
    testing_cases = subfiles(labels_dir_ts, suffix='.png', join=False)
    for ts in testing_cases:
        unique_name = ts[:-4]
        input_segmentation_file = join(labels_dir_ts, ts)
        input_image_file = join(images_dir_ts, ts)
         
        output_image_file = join(target_imagesTs, unique_name)
        output_seg_file = join(target_labelsTs, unique_name)
         
        convert_2d_image_to_nifti(input_image_file, output_image_file, is_seg=False)
        convert_2d_image_to_nifti(input_segmentation_file, output_seg_file, is_seg=True)
   
    #%%
    #finally we can call the utility for generating a dataset.json
    generate_dataset_json(join(out_base, 'dataset.json'), target_imagesTr, target_imagesTs, ('Red', 'Green', 'Blue'),
                         labels={0: 'background', 1: 'disc',2: 'cup'}, dataset_name=task_name, license='hands off!')
    


    
    
    
    
