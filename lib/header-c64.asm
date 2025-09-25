;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: header-c64.asm
; Inspiration ....: 
;--------------------------------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du BASIC 2.0 du 
; COMMODORE C64.
;-------------------------------------------------------------------------------
;*= $800
;.byte $00
;.word (+), 10
;.null $9e, "2061"
;+ .word 0
          *= $0801
;--------------------------------------------------------------------------------
;1 REM*PROGRAMMATION ASSEMBLEUR SUR C64*
;--------------------------------------------------------------------------------
;              .byte $00           ;Basic commence avec un $00 à $0800.
bcmd1          .word bcmd2         ;Adresse de la commande basic suivante.
               .word 1             ;Numero de la ligne Basic.
               .byte $8F           ;Le token de la commande REM du Basic 
                                   ; ($8F=REM)
               .text "*programmation assembleur sur c64*"   
                                   ; texte a afficher suite au REM.
;--------------------------------------------------------------------------------
;2 REM*PAR DANIEL LAFRANCE*
;--------------------------------------------------------------------------------
               .byte $00           ;Un zéro pour indiquer la fin de cette 
bcmd2          .word bcmd3         ;Adresse de la commande basic suivante.
               .word 2             ;Numero de la ligne Basic.
               .byte $8F           ;Le token de la commande REM du Basic 
                                   ; ($8F=REM)
               .text "*par daniel lafrance*"   
                                   ; texte a afficher suite au REM.
;--------------------------------------------------------------------------------
          ;3 SYS02129
;--------------------------------------------------------------------------------
               .byte $00           ;Un zéro pour indiquer la fin de cette 
bcmd3          .word bcmd4         ;Adresse de la commande basic suivante.
               .word 3             ;Numero de la ligne Basic.
               .byte $9e           ;Le token de la commande SYS du Basic
                                   ;... ($9e=SYS)
                                   ;L'adresse le la première instruction
                                   ; assembleur de votre programme
               .text format("%05d",hpgmstart)  
               .byte $00           ;Un zéro pour indiquer la fin de cette 
                                   ;... commande Basic.
bcmd4          .word $0000         ;L'adresse de la commande Basic suivante.
                                   ; $0000 indique la fin du programme.
;--------------------------------------------------------------------------------
; A p p e l   d u  p r o g r a m m e  p r i n c i p a l e .
;--------------------------------------------------------------------------------
hpgmstart     jsr   main           ; Le programme principale doit s'appeler "main" 
              rts                  ; ... doit se rerminer par un RTS.
;--------------------------------------------------------------------------------
