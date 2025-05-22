;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
outsub    .block
          jsr  push           ; Sauvegarde le statut complet.
          ldy  #$ff           ; On détermine 
nxtchr    iny                 ;  le nombre de caractères
          lda  $0100,y        ;  qu'il y a dans la chaine à afficher.
          bne  nxtchr
          iny                 ; On ajoute 1 au nombre trouvé pour compenser
          tya                 ;  l'adresse a y=0.
          pha                 ; Sauvegarde ce nombre.
          lda  #$00           ; On prépare le pointeur $22-$23
          sta  $22            ;  en le peuplant avec 
          lda  #$01           ;  l'adresse ou se trouve la chaine
          sta  $23            ;  à afficher.
          pla                 ; On ramène le nombre de caractères.
          jsr  b_strout       ; On affiche.
          jsr  pop            ; Récupère le statut complet.
          rts
          .bend

insub     .block
          jsr  push           ; Sauvegarde le statut complet.
          jsr  kbflushbuff
          jsr  b_intcgt       ; Initialide chrget
          lda  #$00           ; On efface le basic input buffer 
          ldy  #$59           ;  situé à $200 long de 89 bytes ($59)
clear     sta  b_inpbuff,y    ;  en plaçant des $00 partout
          dey                 ;  et ce jusqu'au
          bne  clear          ;  dernier.
          jsr  b_prompt       ; Affiche un "?" et attend une entrée.
          stx  $7a            ; X et Y pointe sur $01ff au retour.
          sty  $7b
          jsr  b_chrget       ; Lecture du buffer.
          jsr  b_ascflt       ; Conversion la chaine ascii en 200 en float.
                              ;  dans $22(lsb) et $23(msb)
          jsr  pop            ; Récupère le statut complet.
          rts

          .bend

akey      .block
          #print kmsg
          jsr  anykey
          rts
kmsg      .byte b_crlf,b_green,b_crsr_up,b_crsr_right
          .text               "Une clef pour continuer!"
          .byte b_black,b_eot
kmsgend                      
          .bend
