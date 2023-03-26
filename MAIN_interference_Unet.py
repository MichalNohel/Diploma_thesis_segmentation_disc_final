# -*- coding: utf-8 -*-
"""
Created on Wed Mar  8 10:13:35 2023

@author: nohel
"""

from Function_final import DataLoader,Unet
import matplotlib.pyplot as plt
import torch
import os
import numpy as np 
from skimage.io import imsave
from skimage import  img_as_ubyte

if __name__ == "__main__": 
    ZAPISOVAT=True
    ZAPISOVAT_KONTURY=True
    
    batch=1 
    threshold=0.5
    
    # %%
    #Rozliseni_320_320_25px
    
    output_size=(int(288),int(288),int(3))    
    path_to_data="D:\DATA\Data_320_320_25px_preprocesing_sigma_50_all_database"
    #mereni UBMI
    #path_to_data="D:\Diploma_thesis_segmentation_disc_v2/Data_320_320_25px_preprocesing_UBMI_mereni"   
    
    # Cesta k naucenemu modelu
    path_to_save_model="D:\Diploma_thesis_segmentation_disc_v2\Diploma_thesis_segmentation_disc_final/Trained_models/U_net_resolution_25px_doplneni/"
     
    name_of_model='model_Unet_25px_all_mod_dat_doplneni_OS_288_288_3'
    
    net=Unet(out_size=2).cuda()  
    net.load_state_dict(torch.load(path_to_save_model+ name_of_model+ '.pth'))    
    
    path_to_extracted_data=path_to_data+ "/Vysledky_test_data_vystup_site/U_net_Data_320_320_25px/"  
    
    #%%
    #Rozliseni_480_480_35px
    '''
    output_size=(int(448),int(448),int(3))    
    path_to_data="D:\Diploma_thesis_segmentation_disc_v2/Data_480_480_35px_preprocesing_all_database"
    #mereni UBMI
    #path_to_data="D:\Diploma_thesis_segmentation_disc_v2/Data_480_480_35px_preprocesing_UBMI_mereni"   
    
    # Cesta k naucenemu modelu
    path_to_model="D:\Diploma_thesis_segmentation_disc_v2/Data_480_480_35px_preprocesing_all_database/Naucene_modely/"
    
    # Disc and cup together
    segmentation_type="disc_cup"
    path_to_save_model = path_to_model + 'disc_and_cup_detection_35px_all_databases/'
    name_of_model='model_01_disc_cup_35px_all_modified_databases'
    net=Unet(out_size=2).cuda()  
    net.load_state_dict(torch.load(path_to_save_model+ name_of_model+ '.pth')) 
    
    path_to_extracted_data=path_to_data+ "/Vysledky_test_data_vystup_site/Data_480_480_35px/"  
    
    '''
    #%%
    net.eval()    
    
    
    batch=1
    loader=DataLoader(split="Test",path_to_data=path_to_data,output_size=output_size)
    testloader=torch.utils.data.DataLoader(loader,batch_size=batch, num_workers=0, shuffle=False)
    test_files_name=testloader.dataset.files_img
    
    #%%

    for kk,(data,data_orig, lbl, img_full, img_orig_full, disc_orig, cup_orig, coordinates) in enumerate(testloader):
        with torch.no_grad():
             
            data=data.cuda()
            lbl=lbl.cuda()
            
            output=net(data)
            output=torch.sigmoid(output)                   
            output=output.detach().cpu().numpy() > threshold
            
            lbl=lbl.detach().cpu().numpy()
             
            test_files_name_tmp=test_files_name[kk][73:]
            name_of_img=test_files_name_tmp[:-4]
            
            dir_pom=path_to_extracted_data+name_of_img
           
            isExist = os.path.exists(dir_pom)
            if not isExist:
                os.makedirs(dir_pom)
                
            pom_sourad=coordinates.detach().cpu().numpy()[0]

            output_mask_disc=np.zeros([disc_orig.shape[1],disc_orig.shape[2]])                     
            output_mask_cup=np.zeros([disc_orig.shape[1],disc_orig.shape[2]])   
                
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
                
            disc_orig=disc_orig[0,:,:].detach().cpu().numpy() 
            cup_orig=cup_orig[0,:,:].detach().cpu().numpy()

            orig_img=img_orig_full[0,:,:,:].detach().cpu().numpy()                 
                                        
            plt.figure(figsize=[10,10])
            plt.subplot(2,4,1)    
            plt.imshow(orig_img)   
            plt.title("Orig " +str(kk))
            
            plt.subplot(2,4,2)
            im_pom=img_full[0,:,:,:].detach().cpu().numpy()/255   
            plt.imshow(im_pom)   
            plt.title("Modified "+ str(kk))
                
            plt.subplot(2,4,3)    
            plt.imshow(disc_orig)
            plt.title('Orig mask disc')
                
            plt.subplot(2,4,4)    
            plt.imshow(output_mask_disc)
            plt.title('Output of net disc')
            
            plt.subplot(2,4,5)    
            plt.imshow(orig_img)   
            plt.title("Orig " +str(kk))
            
            plt.subplot(2,4,6)
            im_pom=img_full[0,:,:,:].detach().cpu().numpy()/255   
            plt.imshow(im_pom)   
            plt.title("Modified "+ str(kk))
                
            plt.subplot(2,4,7)    
            plt.imshow(cup_orig)
            plt.title('Orig mask disc')
                
            plt.subplot(2,4,8)    
            plt.imshow(output_mask_cup)
            plt.title('Output of net cup')
            plt.show()
                
                
            plt.figure(figsize=[10,10])
            plt.subplot(2,4,1)  
            data_pom_orig=data_orig[0,:,:,:].numpy()/255  
            data_pom_orig=np.transpose(data_pom_orig,(1,2,0))
            plt.imshow(data_pom_orig)  
            plt.title("Orig " +str(kk)+ " detail")
                
            plt.subplot(2,4,2) 
            data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
            data_pom=np.transpose(data_pom,(1,2,0))
            plt.imshow(data_pom)  
            plt.title("Modified "+ str(kk)+" detail")
            
            plt.subplot(2,4,3)                       
            plt.imshow(lbl[0,0,:,:])
            plt.title('Orig mask disc')
            
            plt.subplot(2,4,4)                       
            plt.imshow(output[0,0,:,:])
            plt.title('Output of net disc')

            plt.subplot(2,4,5)  
            data_pom_orig=data_orig[0,:,:,:].numpy()/255  
            data_pom_orig=np.transpose(data_pom_orig,(1,2,0))
            plt.imshow(data_pom_orig) 
            plt.title("Orig " +str(kk)+ " detail")
            
            plt.subplot(2,4,6)  
            data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
            data_pom=np.transpose(data_pom,(1,2,0))
            plt.imshow(data_pom)  
            plt.title("Modified "+ str(kk)+" detail")
            
            plt.subplot(2,4,7)                       
            plt.imshow(lbl[0,1,:,:])
            plt.title('Orig mask cup')
            
            plt.subplot(2,4,8)                       
            plt.imshow(output[0,1,:,:])  
            plt.title('Output of net cup')                     
            
            plt.show()
            
            if ZAPISOVAT:
                 # Uložení masek ze segmentace
                 # Disc
                 imsave(dir_pom+'/' + name_of_img +"_Disc_output.png",img_as_ubyte(output_mask_disc))
                 imsave(dir_pom+'/' + name_of_img +"_Disc_orig.png",img_as_ubyte(disc_orig))
                                  
                 # Cup
                 imsave(dir_pom+'/' + name_of_img +"_Cup_output.png",img_as_ubyte(output_mask_cup))
                 imsave(dir_pom+'/' + name_of_img +"_Cup_orig.png",img_as_ubyte(cup_orig))      
                 
                 # Orig
                 imsave(dir_pom+'/' + name_of_img +".png",orig_img)
    










