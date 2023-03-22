# -*- coding: utf-8 -*-
"""
Created on Wed Mar 22 12:55:33 2023

@author: nohel
"""


import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F 
import glob
from skimage.io import imread
from skimage.color import rgb2gray,rgb2hsv,rgb2xyz
from skimage.morphology import disk,remove_small_objects, binary_closing, binary_opening
from skimage.filters import gaussian

from scipy.ndimage import binary_erosion 
from scipy.ndimage.morphology import binary_fill_holes
import torchvision.transforms.functional as TF
from torch.nn import init
import matplotlib.pyplot as plt
from scipy.io import loadmat

import json
from json import JSONEncoder


## Dataloader

class DataLoader(torch.utils.data.Dataset):
    def __init__(self,split="Train",output_size=(int(448),int(448),int(3)),path_to_data="D:\Diploma_thesis_segmentation_disc_v2\Data_480_480_35px_preprocesing_all_database"):
        self.split=split
        self.output_size=output_size
        
        if split=="Train":
            self.path_to_data=path_to_data+ '/' +split
            self.files_img=glob.glob(self.path_to_data+'/Images_crop/*.png')
            self.files_img_orig=glob.glob(self.path_to_data+'/Images_orig_crop/*.png')
            self.files_disc=glob.glob(self.path_to_data+'/Disc_crop/*.png')
            self.files_cup=glob.glob(self.path_to_data+'/Cup_crop/*.png')
            self.files_img.sort()
            self.files_img_orig.sort()
            self.files_disc.sort()
            self.files_cup.sort()
            self.num_of_imgs=len(self.files_img)
            
        if split=="Test":
            self.path_to_data=path_to_data+ '/' +split
            self.files_img=glob.glob(self.path_to_data+'/Images/*.png')
            self.files_img_orig=glob.glob(self.path_to_data+'/Images_orig/*.png')
            self.files_disc=glob.glob(self.path_to_data+'/Disc/*.png')
            self.files_cup=glob.glob(self.path_to_data+'/Cup/*.png')
            self.files_fov=glob.glob(self.path_to_data+'/Fov/*.png')
            self.disc_centres_test=loadmat(self.path_to_data+'/Disc_centres_test.mat')          
            self.num_of_imgs=len(self.files_img)
        
        if split=="UBMI":
            self.path_to_data=path_to_data
            self.files_img=glob.glob(self.path_to_data+'/Images/*.png')
            self.files_img_orig=glob.glob(self.path_to_data+'/Images_orig/*.png')
            self.files_img_orig_full=glob.glob(self.path_to_data+'/Images_orig_full/*.png')
            self.files_disc=glob.glob(self.path_to_data+'/Disc/*.png')
            self.files_cup=glob.glob(self.path_to_data+'/Cup/*.png')
            self.files_fov=glob.glob(self.path_to_data+'/Fov/*.png')
            self.disc_centres_test=loadmat(self.path_to_data+'/Disc_centres_test_UBMI.mat')          
            self.num_of_imgs=len(self.files_img)

    def __len__(self):
        return self.num_of_imgs
    
    def __getitem__(self,index):
        #Load of Train images
        if self.split=="Train":
            # Data loading
            img=imread(self.files_img[index])
            img_orig=imread(self.files_img_orig[index])
            disc=imread(self.files_disc[index]).astype(bool)
            cup=imread(self.files_cup[index]).astype(bool)
            
            # input and output size setting
            output_size=self.output_size
            input_size=img.shape
            
            #Preprocesing of img            
            img,img_orig,disc,cup=self.random_crop(input_size,output_size,img,img_orig,disc,cup)
            img,img_orig,disc,cup=self.random_rotflip(img,img_orig,disc,cup)            
            img_orig=img_orig.astype(np.float32)
            
            #Creation of labels masks: batch x width x height            
            mask_output_size=(int(2),output_size[0],output_size[1]) # output size of image
            mask_output=np.zeros(mask_output_size)
            mask_output[0,:,:]=disc
            mask_output[1,:,:]=cup
            
            mask_output=mask_output.astype(bool)
            img=TF.to_tensor(img)
            img_orig=TF.to_tensor(img_orig)
            mask=torch.from_numpy(mask_output)
            return img,img_orig,mask
    
        if self.split=="Test":
            # Data loading
            img_full=imread(self.files_img[index])
            img_orig_full=imread(self.files_img_orig[index])
            disc_orig=imread(self.files_disc[index]).astype(bool)
            cup_orig=imread(self.files_cup[index]).astype(bool)
            fov_orig=imread(self.files_fov[index]).astype(bool)
            
            # output size setting
            output_size=self.output_size
            
            
            # Cropping of image for segmentation, position of disc were detected in preprocessing step  
            # 
            output_crop_image,output_crop_orig_image, output_mask_disc,output_mask_cup=Crop_image(img_full,img_orig_full,disc_orig,cup_orig,output_size, self.disc_centres_test.get('Disc_centres_test')[index])
            
            
            
            img_orig_crop=output_crop_orig_image.astype(np.float32)
            
            #Preprocesing of img
            if(self.color_preprocesing=="RGB"):
                img_crop=output_crop_image.astype(np.float32)
                
            if(self.color_preprocesing=="gray"):
                img_crop=rgb2gray(output_crop_image).astype(np.float32)              
            
            if(self.color_preprocesing=="HSV"):
                img_crop=rgb2hsv(output_crop_image).astype(np.float32)
                
            if(self.color_preprocesing=="XYZ"):
                img_crop=rgb2xyz(output_crop_image).astype(np.float32)
            
            #Creation of labels masks: batch x width x height
            if(self.segmentation_type=="disc"):
                mask_output_size=(int(1),output_size[0],output_size[1]) # output size of image
                mask_output=np.zeros(mask_output_size)
                mask_output[0,:,:]=output_mask_disc                
            elif(self.segmentation_type=="cup"):
                mask_output_size=(int(1),output_size[0],output_size[1]) # output size of image
                mask_output=np.zeros(mask_output_size)
                mask_output[0,:,:]=output_mask_cup
            elif(self.segmentation_type=="disc_cup"):
                mask_output_size=(int(2),output_size[0],output_size[1]) # output size of image
                mask_output=np.zeros(mask_output_size)
                mask_output[0,:,:]=output_mask_disc
                mask_output[1,:,:]=output_mask_cup
            else:
                print("Wrong type of segmentation")
                
            mask_output=mask_output.astype(bool)
            img_crop=TF.to_tensor(img_crop)
            img_orig_crop=TF.to_tensor(img_orig_crop)
            mask_output=torch.from_numpy(mask_output)
            coordinates=self.disc_centres_test.get('Disc_centres_test')[index].astype(np.int16)
            return img_crop,img_orig_crop, mask_output, img_full, img_orig_full, disc_orig,cup_orig, coordinates
    
    
    
    
