Natrénované modely jsou dostupné na úložišti: https://zenodo.org/record/7954316

Prvně je potřeba vytvořit a nainstalovat environment pro nnUNet, lze využít yml soubor env_nnUNet.yml
nebo lze nainstalovat environment podle návodu:
https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/installation_instructions.md
Nainstalov Pytorch dle PC
poté nainstalov nnUNet
pip install nnunetv2

Dále je potřeba nastavit cesty ke složkám nnUNet_result,preprocessed a raw: (potřeba upravit)

export nnUNet_results="/mnt/Data/nohel/DATA/Transfer_to_CUDA/nnUNet_results"
export nnUNet_preprocessed="/mnt/Data/nohel/DATA/Transfer_to_CUDA/nnUNet_preprocessed"
export nnUNet_raw="/mnt/Data/nohel/DATA/Transfer_to_CUDA/nnUNet_raw"


Interference sítě lze spustit takto, je potřeba správně nastavit cesty k datům a kam se mají masky uložit:
# -m 2d or 3d_fullres
# -t TASK ID (735) 735 pro rozlišení 35px na 1 stupen FOV, 725 pro 25px na 1 stupen FOV
# -i input folder path (nnUNet_raw/Dataset735_Optic_disc_cup_segm_35px/nnUNet_sada01)
# -o output folder path (Result_mereni_UBMI_35px)

UBMI data 
nnUNetv2_predict -i /mnt/Data/nohel/DATA/Transfer_to_CUDA/nnUNet_raw/Dataset735_Optic_disc_cup_segm_35px/nnUNet_sada01 -o /mnt/Data/nohel/DATA/Transfer_to_CUDA/Result_mereni_UBMI_35px -d 735 -f 0 -c 2d


Učení probíhalo takto:
Plan and preprocess lze spustit například takto 
nnUNetv2_plan_and_preprocess -d 725 --verify_dataset_integrity

Trénování:
nnUNetv2_train 725 2d 0 