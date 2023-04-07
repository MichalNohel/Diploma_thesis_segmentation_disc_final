# -*- coding: utf-8 -*-
"""
Created on Fri Apr  7 22:36:41 2023

@author: nohel
"""


import os
join = os.path.join
from typing import List
from skimage import io
import numpy as np
import SimpleITK as sitk

def convert_2d_image_to_nifti(input_filename: str, output_filename_truncated: str, spacing=(999, 1, 1),
                              transform=None, is_seg: bool = False) -> None:
    """
    Reads an image (must be a format that it recognized by skimage.io.imread) and converts it into a series of niftis.
    The image can have an arbitrary number of input channels which will be exported separately (_0000.nii.gz,
    _0001.nii.gz, etc for images and only .nii.gz for seg).
    Spacing can be ignored most of the time.
    !!!2D images are often natural images which do not have a voxel spacing that could be used for resampling. These images
    must be resampled by you prior to converting them to nifti!!!

    Datasets converted with this utility can only be used with the 2d U-Net configuration of nnU-Net

    If Transform is not None it will be applied to the image after loading.

    Segmentations will be converted to np.uint32!

    :param is_seg:
    :param transform:
    :param input_filename:
    :param output_filename_truncated: do not use a file ending for this one! Example: output_name='./converted/image1'. This
    function will add the suffix (_0000) and file ending (.nii.gz) for you.
    :param spacing:
    :return:
    """
    img = io.imread(input_filename)

    if transform is not None:
        img = transform(img)

    if len(img.shape) == 2:  # 2d image with no color channels
        img = img.transpose((1, 0))
        img = img[None, None]  # add dimensions
    else:
        assert len(img.shape) == 3, "image should be 3d with color channel last but has shape %s" % str(img.shape)
        # we assume that the color channel is the last dimension. Transpose it to be in first
        img = img.transpose((2, 1, 0))
        # add third dimension
        img = img[:, None]

    # image is now (c, x, x, z) where x=1 since it's 2d
    if is_seg:
        assert img.shape[0] == 1, 'segmentations can only have one color channel, not sure what happened here'

    for j, i in enumerate(img):

        if is_seg:
            i = i.astype(np.uint32)

        itk_img = sitk.GetImageFromArray(i)
        itk_img.SetSpacing(list(spacing)[::-1])
        if not is_seg:
            sitk.WriteImage(itk_img, output_filename_truncated + "_%04.0d.nii.gz" % j)
        else:
            sitk.WriteImage(itk_img, output_filename_truncated + ".nii.gz")


def maybe_mkdir_p(directory: str) -> None:
    os.makedirs(directory, exist_ok=True)
    
def subfiles(folder: str, join: bool = True, prefix: str = None, suffix: str = None, sort: bool = True) -> List[str]:
    if join:
        l = os.path.join
    else:
        l = lambda x, y: y
    res = [l(folder, i) for i in os.listdir(folder) if os.path.isfile(os.path.join(folder, i))
           and (prefix is None or i.startswith(prefix))
           and (suffix is None or i.endswith(suffix))]
    if sort:
        res.sort()
    return res   

if __name__ == "__main__":
        
    base = 'D:\DATA_DP_oci\Data_mereni_UBMI_35px'
    sada1='Orig_sada01'
    sada2='Orig_sada02'
    base_sada1=join(base, sada1, 'Images') 
    base_sada2=join(base, sada2, 'Images') 
    
    target_sada1 = join(base, "nnUNet_sada01")
    target_sada2 = join(base, "nnUNet_sada02")
    
    maybe_mkdir_p(target_sada1)
    maybe_mkdir_p(target_sada2)
    
    training_cases_sada1 = subfiles(base_sada1, suffix='.png', join=False)  
    training_cases_sada2 = subfiles(base_sada2, suffix='.png', join=False) 
    
    for t in training_cases_sada1:
        unique_name = t[:-4]  # just the filename with the extension cropped away, so img-2.png becomes img-2 as unique_name
        input_image_file = join(base_sada1, t)

        output_image_file = join(target_sada1, unique_name)  # do not specify a file ending! This will be done for you
   
        convert_2d_image_to_nifti(input_image_file, output_image_file, is_seg=False)
    
    for t in training_cases_sada2:
        unique_name = t[:-4]  # just the filename with the extension cropped away, so img-2.png becomes img-2 as unique_name
        input_image_file = join(base_sada2, t)

        output_image_file = join(target_sada2, unique_name)  # do not specify a file ending! This will be done for you
   
        convert_2d_image_to_nifti(input_image_file, output_image_file, is_seg=False)

    
    
    
    
    
    