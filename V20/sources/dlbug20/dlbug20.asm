;--------------------------------------
; Fichier : keyfinder.asm
; Auteur..: Daniel Lafrance
;--------------------------------------
.enc "none"
     .include  "l-v20-bashead-ex.asm"
     Version .null "220260131-192144"
     .include  "m-v20-utils.asm"
;--------------------------------------
main      .block
          #scrcolors vvert,vblanc,vnoir
          #outcar locase
          lda  #' '
          jsr fillscreen
          #ldyxptr $e000
          #styxmem adrptr               ; M: Adresse de depart
          jsr kmenu
          #outcar sbleu
          #outcar 147
          #outcar 19
          #outcar '$'
          #ldyxptr prgend
          jsr putyxhex
          #outcar 13
          #outcar '$'
          #ldyxmem prgend
          jsr putyxhex
          #outcar 13
          rts
          .bend
;--------------------------------------
kmenu     .block
          jsr  pushregs                 ; Sauvegarde les registres.
uneclef                                 ;-------------------------------------
          jsr  putahexdec               ; Affiche .a en 
                                        ; ascii, hexa, bin et dec.
                                        ;-------------------------------------
          jsr  prompt
          jsr  getkey                   ; Attend une clef.
          jsr  chrout
keyesc    cmp  #$5f ;[ESC]              ; Est-ce la touche 'ESC'?
          bne  keyr                     ; Non on verifie une autre.
          jmp  out                      ; Oui, on quitte la fonction
keyr      cmp  #$12 ;[CTRL][R]          ; Est-ce la lettre 'Ctrl+R'?
          bne  keym                     ; Non on verifie une autre.
          jsr  showregs                 ; Oui, affiche les registres.
          jmp  uneclef
keym      cmp  #$4d
          bne  nextkey
          jsr  mvmenu
;          #outcar 13
;          ldyxmem scraddr
;          jsr  putyxhex
;          #outcar 13
;          ldyxmem coladdr
;          jsr  putyxhex


          jmp  uneclef
nextkey   jmp  uneclef   
          ; On cherche une autre clef.
out       jsr  popregs   
          ; Récupère les registres.
          rts
          .bend

prompt    .block
          jsr  pushregs
          ldx  #22
          ldy  #0
          clc
          jsr  plot
          #outcar smauve
          #outcar '>'
          #outcar snoir
          jsr  popregs
          rts
          .bend

;--------------------------------------
     .include  "string-fr.asm"
     ;.include  "string-en.asm"
     .include  "memview.asm"
;--------------------------------------
     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
     .include  "l-v20-math.asm"           
     .include  "l-v20-conv.asm" 
     .include  "l-v20-keyb.asm" 
     .include  "l-v20-screen.asm"
     .include  "l-v20-showregs.asm"
prgend    .word $1234     
;--------------------------------------
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
     .include  "e-v20-vic.asm"
     .include  "e-v20-vars.asm"
     .include  "e-local-vars.asm"
;--------------------------------------

