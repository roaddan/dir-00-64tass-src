English version below.
```
Notes d'utilisation/programmation du Commodore 64.
==================================================
En assembleur:
--------------
Il est possible de générer en memoire le code BASIC pour faciliter le 
lancement d'un programme en assembleur. 

Pour ce faire vous devez placer un entête dans votre code assembleur et 
vous assurer que celui-ci sera positionné à l'adresse $0800 (2048).

Cet entete se décrit comme suit...

          ;----------------------------------------------------------------
          ; Entete BASIC pour generer la commande "SYS 2061" visible avec 
          ; la commande "LIST" sous BASIC 2.0
          ;----------------------------------------------------------------
*= $0800
$0800               .byte $00      ;BASIC commence avec un $00 à $0800.
$0801     bcmd1     .word bcmd2    ;Adresse de la commande BASIC suivante.
$0803               .word $000a    ;Numero de la ligne BASIC.
$0805               .byte $9e      ;Le jeton de la commande BASIC ($9e=SYS)
$0806               .text "2061"   ;L'adresse le la première instruction
                                   ;... assembleur de votre programme
$080a               .byte $00      ;Un zéro pour indiquer la fin de cette 
                                   ;... commande BASIC.
$080b     bcmd2     .word $0000    ;L'adresse de la commande BASIC suivante.
          ;----------------------------------------------------------------
          ; Début du programme assembleur. Ici je choisi de mettre un 
          ; "jmp main", "main" étant le nom de la routine principale qui
          ; sera lancée. 
          ;
          ; Ce faisant il est possible de déplacer "main" en mémoire sans 
          ; que cela de change l'entête.
          ;
          ; Vous pouvez remplacer "main" par une adresse spécifique pour 
          ; lancer l'exécution d'un programme placé ailleur en mémoire.
          ; Exemple: 
          ;         jmp $fce2      ;Pour exécuter un RESET du système.  
          ;----------------------------------------------------------------
$080d               jmp  main      ;L'adresse $080d vaut 2061 en décimal.
                                   ; Voir la ligne à l'adresse $0806.

          ;----------------------------------------------------------------
          ; À partir de ce point le programme peut être situé n'importe où
          ; en mémoire.
          ;----------------------------------------------------------------          

          ;----------------------------------------------------------------
          ; Exemple de programme principale en assembleur qui change les 
          ; couleurs de l'interface BASIC.
          ;
          ; IMPORTANT: Puisque la commande BASIC "SYS" se comporte comme un 
          ;            "JSR", le programme doit de terminer par un "RTS" 
          ;            pour assurer un retour normal à BASIC.     
          ;----------------------------------------------------------------
$0810     main      php            ;Le nom "main" est arbritraire.
$0811               pha            ;Sauvegarde les registres modifiés.
$0812     bord      lda  #$05      ;Vert pour la ...
$0814               sta  $d020     ;... bordure.
$0817               lda  #$06      ;Bleu pour le ...
$0819               sta  $d021     ;... fond.
$081c               lda  $01       ;Blanc pour le ...
$081e               sta  $0286     ;... texte.
$0821               lda  #$93      ;Code d'effacement d'écran.
$0823               jsr  $ffd2     ;Appel de la routine chrout du Kernal.
$0826               pla            ;On récupère l'accumulateur et ... 
$0827               plp            ;... le registre d'état.
$0828               rts            ;Retourne propre au BASIC.
          ;----------------------------------------------------------------
          ; Fin du programme.
          ;----------------------------------------------------------------
```
English version
```
Programming/usage note for the Commodore 64.
==================================================
In assembly language:
---------------------
It is possible to generate the BASIC memory code to ease the execution of 
an assembly language program.

To do this you must place a header at the very beginning of your code and 
make shure that it will be locates at address $0800 (2048).

The header should look as follow ...

          ;----------------------------------------------------------------
          ; BASIC header to generate the "SYS 2061" visible by the BASIC
          ; 2.0 "LIST" command.
          ;----------------------------------------------------------------
*= $0800  ;First BASIC command allways starts at $0800
          ;----------------------------------------------------------------
$0800               .byte $00      ;BASIC starts with a $00 code at $0800.
$0801     bcmd1     .word bcmd2    ;Adress of the next BASIC command.
$0803               .word $000a    ;Current BASIC command line number.
$0805               .byte $9e      ;BASIC command token ($9e=SYS)
$0806               .text "2061"   ;String representing the address of the 
                                   ;... first assembly language command of 
                                   ;... your program.
$080a               .byte $00      ;Zero (EOT) represents the end of the 
                                   ;... BASIC command.
$080b     bcmd2     .word $0000    ;Address of the next BASIC command.
          ;----------------------------------------------------------------
          ; Start of program.
          ; Here I have chosen to put a "jmp main" instruction as "main" 
          ; is the name of the starting routine of all my programs.
          ;
          ; It is thus possible to put the main subroutine anywhere in the 
          ; program memory without changing this header.
          ;
          ; You can replace main with any address sprcific to your program.
          ; Exemple: 
          ;         jmp $fce2      ;To launch a system RESET.  
          ;----------------------------------------------------------------
$080d               jmp  main      ;The $080d address converts to 2061 décimal.
          ;----------------------------------------------------------------
          ; Assembly language progran that changes the default BASIC 
          ; interface colours.
          ;
          ; IMPORTANT: Since the "SYS" instruction is equivalent to "jsr",
          ;            the program must end with a "RTS" to ensure a normal 
          ;            return to BASIC.     
          ;----------------------------------------------------------------

          ;----------------------------------------------------------------
          ; Starting at this point the program can reside anywhere in 
          ; memory.
          ;----------------------------------------------------------------          
$0810     main      php            ;Choice of "main" for name is arbritrairy.
$0811               pha            ;Save modified register.
$0812     bord      lda  #$05      ;Green for the ...
$0814               sta  $d020     ;... border.
$0817               lda  #$06      ;Blue for the ...
$0819               sta  $d021     ;... background.
$081c               lda  $01       ;White for the ...
$081e               sta  $0286     ;... text.
$0821               lda  #$93      ;Code to clear screen.
$0823               jsr  $ffd2     ;Use of Kernal chrout to put the code.
$0826               pla            ;Restore Acc and the  ... 
$0827               plp            ;... condition code register.
$0828               rts            ;Back to basic BASIC.
          ;----------------------------------------------------------------
          ; End of program.
          ;----------------------------------------------------------------
```     