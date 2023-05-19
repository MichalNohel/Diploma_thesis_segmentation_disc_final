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
	
2) Optimalizace sigma - složka se skripty, kde se optimalizovala hodnota sigma pro detekci OD	

3) Optimalizace_postprocesing - složka se skripty, kde se optimalizoval postprocesing klasického U-Netu


	