# Function for disc detection and croping of image
def Detection_of_disc(image,fov,sigma,size_of_erosion):    
    img=rgb2xyz(image).astype(np.float32)
    img=rgb2gray(img).astype(np.float32)
    BW=binary_erosion(fov,disk(size_of_erosion))
    vertical_len=BW.shape[0]
    step=round(vertical_len/15);
    BW[0:step,:]=0;
    BW[vertical_len-step:vertical_len,:]=0;
    img[~BW]=0;
    img_filt=gaussian(img,sigma);
    img_filt[~BW]=0;
    max_xy = np.where(img_filt == img_filt.max() )
    r=max_xy[0][0]
    c=max_xy[1][0]
    center_new=[]
    center_new.append(c)
    center_new.append(r)
    return center_new

def Crop_image(image,image_orig,mask_disc,mask_cup,output_image_size,center_new): 
    size_in_img=image.shape
    x_half=int(output_image_size[0]/2)
    y_half=int(output_image_size[1]/2)  
    
    if ((center_new[1]-x_half)<0):
        x_start=0
    elif ((center_new[1]+x_half)>size_in_img[0]):
        x_start=size_in_img[0]-output_image_size[0]
    else:
        x_start=center_new[1]-x_half           
    
    if ((center_new[0]-y_half)<0):
        y_start=0
    elif ((center_new[0]+y_half)>size_in_img[1]):
        y_start=size_in_img[1]-output_image_size[1]
    else:
        y_start=center_new[0]-y_half
    
    output_crop_image=image[x_start:x_start+output_image_size[0],y_start:y_start+output_image_size[1],:]
    output_crop_orig_image=image_orig[x_start:x_start+output_image_size[0],y_start:y_start+output_image_size[1],:]
    output_mask_disc=mask_disc[x_start:x_start+output_image_size[0],y_start:y_start+output_image_size[1]]
    output_mask_cup=mask_cup[x_start:x_start+output_image_size[0],y_start:y_start+output_image_size[1]]
    return output_crop_image, output_crop_orig_image,output_mask_disc,output_mask_cup
