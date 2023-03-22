# -*- coding: utf-8 -*-
"""
Created on Tue May 24 12:39:07 2022

@author: nohel
"""



import numpy as np
from Function_final import DataLoader, Unet, dice_loss, dice_coefficient, Postprocesing_disc
import matplotlib.pyplot as plt
import torch
import torch.optim as optim
from torch.optim.lr_scheduler import StepLR
from IPython.display import clear_output
from skimage.color import hsv2rgb, xyz2rgb
import torchvision.transforms.functional as TF

if __name__ == "__main__": 
    #Learning parameters
    lr=0.001
    epochs=30
    batch=12
    threshold=0.5
    # size of crop image to training    
    output_size=(int(448),int(448),int(3))

    #Path to data
    path_to_data="D:\Diploma_thesis_segmentation_disc_v2/Data_480_480_35px_preprocesing_all_database"
    path_to_save_model = path_to_data+ '/Naucene_modely/'
    name_of_model='model_01_disc_cup_35px_all_modified_databases'
    
    
    #Postsprocesing parameters
    min_size_of_optic_disk=1000
    size_of_disk_for_morphing=40
    #type_of_morphing='closing' 
    #type_of_morphing='openinig' 
    type_of_morphing='closing_opening' 
    #type_of_morphing='openinig_closing' 
    ploting=0    
    
    #Dataloaders for Train and test data
    loader=DataLoader(split="Train",path_to_data=path_to_data,output_size=output_size)
    trainloader=torch.utils.data.DataLoader(loader,batch_size=batch, num_workers=0, shuffle=True)
    
    batch=1
    loader=DataLoader(split="Test",path_to_data=path_to_data,output_size=output_size)
    testloader=torch.utils.data.DataLoader(loader,batch_size=batch, num_workers=0, shuffle=False)
    
    # Definition of Unet
    net=Unet(out_size=2).cuda()  
    
    #Setting of optimazer
    optimizer = optim.Adam(net.parameters(), lr=lr,weight_decay=1e-8)
    sheduler=StepLR(optimizer,step_size=7, gamma=0.1) #decreasing of learning rate
        
    # Definition of list for evaluation
    train_loss = []
    test_loss = []        
    train_dice_disc = []
    test_dice_disc = []       
    train_dice_cup = []
    test_dice_cup = []    
    test_dice_final_disc = []
    test_dice_final_cup = []  
    it_test=-1
    it_train=-1
    
    for epoch in range(epochs):
        # Definition of temporal variables
        loss_tmp = []
        dice_tmp_disc = []
        dice_tmp_final_disc = []            
        dice_tmp_cup = []
        dice_tmp_final_cup = []
            
        print('epoch number ' + str(epoch+1))
            
        for k,(data,data_orig,lbl) in enumerate(trainloader):
            it_train+=1
            data=data.cuda()
            lbl=lbl.cuda() 
    
            net.train()
            output=net(data)
                
            output=torch.sigmoid(output)
                
            #loss = -torch.mean(lbl*torch.log(output)+(1-lbl)*torch.log(1-output))
            #loss = -torch.mean(20*lbl*torch.log(output)+1*(1-lbl)*torch.log(1-output)) #vahovaní
            loss=dice_loss(lbl,output)
                
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
                
            lbl_mask=lbl.detach().cpu().numpy()
            output_mask=output.detach().cpu().numpy() > threshold

            loss_tmp.append(loss.cpu().detach().numpy()) 
                
            dice_tmp_disc.append(dice_coefficient(output_mask[:,0,:,:],lbl_mask[:,0,:,:]))
            dice_tmp_cup.append(dice_coefficient(output_mask[:,1,:,:],lbl_mask[:,1,:,:]))   
    
    
    
    
    
    