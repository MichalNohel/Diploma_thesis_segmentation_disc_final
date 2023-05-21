Popis jednotlivých složek a skriptů:

1) Preprocessing - složka obsahující veškeré potřebné funkce a skripty pro přípravu databází
	1a) První hlavním skriptem je FOLDER_CREATION
		Tento skript slouží k vytvoření všech potřebných složek pro přípravu databáze 
		Po jeho spuštění je potřeba do jednotlivých složek nahrát stažené databáze
	1b) Skript MAIN_preprocesing 
		Tento skript slouží k extrakci a předzpracování snímků a masek z jednotlivých databází a uložení 
		GT  pozic centroidu optického disku
	1c) Skript MAIN_creation_of_train_and_test_dataset_U_net
		Tento skript provede rozdělení dat na trénovací a testovací dataset pro učení klasického U-Netu
		Nutno nastavit cestu k datům z výstupu předhozího skriptu
		Dále se v tomto skriptu detekují pozice optického disku, které se používají při trénování
 	1d) Skript MAIN_Part1_creation_of_train_and_test_dataset_for_nnU_net
		Skript pro přípravu trénovacího a testovacího datasetu pro nnUNetu 
	1e) Skript MAIN_Part2_creation_of_train_and_test_dataset_for_nnU_net
		Skript v Pythonu pro přeuložení dat do NIfTI 	
		Pro spuštění tohoto skriptu je potřeba nainstalovat environment env_nnUNet_preprocesing.yml 
	1f) functions_MAIN_Part2.py 
		funkce v Pythonu pro přeuložení dat do nifti a pak pro přeuložení pro nnUNetv2		
	1g) Skript dataset_conversion_to_nnunetv2 
		Skript v Pythonu pro přípravu datastruktury potřebné pro nnUNetv2 
	ostatní - funkce využívané v hlavních skriptech	
2) Optimalizace sigma - složka se skripty, kde se optimalizovala hodnota sigma pro detekci OD	

3) Optimalizace_postprocesing - složka se skripty, kde se optimalizoval postprocesing klasického U-Netu

4) Evaluation_of_segmentation - složka se skripty a funkcemi pro vyhodnocení úspěšnosti segmentace
	4a) MAIN_vizualizace_vysledku_NNunet
		Pouze skript pro vizualizaci výsledků z nnUNetu
	4b) MAIN_vypocet_vysledku_NNunet
		Skript pro výpočet výsledků segmentace s využitím nnUNetu
	4c) MAIN_vypocet_vysledku_NNunet_UBMI
		Skript pro výpočet výsledků segmentace s využitím nnUNetu na UBMI databázi
	4d) MAIN_vypocet_vysledku_unet
		Skript pro výpočet výsledků segmentace s využitím U-Netu
	4e) MAIN_vypocet_vysledku_unet_UBMI
		Skript pro výpočet výsledků segmentace s využitím U-Netu na UBMI databázi
	ostatní - funkce pro výpočet metrik

5) UBMI_mereni 
	5a) MAIN_preprocesing_UBMI
		Skript slouží pro preprocessing snímků z UBMI databáze
	5b) MAIN_disc_detection_UBMI_klikac
		Skript pro manuální detekci optického disku
	5c) MAIN_creation_of_nnunet_dataset_UBMI
		Skript v Pythonu pro přeuložení dat do NIfTI 	
		Pro spuštění tohoto skriptu je potřeba nainstalovat environment env_nnUNet_preprocesing.yml 