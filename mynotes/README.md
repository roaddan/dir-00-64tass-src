```
Notes d'utilisation/programmation du Commodore 64.
==================================================
En assembleur:
--------------
Il est possible de générer en memoire le code basic pour faciliter le 
lancement d'un programme en assembleur. 
Pour ce faire vous devez placer un entête dans votre code assembleur à
l'adresse $0800 (2048) qui se décrit comme suit...
		;----------------------------------------------------------------
		; Entete Basic pour generer la commande "SYS 2061" visible avec 
		;  la commande "LIST" sous Basic 2.0
		;----------------------------------------------------------------
				*= $0800
$0800			.byte $00     	;Basic commence avec un $00 à $0800.
$0801	bcmd1		.word bcmd2   	;Adresse de la commande basic suivante.
$0803			.word $000a   	;Numero de la ligne Basic.
$0805			.byte $9e		;Le token de la commande Basic ($9e=SYS)
$0806			.text "2061"   ;L'adresse le la première instruction
							; assembleur de votre programme
$080a			.byte $00		;Un zéro pour indiquer la fin de cette 
							; commande Basic.
$080b	bcmd2		.word $0000    ;L'adresse de la commande Basic suivante.
		;----------------------------------------------------------------
		; Début du programme assembleur. Ici je choisi de mettre un 
		;  "jmp main", "main" étant le nom de la routine principale qui
		;  sera lancée. 
		; Ce faisant il est possible de déplacer "main" en mémoire sans 
		;  que cela de change l'entête.
		; Vous pouvez remplacer "main" par une adresse spécifique pour 
		;  lancer l'exécution d'un programme placé ailleur en mémoire.
		; Exemple: 
		;		jmp $fce2		;Pour exécuter un RESET du système.  
		;----------------------------------------------------------------
$080d			jmp 	main      ;L'adresse $080d vaut 2061 en décimal.
							; Voir la ligne à l'adresse $0806.
		;----------------------------------------------------------------
		; Exemple de programme principale en assembleur qui change les 
		;  couleurs de l'interface Basic.
		;
		; IMPORTANT: Ce programme doit de terminer par un RTS pour 
		;            revenir proprement au Basic.	
		;----------------------------------------------------------------
$0810	main		php			;Le nom "main" est arbritraire.
$0811			pha			;Sauvegarde les registres modifiés.
$0812	bord		lda 	#$05		;Vert pour la ...
$0814			sta 	$d020	;... bordure.
$0817			lda	#$06		;Bleu pour le ...
$0819			sta	$d021	;... fond.
$081c			lda	$01		;Blanc pour le ...
$081e			sta	$0286	;... texte.
$0821			lda	#$93		;Code d'effacement d'écran.
$0823			jsr	$ffd2	;Appel de la routine chrout du Kernal.
$0826			pla			;On récupère l'accumulateur et ... 
$0827			plp			;... le registre d"état.
$0828			rts			;Retourne propre au basic.
		;----------------------------------------------------------------
		; Fin du programme.
		;----------------------------------------------------------------
```