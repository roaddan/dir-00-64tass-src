;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-header-c64.asm
; Inspiration ....: 
;------------------------------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du BASIC 2.0 du 
; COMMODORE C64.
;-------------------------------------------------------------------------------
; Les 5 prochaine lignes constitut la version minimale des lignes de démarrage 
; ... d'un programme Basic.
;*= $800
;.byte $00
;.word (+), 10
;.null $9e, "2061"
;+ .word 0
;------------------------------------------------------------------------------
; Les lignes suivantes constitues le démarrage de mes programmes assembleur 
; créé pour le Commodore 64.
               *= $0800             ;  Le départ de Basic est à $801 (2049).
;------------------------------------------------------------------------------
; 1 REM PROGRAMMATION ASSEMBLEUR SUR C64.
;------------------------------------------------------------------------------
;              .byte $00            ;  Basic commence avec un $00 à $0801.
;bcmd1          .word bcmd2          ;  Adresse de la commande basic suivante.
;               .word 1              ;  Numero de la ligne Basic.
;               .byte $8F            ;  Le token de la commande REM du Basic 
;                                    ;  ... ($8F=REM)
;               .text " programmation assembleur sur c64."   
;                                    ; Texte a afficher suite au REM.
;------------------------------------------------------------------------------
; 2 REM PAR DANIEL LAFRANCE.
;------------------------------------------------------------------------------
;               .byte $00            ;  Un zéro pour indiquer la fin de cette 
;bcmd2          .word bcmd3          ;  Adresse de la commande basic suivante.
;               .word 2              ;  Numero de la ligne Basic.
;               .byte $8F            ;  Le token de la commande REM du Basic 
;                                    ;  ... ($8F=REM)
;               .text " par daniel lafrance."   
;                                    ;  texte a afficher suite au REM.
;------------------------------------------------------------------------------
; 3 SYS02129
;------------------------------------------------------------------------------
               .byte $00            ;  Un zéro pour indiquer la fin de cette 
bcmd3          .word bcmd4          ;  Adresse de la commande basic suivante.
               .word 0              ;  Numero de la ligne Basic.
               .byte $9e            ;  Le token de la commande SYS du Basic
                                    ;  ... ($9e=SYS)
                                    ;  L'adresse le la première instruction
                                    ;  ... assembleur de votre programme
               .text format("%05d",hpgmstart)  
               .byte $00            ;  Un zéro pour indiquer la fin de cette 
                                    ;  ... commande Basic.
bcmd4          .word $0000          ;  L'adresse de la commande Basic suivante.
                                    ;  $0000 indique la fin du programme.
;------------------------------------------------------------------------------
; A p p e l   d u  p r o g r a m m e  p r i n c i p a l e .
;------------------------------------------------------------------------------
hpgmstart      jsr   main           ;  Le programme principale doit s'appeler
                                    ;  ... "main" 
               ;jmp   k_warmstart    ; Basic soft start.
               jmp   cint
               rts                   ;  ... doit se rerminer par un RTS.
;------------------------------------------------------------------------------
