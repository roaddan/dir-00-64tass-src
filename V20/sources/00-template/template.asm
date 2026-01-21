;-----------------------------------------------------------
Version = "20240704-2343040a"
;-----------------------------------------------------------
.include  "l-v20-bashead-ex.asm"
.enc "none"
;-----------------------------------------------------------
TLINE=1
BLINE=5
BCOLM=6
XVAL=$00
XCPX=$00
DIFF=$5
main           
          .block
          #tolower
          #scrcolors vbleu, vnoir
          #color 5
          #outcar revson
          #printxy string3
          #outcar revsoff
          #outcar revson
          #color vocean           
          #printxy string1
          #outcar revsoff
          #color vblanc              
          #printxy string2
          #color vvert          
          #printxy string5
          #color vvert          
          #printxy string6
          #color vmauve              
          #printxy string4
          #color vjaune              
          #printxy string7
          #color vjaune              
          #printxy string8
;-----------------------------------------------------------
          #color vblanc          
          lda #XVAL      ; initialise ... 
          sta count      ; ...le compteur
next      lda count      ; Charge le compteur
          sec
          sbc tstval     ; On on soustrait tstval de count       
          sta result     ;
;-----------------------------------------------------------
; affichage des drapeaux de status.
;-----------------------------------------------------------
          lda  result
          php
          pla
          jsr atobin
          #color vjaune
          #printfmtxy BCOLM, BLINE, "%", binstr
          jsr atohex
          #color vjaune
          #printfmtxy BCOLM+10, BLINE, "$", hexstr
;-----------------------------------------------------------
; affichage des drapeaux de la variable compte.
;-----------------------------------------------------------
          lda count
          jsr atohex
          #color vocean          
          #printfmtxy 5, 9, "$", hexstr
          lda count
          jsr atobin
          #color vocean          
          #printfmtxy 10, 9, "%", binstr
;-----------------------------------------------------------
; affichage des drapeaux de la variable testval.
;-----------------------------------------------------------
          lda tstval
          jsr atohex
          #color vocean          
          #printfmtxy 5, 10, "$", hexstr
          lda tstval
          jsr atobin
          #color vocean          
          #printfmtxy 10, 10, "%", binstr
;-----------------------------------------------------------
; affichage des drapeaux de la variable Resultat.
;-----------------------------------------------------------
          lda result
          jsr atohex
          #color vocean          
          #printfmtxy 5, 12, "$", hexstr
          lda result
          jsr atobin
          #color vocean          
          #printfmtxy 10, 12, "%", binstr


;          lda tstval
;          jsr atohex
;          #color vocean          
;          #printfmtxy BCOLM+10, BLINE, "$", hexstr
;-----------------------------------------------------------
; On effectue les calculs.
;-----------------------------------------------------------
          lda count
          clc
          adc #DIFF
          sta count
          lda tstval
          sec
          sbc #DIFF
          sta tstval
;----------------------------------------------------------
; Traitement de la clef.
;----------------------------------------------------------
          jsr getkey
          cmp  #$5f
          bne continue
          jmp out
continue  #locate 6,18
          jsr atohex
          #printfmtxy 15, 18, "$", hexstr
          #outcar 32
          jsr chrout
          jmp next
;----------------------------------------------------------
; gestion de la sortie
;----------------------------------------------------------
out          
          #outcar 147
          #printwordbin #main
          jsr getkey
          #outcar 147
          ldx  #$7
more      txa
          eor #$0f
          and #$0f 
          sta kcol
          #outstr teststr
          #outstr teststr
          dex
          bpl more
          #outcar 147
          #outcar 145
          #color vblanc
          rts 
          .bend

delay65536     
          .block
          jsr pushregs
          ldx #$00
          ldy #$00
waity     dey
          bne waity
waitx     dex
          bne waity
          jsr popregs
          rts
          .bend
;-----------------------------------------------------------
string1   .text     1,0,"Test de Drapeaux CPU",0
string2   .text     BCOLM-5,BLINE-3,"FLAGS:NV-BDIZC",0
string3   .text     1,21,"Par: Daniel Lafrance",0
string4   .text     BCOLM+9,BLINE,"(   )",0
string5   .byte     BCOLM+1,BLINE-2,94,94,32,94,94,94,94,94,0
string6   .byte     BCOLM+1,BLINE-1,125,125,'?'
          .byte     125,125,125,125,125,0
string7   .text     4,18,"Getkey() = $",0  
string8   .byte     0,9
          .text     '    $',13
          .text     '   -','$    -'
          .byte     13,32,32,32,32,32,45,45,45,32
          .byte     32,45,45,45,45,45,45,45,45,45,13
          .byte     32,32,32
          .null     "=$    ="  
teststr   .byte     revson,32,32
          .text     "               "
          .byte     revsoff,$0d,eot
count     .byte     XVAL
tstval    .byte     XCPX
result    .byte     0
flags     .byte     0
row       .byte     0
lin       .byte     0
adresse   .word     main     
     
  
.include  "l-v20-push.asm" 
.include  "l-v20-string.asm" 
.include  "l-v20-mem.asm"           
.include  "l-v20-math.asm"           
.include  "l-v20-conv.asm" 
.include  "l-v20-keyb.asm"         
.include  "e-v20-vars.asm"
.include  "m-v20-utils.asm"
.include  "e-v20-float.asm"
.include  "e-v20-basic-map.asm"
.include  "e-v20-kernal-map.asm"

