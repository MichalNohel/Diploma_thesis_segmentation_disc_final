# -*- coding: utf-8 -*-
"""
Created on Fri Apr  7 14:57:51 2023

@author: nohel

Skript pro intereferenci klasického U-Netu na databázi UBMI 
"""


from Function_final import DataLoader,Unet
import matplotlib.pyplot as plt
import torch
import os
import numpy as np 
from skimage.io import imsave
from skimage import  img_as_ubyte
from skimage.transform import resize

if __name__ == "__main__": 
    ZAPISOVAT=True
    #ZAPISOVAT_KONTURY=True
    
    batch=1 
    threshold=0.5
    
    # %%
    #Rozliseni_360_360_25px  
    
    # #SADA01
    # # path_to_data="D:\DATA_DP_oci\Data_mereni_UBMI_25px\Orig_sada01"
    # # path_to_results="D:\DATA_DP_oci/Vysledky/Rozliseni_25px/Sada01_Output_unet/"  
    
    # #SADA02
    # path_to_data="D:\DATA_DP_oci\Data_mereni_UBMI_25px\Orig_sada02"
    # path_to_results="D:\DATA_DP_oci/Vysledky/Rozliseni_25px/Sada02_Output_unet/"
    
    # output_size=(int(320),int(320),int(3)) #Velikost vstupu síte 
    
    # sigma_detection=25
    # size_of_erosion=40
    # OD_center_available=True
    
    # # Cesta k naucenemu modelu
    # path_to_save_model="D:\Diploma_thesis_segmentation_disc_v2/Diploma_thesis_segmentation_disc_final/Trained_models_final/U_net_res_25px_sigma_50/"
     
    # name_of_model='model_Unet_25px_sigma_50_OS_320_320_3'
    
    # net=Unet(out_size=2).cuda()  
    # net.load_state_dict(torch.load(path_to_save_model+ name_of_model+ '.pth'))    
    
    # isExist = os.path.exists(path_to_results)
    # if not isExist:
    #     os.makedirs(path_to_results)
    
    # %%
    #Rozliseni_500_500_35px
    
    #SADA01
    path_to_data="D:\DATA_DP_oci\Data_mereni_UBMI_35px\Orig_sada01"
    path_to_results="D:\DATA_DP_oci/Vysledky/Rozliseni_35px/Sada01_Output_unet/"  
    
    #SADA02
    # path_to_data="D:\DATA_DP_oci\Data_mereni_UBMI_35px\Orig_sada02"
    # path_to_results="D:\DATA_DP_oci/Vysledky/Rozliseni_35px/Sada02_Output_unet/"
    
    output_size=(int(448),int(448),int(3))  #Velikost vstupu síte 
    
    sigma_detection=45
    size_of_erosion=40
    OD_center_available=False
    
    # Cesta k naucenemu modelu
    path_to_save_model="D:\Diploma_thesis_segmentation_disc_v2/Diploma_thesis_segmentation_disc_final/Trained_models_Unet_final/U_net_res_35px_sigma_75/"
     
    name_of_model='model_Unet_35px_sigma_75_OS_448_448_3'
    
    net=Unet(out_size=2).cuda()  
    net.load_state_dict(torch.load(path_to_save_model+ name_of_model+ '.pth'))    
    
    isExist = os.path.exists(path_to_results)
    if not isExist:
        os.makedirs(path_to_results)
    
    #%%
    net.eval()     
    batch=1    
    loader=DataLoader(split="UBMI",path_to_data=path_to_data,output_size=output_size,OD_center_available=OD_center_available,sigma_detection=sigma_detection,size_of_erosion=size_of_erosion)
    UBMI_loader=torch.utils.data.DataLoader(loader,batch_size=batch, num_workers=0, shuffle=False)
    test_files_name=UBMI_loader.dataset.files_img
    
    #%%

    for kk,(data,data_orig, img_full, img_orig_full, coordinates,img_orig_neprevzorkovany) in enumerate(UBMI_loader):
        with torch.no_grad():
             
            data=data.cuda()
            
            output=net(data)
            output=torch.sigmoid(output)                   
            output=output.detach().cpu().numpy() > threshold
             
            test_files_name_tmp=test_files_name[kk][len(path_to_data)+8:]
            name_of_img=test_files_name_tmp[:-4]
            
            dir_pom=path_to_results+name_of_img
           
            isExist = os.path.exists(dir_pom)
            if not isExist:
                os.makedirs(dir_pom)
                
            pom_sourad=coordinates.detach().cpu().numpy()[0]

            output_mask_disc=np.zeros([img_full.shape[1],img_full.shape[2]])                     
            output_mask_cup=np.zeros([img_full.shape[1],img_full.shape[2]])   
                
            if (pom_sourad[1]-int(output_size[0]/2)<0):
                x_start=0
            elif((pom_sourad[1]+int(output_size[0]/2))>output_mask_disc.shape[0]):
                x_start=output_mask_disc.shape[0]-output_size[0]
            else:
                x_start=pom_sourad[1]-int(output_size[0]/2)
                    
            if (pom_sourad[0]-int(output_size[0]/2)<0):
                y_start=0
            elif((pom_sourad[0]+int(output_size[0]/2))>output_mask_disc.shape[1]):
                y_start=output_mask_disc.shape[1]-output_size[0]
            else:
                y_start=pom_sourad[0]-int(output_size[0]/2)
                
                
            output_mask_disc[x_start:x_start+output_size[0],y_start:y_start+output_size[0]]=output[0,0,:,:]
            output_mask_disc=output_mask_disc.astype(bool)    
                
            output_mask_cup[x_start:x_start+output_size[0],y_start:y_start+output_size[0]]=output[0,1,:,:]
            output_mask_cup=output_mask_cup.astype(bool)  
                
            orig_img=img_orig_full[0,:,:,:].detach().cpu().numpy()                 
                                        
            plt.figure(figsize=[10,10])
            plt.subplot(2,3,1)    
            plt.imshow(orig_img)   
            plt.title("Orig " +str(kk))
            
            plt.subplot(2,3,2)
            im_pom=img_full[0,:,:,:].detach().cpu().numpy()/255   
            plt.imshow(im_pom)   
            plt.title("Modified "+ str(kk))
                
            plt.subplot(2,3,3)    
            plt.imshow(output_mask_disc)
            plt.title('Output of net disc')
            
            plt.subplot(2,3,4)    
            plt.imshow(orig_img)   
            plt.title("Orig " +str(kk))
            
            plt.subplot(2,3,5)
            im_pom=img_full[0,:,:,:].detach().cpu().numpy()/255   
            plt.imshow(im_pom)   
            plt.title("Modified "+ str(kk))
                
            plt.subplot(2,3,6)    
            plt.imshow(output_mask_cup)
            plt.title('Output of net cup')
            plt.show()
                
                
            plt.figure(figsize=[10,10])
            plt.subplot(2,3,1)  
            data_pom_orig=data_orig[0,:,:,:].numpy()/255  
            data_pom_orig=np.transpose(data_pom_orig,(1,2,0))
            plt.imshow(data_pom_orig)  
            plt.title("Orig " +str(kk)+ " detail")
                
            plt.subplot(2,3,2) 
            data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
            data_pom=np.transpose(data_pom,(1,2,0))
            plt.imshow(data_pom)  
            plt.title("Modified "+ str(kk)+" detail")
              
            plt.subplot(2,3,3)                       
            plt.imshow(output[0,0,:,:])
            plt.title('Output of net disc')

            plt.subplot(2,3,4)  
            data_pom_orig=data_orig[0,:,:,:].numpy()/255  
            data_pom_orig=np.transpose(data_pom_orig,(1,2,0))
            plt.imshow(data_pom_orig) 
            plt.title("Orig " +str(kk)+ " detail")
            
            plt.subplot(2,3,5)  
            data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
            data_pom=np.transpose(data_pom,(1,2,0))
            plt.imshow(data_pom)  
            plt.title("Modified "+ str(kk)+" detail")   

            plt.subplot(2,3,6)                       
            plt.imshow(output[0,1,:,:])  
            plt.title('Output of net cup')                     
            
            plt.show()
            
            if ZAPISOVAT:
                 # Uložení masek ze segmentace
                 # Disc
                 imsave(dir_pom+'/' + name_of_img +"_Disc_output.png",img_as_ubyte(output_mask_disc))
                                  
                 # Cup
                 imsave(dir_pom+'/' + name_of_img +"_Cup_output.png",img_as_ubyte(output_mask_cup))  
                 
                 # Orig
                 imsave(dir_pom+'/' + name_of_img +".png",orig_img)
    


            '''
            # Převzorkování masek na orig shape
            
            output_mask_disc_final_orig_shape=resize(output_mask_disc,[img_orig_neprevzorkovany.shape[1],img_orig_neprevzorkovany.shape[2]]).astype(bool)
            output_mask_cup_final_orig_shape=resize(output_mask_cup,[img_orig_neprevzorkovany.shape[1],img_orig_neprevzorkovany.shape[2]]).astype(bool)
            
            plt.figure(figsize=[15,15])
            plt.subplot(1,3,1)    
            im_pom_orig=img_orig_neprevzorkovany[0,:,:,:].numpy()/255   
            plt.imshow(im_pom_orig)   
            plt.title('Original_' + name_of_img)            
                           
            plt.subplot(1,3,2)    
            plt.imshow(output_mask_disc_final_orig_shape)
            plt.title('Output of net - disc')
                           
            plt.subplot(1,3,3)    
            plt.imshow(output_mask_cup_final_orig_shape)
            plt.title('Cup')  
            plt.show() 
            '''





