;**************************************
; Fichier : keyfinder.asm
; Auteur..: Daniel Lafrance
Version = "220260131-192144"
;**************************************
.enc "none"
     .include  "l-v20-bashead-ex.asm"
     .include  "m-v20-utils.asm"
;**************************************
main      .block
          #scrcolors vocean,vblanc,vbleu
          #outcar locase
          jsr fillscreen
;**************************************
;          lda  #7
;          sta  $fe
;          lda  #6
;          sta  $fd
;          lda  #5
;          sta  $fc
;          lda  #4
;          sta  $fb
;          lda  #1
;          ldx  #2
;          ldy  #3
;          jsr pushall
;          jsr showstack
;          jsr popall
;**************************************
          jsr kmenu
          #outcar sbleu
          #outcar 19
          rts
          .bend
;**************************************
kmenu     .block
          jsr  pushregs  
          ; Sauvegarde les registres.
uneclef   jsr  getkey    
          ; Attend une clef.
          jsr  putahexdec
          ; Affiche .a en 
          ; ascii, hexa, bin et dec.
          cmp  #$11 ;[CTRL][Q] 
          ; Est-ce la lettre 'Ctrl+Q'?
          bne  keyr      
          ; Non on verifie une autre.
          jmp  out       
          ; Oui, on quitte la fonction
keyr      cmp  #$12 ;[CTRL][R] 
          ; Est-ce la lettre 'Ctrl+R'?
          bne  nextkey   
          ; Non on verifie une autre.
          jsr  showregs  
          ; Oui, affiche les registres.
nextkey   jmp  uneclef   
          ; On cherche une autre clef.
out       jsr  popregs   
          ; Récupère les rehgistres.
          rts
          .bend
sra       .byte     00
srx       .byte     00
sry       .byte     00
ssr       .byte     00
ssp       .byte     00
spcl      .byte     00
spch      .byte     00


;**************************************
;
;**************************************

;**************************************
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
;**************************************
     .include  "string-fr.asm"
     ;.include  "string-en.asm"
;**************************************
     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
     .include  "l-v20-math.asm"           
     .include  "l-v20-conv.asm" 
     .include  "l-v20-keyb.asm" 
     .include  "l-v20-screen.asm"
     .include  "l-v20-showregs.asm"
     .include  "e-v20-vars.asm"
     .include  "e-v20-vic.asm"

