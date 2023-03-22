# -*- coding: utf-8 -*-
"""
Created on Tue May 24 12:39:07 2022

@author: nohel
"""


# %% Library import
import numpy as np
from Function_final import DataLoader, Unet, dice_loss, dice_coefficient
import matplotlib.pyplot as plt
import torch
import torch.optim as optim
from torch.optim.lr_scheduler import StepLR
from IPython.display import clear_output
import os

#%%
if __name__ == "__main__": 
    #Learning parameters
    lr=0.001
    epochs=30
    batch=16
    threshold=0.5
    # size of crop image to training    
    output_size=(int(448),int(448),int(3))

    #Path to data
    path_to_data="D:\Diploma_thesis_segmentation_disc_v2/Data_480_480_35px_preprocesing_all_database"
    path_to_save_model = os.getcwd() + '/Trained_models/'
    name_of_model='model_Unet_35px_all_mod_dat_OS_448_448_3'   
    
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
    it_test=-1
    it_train=-1
    
    #%%
    #Epochs
    for epoch in range(epochs):       
        # Definition of temporal variables
        loss_tmp = []            
        dice_tmp_disc = []           
        dice_tmp_cup = []     
        print('epoch number ' + str(epoch+1))
        
        #%%
        #Train dataset
        
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
            
            if (it_train % 5==0):
                print('Train - iteration ' + str(it_train))
                clear_output()
                plt.figure(figsize=[10,10])
                plt.plot(loss_tmp,label='train loss')
                plt.plot(dice_tmp_disc,label='dice_disc')
                plt.plot(dice_tmp_cup,label='dice_cup')
                plt.legend(loc="upper left")
                plt.title('train')
                plt.show()
                    
                plt.figure(figsize=[10,10])
                plt.subplot(2,4,1) 
                data_orig_pom=data_orig[0,:,:,:].numpy()/255  
                data_orig_pom=np.transpose(data_orig_pom,(1,2,0))
                plt.imshow(data_orig_pom) 
                plt.title('Original data')
                    
                plt.subplot(2,4,2)   
                data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
                data_pom=np.transpose(data_pom,(1,2,0))
                plt.imshow(data_pom)    
                plt.title('Modified data')
                    
                plt.subplot(2,4,3) 
                plt.imshow(lbl_mask[0,0,:,:])
                plt.title('Orig mask')                    
                    
                plt.subplot(2,4,4)    
                plt.imshow(output_mask[0,0,:,:])
                plt.title('Output of net')
                    
                plt.subplot(2,4,5) 
                data_orig_pom=data_orig[0,:,:,:].numpy()/255  
                data_orig_pom=np.transpose(data_orig_pom,(1,2,0))
                plt.imshow(data_orig_pom)
                plt.title('Original data')
                    
                plt.subplot(2,4,6)                     
                data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
                data_pom=np.transpose(data_pom,(1,2,0))
                plt.imshow(data_pom) 
                plt.title('Modified data')
                    
                plt.subplot(2,4,7)    
                plt.imshow(lbl_mask[0,1,:,:])
                plt.title('Orig mask')
                    
                plt.subplot(2,4,8)    
                plt.imshow(output_mask[0,1,:,:])
                plt.title('Output of net')
                    
                plt.show()                       
                
              
        train_loss.append(np.mean(loss_tmp))            
        train_dice_disc.append(np.mean(dice_tmp_disc)) 
        train_dice_cup.append(np.mean(dice_tmp_cup)) 
           
        #%%
        
        #Test dataset
        # Definition of temporal variables
        loss_tmp = []            
        dice_tmp_disc = []          
        dice_tmp_cup = []      
        
                
        for kk,(data,data_orig, lbl, img_full, img_orig_full, disc_orig, cup_orig, coordinates) in enumerate(testloader):
            with torch.no_grad():
                it_test+=1
                net.eval()  
                data=data.cuda()
                lbl=lbl.cuda()
                output=net(data)
                output=torch.sigmoid(output)
                    
                loss=dice_loss(lbl,output)                    
                output=output.detach().cpu().numpy() > threshold
                    
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
                   
                loss_tmp.append(loss.cpu().detach().numpy())                          
                    
                dice_tmp_disc.append(dice_coefficient(output_mask_disc,disc_orig))
                dice_tmp_cup.append(dice_coefficient(output_mask_cup,cup_orig))
                    
                    
                if (it_test % 10==0):
                    print('Test - iteration ' + str(it_test))
                    clear_output()
                    plt.figure(figsize=[10,10])
                    plt.plot(loss_tmp,label='test loss')
                    plt.plot(dice_tmp_disc,label='dice_disc')
                    plt.plot(dice_tmp_cup,label='dice_cup')
                    plt.legend(loc="upper left")
                    plt.title('test')
                    plt.show()
                                                
                    plt.figure(figsize=[10,10])
                    plt.subplot(2,4,1)    
                    im_pom_orig=img_orig_full[0,:,:,:].numpy()/255   
                    plt.imshow(im_pom_orig)   
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
                    im_pom_orig=img_orig_full[0,:,:,:].numpy()/255   
                    plt.imshow(im_pom_orig)   
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
                    plt.imshow(lbl[0,0,:,:].detach().cpu().numpy())
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
                    plt.imshow(lbl[0,1,:,:].detach().cpu().numpy())
                    plt.title('Orig mask cup')
                    
                    plt.subplot(2,4,8)                       
                    plt.imshow(output[0,1,:,:])  
                    plt.title('Output of net cup')                     
                    
                    plt.show()


                    
                    #%%
                   
        test_loss.append(np.mean(loss_tmp))            
        test_dice_disc.append(np.mean(dice_tmp_disc)) 
        test_dice_cup.append(np.mean(dice_tmp_cup))            
        
                     
        
        sheduler.step()
        #%%
        clear_output()
        plt.figure(figsize=[10,10])
        plt.plot(train_loss,label='train loss')
        plt.plot(train_dice_disc,label='dice_disc')
        plt.plot(train_dice_cup,label='dice_cup')
        plt.legend(loc="upper left")
        plt.title('train')
        plt.show()
            
        clear_output()
        plt.figure(figsize=[10,10])
        plt.plot(test_loss,label='test loss')
        plt.plot(test_dice_disc,label='dice_disc')
        plt.plot(test_dice_cup,label='dice_cup')
        plt.legend(loc="upper left")
        plt.title('test')
        plt.show()
        
    #%% Final results - save data
    clear_output()
    plt.figure(figsize=[10,10])
    plt.plot(train_loss,label='train loss')
    plt.plot(train_dice_disc,label='dice_disc')
    plt.plot(train_dice_cup,label='dice_cup')
    plt.legend(loc="upper left")
    plt.title('train')
    plt.savefig(path_to_save_model+ name_of_model +"_Train.png")
    plt.show()
        
    clear_output()
    plt.figure(figsize=[10,10])
    plt.plot(test_loss,label='test loss')
    plt.plot(test_dice_disc,label='dice_disc')
    plt.plot(test_dice_cup,label='dice_cup')
    plt.legend(loc="upper left")
    plt.title('test')
    plt.savefig(path_to_save_model+ name_of_model +"_Test.png")
    plt.show() 
    
    #%% Save of model
    #torch.save(net, 'model_01.pth')
    torch.save(net.state_dict(), path_to_save_model+ name_of_model+ '.pth')
    
    
    
    
    
    
    #%%
    '''
    plt.figure(figsize=[10,10])
    plt.subplot(4,4,1)    
    im_pom_orig=img_orig_full[0,:,:,:].numpy()/255   
    plt.imshow(im_pom_orig)   
    plt.title("Orig " +str(kk))
    
    plt.subplot(4,4,2)
    im_pom=img_full[0,:,:,:].detach().cpu().numpy()/255   
    plt.imshow(im_pom)   
    plt.title("Modified "+ str(kk))
        
    plt.subplot(4,4,3)    
    plt.imshow(disc_orig)
    plt.title('Orig mask disc')
        
    plt.subplot(4,4,4)    
    plt.imshow(output_mask_disc)
    plt.title('Output of net disc')
    
    plt.subplot(4,4,5)    
    im_pom_orig=img_orig_full[0,:,:,:].numpy()/255   
    plt.imshow(im_pom_orig)   
    plt.title("Orig " +str(kk))
    
    plt.subplot(4,4,6)
    im_pom=img_full[0,:,:,:].detach().cpu().numpy()/255   
    plt.imshow(im_pom)   
    plt.title("Modified "+ str(kk))
        
    plt.subplot(4,4,7)    
    plt.imshow(cup_orig)
    plt.title('Orig mask disc')
        
    plt.subplot(4,4,8)    
    plt.imshow(output_mask_cup)
    plt.title('Output of net cup')
    
    plt.subplot(4,4,9)  
    data_pom_orig=data_orig[0,:,:,:].numpy()/255  
    data_pom_orig=np.transpose(data_pom_orig,(1,2,0))
    plt.imshow(data_pom_orig)  
    plt.title("Orig " +str(kk)+ " detail")
        
    plt.subplot(4,4,10) 
    data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
    data_pom=np.transpose(data_pom,(1,2,0))
    plt.imshow(data_pom)  
    plt.title("Modified "+ str(kk)+" detail")
    
    plt.subplot(4,4,11)                       
    plt.imshow(lbl[0,0,:,:].detach().cpu().numpy())
    plt.title('Orig mask disc')
    
    plt.subplot(4,4,12)                       
    plt.imshow(output[0,0,:,:])
    plt.title('Output of net disc')
    
    plt.subplot(4,4,13)  
    data_pom_orig=data_orig[0,:,:,:].numpy()/255  
    data_pom_orig=np.transpose(data_pom_orig,(1,2,0))
    plt.imshow(data_pom_orig) 
    plt.title("Orig " +str(kk)+ " detail")
    
    plt.subplot(4,4,14)  
    data_pom=data[0,:,:,:].detach().cpu().numpy()/255  
    data_pom=np.transpose(data_pom,(1,2,0))
    plt.imshow(data_pom)  
    plt.title("Modified "+ str(kk)+" detail")
    
    plt.subplot(4,4,15)                       
    plt.imshow(lbl[0,1,:,:].detach().cpu().numpy())
    plt.title('Orig mask cup')
    
    plt.subplot(4,4,16)                       
    plt.imshow(output[0,1,:,:])  
    plt.title('Output of net cup')                     
    
    plt.show()                     
    print('Test - iteration ' + str(it_test))
    '''
    
    